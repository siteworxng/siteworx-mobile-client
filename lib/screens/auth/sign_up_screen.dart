import 'package:client/component/back_widget.dart';
import 'package:client/component/loader_widget.dart';
import 'package:client/component/selected_item_widget.dart';
import 'package:client/main.dart';
import 'package:client/model/user_data_model.dart';
import 'package:client/network/rest_apis.dart';
import 'package:client/screens/auth/auth_user_services.dart';
import 'package:client/screens/auth/sign_in_screen.dart';
import 'package:client/screens/dashboard/dashboard_screen.dart';
import 'package:client/utils/colors.dart';
import 'package:client/utils/common.dart';
import 'package:client/utils/configs.dart';
import 'package:client/utils/constant.dart';
import 'package:client/utils/images.dart';
import 'package:client/utils/string_extensions.dart';
import 'package:country_picker/country_picker.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:url_launcher/url_launcher.dart';

class SignUpScreen extends StatefulWidget {
  final String? phoneNumber;
  final String? countryCode;
  final bool isOTPLogin;
  final String? uid;

  SignUpScreen({Key? key, this.phoneNumber, this.isOTPLogin = false, this.countryCode, this.uid}) : super(key: key);

  @override
  _SignUpScreenState createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();
  Country selectedCountry = defaultCountry();

  TextEditingController fNameCont = TextEditingController();
  TextEditingController lNameCont = TextEditingController();
  TextEditingController emailCont = TextEditingController();
  TextEditingController userNameCont = TextEditingController();
  TextEditingController mobileCont = TextEditingController();
  TextEditingController passwordCont = TextEditingController();

  FocusNode fNameFocus = FocusNode();
  FocusNode lNameFocus = FocusNode();
  FocusNode emailFocus = FocusNode();
  FocusNode userNameFocus = FocusNode();
  FocusNode mobileFocus = FocusNode();
  FocusNode passwordFocus = FocusNode();

  bool isAcceptedTc = false;

  @override
  void initState() {
    super.initState();
    init();
  }

  void init() async {
    if (widget.phoneNumber != null) {
      selectedCountry = Country.parse(widget.countryCode.validate(value: selectedCountry.countryCode));

      mobileCont.text = widget.phoneNumber != null ? widget.phoneNumber.toString() : "";
      passwordCont.text = widget.phoneNumber != null ? widget.phoneNumber.toString() : "";
      userNameCont.text = widget.phoneNumber != null ? widget.phoneNumber.toString() : "";
    }
  }

  @override
  void setState(fn) {
    if (mounted) super.setState(fn);
  }

  //region Logic
  String buildMobileNumber() {
    return '${selectedCountry.phoneCode}-${mobileCont.text.trim()}';
  }

  Future<void> registerWithOTP() async {
    hideKeyboard(context);

    if (appStore.isLoading) return;

    if (formKey.currentState!.validate()) {
      formKey.currentState!.save();
      appStore.setLoading(true);

      UserData userResponse = UserData()
        ..username = widget.phoneNumber.validate().trim()
        ..loginType = LOGIN_TYPE_OTP
        ..contactNumber = buildMobileNumber()
        ..email = emailCont.text.trim()
        ..firstName = fNameCont.text.trim()
        ..lastName = lNameCont.text.trim()
        ..playerId = getStringAsync(PLAYERID)
        ..userType = USER_TYPE_USER
        ..uid = widget.uid.validate()
        ..password = widget.phoneNumber.validate().trim();

      await createUsers(tempRegisterData: userResponse);

      return;
    }
  }

  Future<void> changeCountry() async {
    showCountryPicker(
      context: context,
      countryListTheme: CountryListThemeData(textStyle: secondaryTextStyle(color: textSecondaryColorGlobal)),
      showPhoneCode: true, // optional. Shows phone code before the country name.
      onSelect: (Country country) {
        selectedCountry = country;
        setState(() {});
      },
    );
  }

  void registerUser() async {
    hideKeyboard(context);

    if (appStore.isLoading) return;

    if (formKey.currentState!.validate()) {
      formKey.currentState!.save();

      /// If Terms and condition is Accepted then only the user will be registered
      if (isAcceptedTc) {
        appStore.setLoading(true);

        /// Create a temporary request to send
        UserData tempRegisterData = UserData()
          ..contactNumber = buildMobileNumber()
          ..firstName = fNameCont.text.trim()
          ..lastName = lNameCont.text.trim()
          ..userType = USER_TYPE_USER
          ..username = userNameCont.text.trim()
          ..email = emailCont.text.trim()
          ..password = passwordCont.text.trim();

        createUsers(tempRegisterData: tempRegisterData);
      }
    }
  }

