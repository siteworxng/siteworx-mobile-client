import 'package:client/component/back_widget.dart';
import 'package:client/component/base_scaffold_body.dart';
import 'package:client/main.dart';
import 'package:client/network/rest_apis.dart';
import 'package:client/screens/auth/auth_user_services.dart';
import 'package:client/screens/auth/forgot_password_screen.dart';
import 'package:client/screens/auth/otp_login_screen.dart';
import 'package:client/screens/auth/sign_up_screen.dart';
import 'package:client/screens/dashboard/dashboard_screen.dart';
import 'package:client/utils/colors.dart';
import 'package:client/utils/common.dart';
import 'package:client/utils/configs.dart';
import 'package:client/utils/constant.dart';
import 'package:client/utils/images.dart';
import 'package:client/utils/string_extensions.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:url_launcher/url_launcher.dart';

class SignInScreen extends StatefulWidget {
  final bool? isFromDashboard;
  final bool? isFromServiceBooking;
  final bool returnExpected;
  final bool isRegeneratingToken;

  SignInScreen({this.isFromDashboard, this.isFromServiceBooking, this.returnExpected = false, this.isRegeneratingToken = false});

  @override
  _SignInScreenState createState() => _SignInScreenState();
}

class _SignInScreenState extends State<SignInScreen> {
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();

  TextEditingController emailCont = TextEditingController();
  TextEditingController passwordCont = TextEditingController();

  FocusNode emailFocus = FocusNode();
  FocusNode passwordFocus = FocusNode();

  bool isRemember = true;

  @override
  void initState() {
    super.initState();
    init();
  }

  void init() async {
    if (await isIqonicProduct) {
      emailCont.text = DEFAULT_EMAIL;
      passwordCont.text = DEFAULT_PASS;
    }

    isRemember = getBoolAsync(IS_REMEMBERED, defaultValue: true);
    if (isRemember) {
      emailCont.text = getStringAsync(USER_EMAIL, defaultValue: DEFAULT_EMAIL);
      passwordCont.text = getStringAsync(USER_PASSWORD, defaultValue: DEFAULT_PASS);
    }

    if (widget.isRegeneratingToken) {
      if (isLoginTypeUser) {
        emailCont.text = appStore.userEmail;
        passwordCont.text = getStringAsync(USER_PASSWORD);

        _handleLogin(isDirectLogin: true);
      } else if (isLoginTypeGoogle) {
        googleSignIn();
      } else if (isLoginTypeApple) {
        appleSign();
      } else if (isLoginTypeOTP) {
        toast(language.lblLoginAgain);
        logoutApi().then((value) async {
          //
        }).catchError((e) {
          log(e.toString());
        });

        await clearPreferences();
      }
    }
  }

  //region Methods

  void _handleLogin({bool isDirectLogin = false}) {
    if (isDirectLogin) {
      _handleLoginUsers();
    } else {
      hideKeyboard(context);
      if (formKey.currentState!.validate()) {
        formKey.currentState!.save();
        _handleLoginUsers();
      }
    }
  }

  void _handleLoginUsers() async {
    hideKeyboard(context);
    Map<String, dynamic> request = {
      'email': emailCont.text.trim(),
      'password': passwordCont.text.trim(),
      'player_id': getStringAsync(PLAYERID),
    };

    log(request);

    await loginCurrentUsers(context, req: request).then((value) async {
      if (isRemember) {
        setValue(USER_EMAIL, emailCont.text);
        setValue(USER_PASSWORD, passwordCont.text);
        await setValue(IS_REMEMBERED, isRemember);
      }

      await saveUserData(value.$1);
      onLoginSuccessRedirection();
      toast("Login Successfully");
    }).catchError((e) {
      appStore.setLoading(false);
      toast(e.toString());
    });
  }

  void googleSignIn() async {
    appStore.setLoading(true);

    await authService.signInWithGoogle(context).then((value) async {
      await saveUserData(value.$1);
      onLoginSuccessRedirection();
    }).catchError((e) {
      toast(e.toString());
    });
  }

  void otpSignIn() async {
    hideKeyboard(context);

    OTPLoginScreen().launch(context);
  }

  void onLoginSuccessRedirection() {
    TextInput.finishAutofillContext();
    if (widget.isFromServiceBooking.validate() || widget.isFromDashboard.validate() || widget.returnExpected.validate()) {
      if (widget.isFromDashboard.validate()) {
        setStatusBarColor(context.primaryColor);
      }
      finish(context, true);
    } else {
      DashboardScreen().launch(context, isNewTask: true, pageRouteAnimation: PageRouteAnimation.Fade);
    }
    appStore.setLoading(false);
  }

  void appleSign() async {
    appStore.setLoading(true);

    await authService.appleSignIn().then((value) async {
      appStore.setLoading(false);

      onLoginSuccessRedirection();
    }).catchError((e) {
      appStore.setLoading(false);
      toast(e.toString());
    });
  }

//endregion

//region Widgets
  Widget _buildTopWidget() {
    return Container(
      child: Column(
        children: [
          Text("${language.lblLoginTitle}!", style: boldTextStyle(size: 20)).center(),
          16.height,
          Text(language.lblLoginSubTitle, style: primaryTextStyle(size: 14), textAlign: TextAlign.center).center().paddingSymmetric(horizontal: 32),
          32.height,
        ],
      ),
    );
  }

  Widget _buildFormWidget() {
    return AutofillGroup(
      child: Column(
        children: [
          AppTextField(
            textFieldType: TextFieldType.EMAIL_ENHANCED,
            controller: emailCont,
            focus: emailFocus,
            nextFocus: passwordFocus,
            errorThisFieldRequired: language.requiredText,
            decoration: inputDecoration(context, labelText: language.hintEmailTxt),
            suffix: ic_message.iconImage(size: 10).paddingAll(14),
            autoFillHints: [AutofillHints.email],
          ),
          16.height,
          AppTextField(
            textFieldType: TextFieldType.PASSWORD,
            controller: passwordCont,
            focus: passwordFocus,
            suffixPasswordVisibleWidget: ic_show.iconImage(size: 10).paddingAll(14),
            suffixPasswordInvisibleWidget: ic_hide.iconImage(size: 10).paddingAll(14),
            decoration: inputDecoration(context, labelText: language.hintPasswordTxt),
            autoFillHints: [AutofillHints.password],
            onFieldSubmitted: (s) {
              _handleLogin();
            },
          ),
        ],
      ),
    );
  }