  Future<void> createUsers({required UserData tempRegisterData}) async {
    await createUser(tempRegisterData.toJson()).then((registerResponse) async {
      registerResponse.userData!.password = passwordCont.text.trim();
      var request;

      /// After successful entry in the mysql database it will login into firebase.

      if (widget.isOTPLogin) {
        request = {
          'username': widget.phoneNumber.validate(),
          'password': widget.phoneNumber.validate(),
          'player_id': getStringAsync(PLAYERID, defaultValue: ""),
          'login_type': LOGIN_TYPE_OTP,
          "uid": widget.uid.validate(),
        };
      } else {
        request = {
          "email": registerResponse.userData!.email.validate(),
          'password': registerResponse.userData!.password.validate(),
          'player_id': getStringAsync(PLAYERID),
        };
      }

      /// Calling Login API
      await loginCurrentUsers(context, req: request, isSocialLogin: widget.isOTPLogin).then((res) async {
        if (res.$1.userType == LOGIN_TYPE_USER) {
          /// When Login is Successfully done and will redirect to HomeScreen.
          await saveUserData(res.$1);

          DashboardScreen().launch(context, isNewTask: true, pageRouteAnimation: PageRouteAnimation.Fade);

          toast(language.loginSuccessfully, print: true);

          appStore.setLoading(false);
        } else {
          toast(language.lblLoginAgain);
          SignUpScreen().launch(context, isNewTask: true);
        }
      }).catchError((e) {
        toast(language.lblLoginAgain);
        SignInScreen().launch(context, isNewTask: true);
      });
    }).catchError((e) {
      appStore.setLoading(false);
      toast(e.toString());
    });
  }

  //endregion

  //region Widget
  Widget _buildTopWidget() {
    return Column(
      children: [
        Container(
          height: 80,
          width: 80,
          padding: EdgeInsets.all(16),
          child: ic_profile2.iconImage(color: Colors.white),
          decoration: boxDecorationDefault(shape: BoxShape.circle, color: primaryColor),
        ),
        16.height,
        Text(language.lblHelloUser, style: boldTextStyle(size: 22)).center(),
        16.height,
        Text(language.lblSignUpSubTitle, style: secondaryTextStyle(size: 14), textAlign: TextAlign.center).center().paddingSymmetric(horizontal: 32),
      ],
    );
  }

  Widget _buildFormWidget() {
    return Column(
      children: [
        32.height,
        AppTextField(
          textFieldType: TextFieldType.NAME,
          controller: fNameCont,
          focus: fNameFocus,
          nextFocus: lNameFocus,
          errorThisFieldRequired: language.requiredText,
          decoration: inputDecoration(context, labelText: language.hintFirstNameTxt),
          suffix: ic_profile2.iconImage(size: 10).paddingAll(14),
        ),
        16.height,
        AppTextField(
          textFieldType: TextFieldType.NAME,
          controller: lNameCont,
          focus: lNameFocus,
          nextFocus: userNameFocus,
          errorThisFieldRequired: language.requiredText,
          decoration: inputDecoration(context, labelText: language.hintLastNameTxt),
          suffix: ic_profile2.iconImage(size: 10).paddingAll(14),
        ),
        16.height,
        AppTextField(
          textFieldType: TextFieldType.USERNAME,
          controller: userNameCont,
          focus: userNameFocus,
          nextFocus: emailFocus,
          readOnly: widget.isOTPLogin.validate() ? widget.isOTPLogin : false,
          errorThisFieldRequired: language.requiredText,
          decoration: inputDecoration(context, labelText: language.hintUserNameTxt),
          suffix: ic_profile2.iconImage(size: 10).paddingAll(14),
        ),
        16.height,
        AppTextField(
          textFieldType: TextFieldType.EMAIL_ENHANCED,
          controller: emailCont,
          focus: emailFocus,
          errorThisFieldRequired: language.requiredText,
          nextFocus: mobileFocus,
          decoration: inputDecoration(context, labelText: language.hintEmailTxt),
          suffix: ic_message.iconImage(size: 10).paddingAll(14),
        ),
        16.height,
        AppTextField(
          textFieldType: isAndroid ? TextFieldType.PHONE : TextFieldType.NAME,
          controller: mobileCont,
          focus: mobileFocus,
          buildCounter: (_, {required int currentLength, required bool isFocused, required int? maxLength}) {
            return TextButton(
              child: Text(language.lblChangeCountry, style: primaryTextStyle(size: 12)),
              onPressed: () {
                changeCountry();
              },
            );
          },
          errorThisFieldRequired: language.requiredText,
          nextFocus: passwordFocus,
          decoration: inputDecoration(context, labelText: "${language.hintContactNumberTxt}").copyWith(
            prefixText: '+${selectedCountry.phoneCode} ',
            hintText: '${language.lblExample}: ${selectedCountry.example}',
            hintStyle: secondaryTextStyle(),
          ),
          suffix: ic_calling.iconImage(size: 10).paddingAll(14),
        ),
        4.height,
        AppTextField(
          textFieldType: TextFieldType.PASSWORD,
          controller: passwordCont,
          focus: passwordFocus,
          readOnly: widget.isOTPLogin.validate() ? widget.isOTPLogin : false,
          suffixPasswordVisibleWidget: ic_show.iconImage(size: 10).paddingAll(14),
          suffixPasswordInvisibleWidget: ic_hide.iconImage(size: 10).paddingAll(14),
          errorThisFieldRequired: language.requiredText,
          decoration: inputDecoration(context, labelText: language.hintPasswordTxt),
          onFieldSubmitted: (s) {
            if (widget.isOTPLogin) {
              registerWithOTP();
            } else {
              registerUser();
            }
          },
        ),
        20.height,
        _buildTcAcceptWidget(),
        8.height,
        AppButton(
          text: language.signUp,
          color: primaryColor,
          textColor: Colors.white,
          width: context.width() - context.navigationBarHeight,
          onTap: () {
            if (widget.isOTPLogin) {
              registerWithOTP();
            } else {
              registerUser();
            }
          },
        ),
      ],
    );
  }