  Widget _buildRememberWidget() {
    return Column(
      children: [
        8.height,
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            RoundedCheckBox(
              borderColor: context.primaryColor,
              checkedColor: context.primaryColor,
              isChecked: isRemember,
              text: language.rememberMe,
              textStyle: secondaryTextStyle(),
              size: 20,
              onTap: (value) async {
                await setValue(IS_REMEMBERED, isRemember);
                isRemember = !isRemember;
                setState(() {});
              },
            ),
            TextButton(
              onPressed: () {
                showInDialog(
                  context,
                  contentPadding: EdgeInsets.zero,
                  dialogAnimation: DialogAnimation.SLIDE_TOP_BOTTOM,
                  builder: (_) => ForgotPasswordScreen(),
                );
              },
              child: Text(
                language.forgotPassword,
                style: boldTextStyle(color: primaryColor, fontStyle: FontStyle.italic),
                textAlign: TextAlign.right,
              ),
            ).flexible(),
          ],
        ),
        24.height,
        AppButton(
          text: language.signIn,
          color: primaryColor,
          textColor: Colors.white,
          width: context.width() - context.navigationBarHeight,
          onTap: () {
            _handleLogin();
          },
        ),
        16.height,
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(language.doNotHaveAccount, style: secondaryTextStyle()),
            TextButton(
              onPressed: () {
                hideKeyboard(context);
                SignUpScreen().launch(context);
              },
              child: Text(
                language.signUp,
                style: boldTextStyle(
                  color: primaryColor,
                  decoration: TextDecoration.underline,
                  fontStyle: FontStyle.italic,
                ),
              ),
            ),
          ],
        ),
        TextButton(
          onPressed: () {
            if (isAndroid) {
              if (getStringAsync(PROVIDER_PLAY_STORE_URL).isNotEmpty) {
                launchUrl(Uri.parse(getStringAsync(PROVIDER_PLAY_STORE_URL)), mode: LaunchMode.externalApplication);
              } else {
                launchUrl(Uri.parse('${getSocialMediaLink(LinkProvider.PLAY_STORE)}$PROVIDER_PACKAGE_NAME'), mode: LaunchMode.externalApplication);
              }
            } else if (isIOS) {
              if (getStringAsync(PROVIDER_APPSTORE_URL).isNotEmpty) {
                commonLaunchUrl(getStringAsync(PROVIDER_APPSTORE_URL));
              } else {
                commonLaunchUrl(IOS_LINK_FOR_PARTNER);
              }
            }
          },
          child: Text(language.lblRegisterAsPartner, style: boldTextStyle(color: primaryColor)),
        )
      ],
    );
  }

  Widget _buildSocialWidget() {
    return Column(
      children: [
        20.height,
        Row(
          children: [
            Divider(color: context.dividerColor, thickness: 2).expand(),
            16.width,
            Text(language.lblOrContinueWith, style: secondaryTextStyle()),
            16.width,
            Divider(color: context.dividerColor, thickness: 2).expand(),
          ],
        ),
        24.height,
        AppButton(
          text: '',
          color: context.cardColor,
          padding: EdgeInsets.all(8),
          textStyle: boldTextStyle(),
          width: context.width() - context.navigationBarHeight,
          child: Row(
            children: [
              Container(
                padding: EdgeInsets.all(12),
                decoration: boxDecorationWithRoundedCorners(
                  backgroundColor: primaryColor.withOpacity(0.1),
                  boxShape: BoxShape.circle,
                ),
                child: GoogleLogoWidget(size: 16),
              ),
              Text(language.lblSignInWithGoogle, style: boldTextStyle(size: 12), textAlign: TextAlign.center).expand(),
            ],
          ),
          onTap: googleSignIn,
        ),
        16.height,
        AppButton(
          text: '',
          color: context.cardColor,
          padding: EdgeInsets.all(8),
          textStyle: boldTextStyle(),
          width: context.width() - context.navigationBarHeight,
          child: Row(
            children: [
              Container(
                padding: EdgeInsets.all(8),
                decoration: boxDecorationWithRoundedCorners(
                  backgroundColor: primaryColor.withOpacity(0.1),
                  boxShape: BoxShape.circle,
                ),
                child: ic_calling.iconImage(size: 18, color: primaryColor).paddingAll(4),
              ),
              Text(language.lblSignInWithOTP, style: boldTextStyle(size: 12), textAlign: TextAlign.center).expand(),
            ],
          ),
          onTap: otpSignIn,
        ),
        16.height,
        if (isIOS)
          AppButton(
            text: '',
            color: context.cardColor,
            padding: EdgeInsets.all(8),
            textStyle: boldTextStyle(),
            width: context.width() - context.navigationBarHeight,
            child: Row(
              children: [
                Container(
                  padding: EdgeInsets.all(8),
                  decoration: boxDecorationWithRoundedCorners(
                    backgroundColor: primaryColor.withOpacity(0.1),
                    boxShape: BoxShape.circle,
                  ),
                  child: Icon(Icons.apple),
                ),
                Text(language.lblSignInWithApple, style: boldTextStyle(size: 12), textAlign: TextAlign.center).expand(),
              ],
            ),
            onTap: appleSign,
          ),
      ],
    );
  }

//endregion

  @override
  void setState(fn) {
    if (mounted) super.setState(fn);
  }

  @override
  void dispose() {
    if (widget.isFromServiceBooking.validate()) {
      setStatusBarColor(Colors.transparent, statusBarIconBrightness: Brightness.dark);
    } else if (widget.isFromDashboard.validate()) {
      setStatusBarColor(Colors.transparent, statusBarIconBrightness: Brightness.light);
    } else {
      setStatusBarColor(primaryColor, statusBarIconBrightness: Brightness.light);
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        backgroundColor: context.scaffoldBackgroundColor,
        leading: Navigator.of(context).canPop() ? BackWidget(iconColor: context.iconColor) : null,
        scrolledUnderElevation: 0,
        systemOverlayStyle: SystemUiOverlayStyle(statusBarIconBrightness: appStore.isDarkMode ? Brightness.light : Brightness.dark, statusBarColor: context.scaffoldBackgroundColor),
      ),
      body: Body(
        child: Form(
          key: formKey,
          autovalidateMode: AutovalidateMode.onUserInteraction,
          child: SingleChildScrollView(
            padding: EdgeInsets.all(16),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                (context.height() * 0.05).toInt().height,
                _buildTopWidget(),
                _buildFormWidget(),
                _buildRememberWidget(),
                if (!getBoolAsync(HAS_IN_REVIEW)) _buildSocialWidget(),
                30.height,
              ],
            ),
          ),
        ),
      ),
    );
  }
}