  Widget _buildTcAcceptWidget() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        SelectedItemWidget(isSelected: isAcceptedTc).onTap(() async {
          isAcceptedTc = !isAcceptedTc;
          setState(() {});
        }),
        16.width,
        RichTextWidget(
          list: [
            TextSpan(text: '${language.lblAgree} ', style: secondaryTextStyle()),
            TextSpan(
              text: language.lblTermsOfService,
              style: boldTextStyle(color: primaryColor, size: 14),
              recognizer: TapGestureRecognizer()
                ..onTap = () {
                  commonLaunchUrl(TERMS_CONDITION_URL, launchMode: LaunchMode.externalApplication);
                },
            ),
            TextSpan(text: ' & ', style: secondaryTextStyle()),
            TextSpan(
              text: language.privacyPolicy,
              style: boldTextStyle(color: primaryColor, size: 14),
              recognizer: TapGestureRecognizer()
                ..onTap = () {
                  commonLaunchUrl(PRIVACY_POLICY_URL, launchMode: LaunchMode.externalApplication);
                },
            ),
          ],
        ).flexible(flex: 2),
      ],
    ).paddingSymmetric(vertical: 16);
  }

  Widget _buildFooterWidget() {
    return Column(
      children: [
        16.height,
        RichTextWidget(
          list: [
            TextSpan(text: "${language.alreadyHaveAccountTxt} ? ", style: secondaryTextStyle()),
            TextSpan(
              text: language.signIn,
              style: boldTextStyle(color: primaryColor, size: 14),
              recognizer: TapGestureRecognizer()
                ..onTap = () {
                  finish(context);
                },
            ),
          ],
        ),
        30.height,
      ],
    );
  }

  //endregion

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        backgroundColor: context.scaffoldBackgroundColor,
        leading: BackWidget(iconColor: context.iconColor),
        scrolledUnderElevation: 0,
        systemOverlayStyle: SystemUiOverlayStyle(statusBarIconBrightness: appStore.isDarkMode ? Brightness.light : Brightness.dark, statusBarColor: context.scaffoldBackgroundColor),
      ),
      body: SizedBox(
        width: context.width(),
        child: Stack(
          children: [
            Form(
              key: formKey,
              autovalidateMode: AutovalidateMode.onUserInteraction,
              child: SingleChildScrollView(
                padding: EdgeInsets.all(16),
                child: Column(
                  children: [
                    _buildTopWidget(),
                    _buildFormWidget(),
                    8.height,
                    _buildFooterWidget(),
                  ],
                ),
              ),
            ),
            Observer(builder: (_) => LoaderWidget().center().visible(appStore.isLoading)),
          ],
        ),
      ),
    );
  }
}
