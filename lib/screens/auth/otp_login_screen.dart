import 'dart:convert';

import 'package:client/component/back_widget.dart';
import 'package:client/component/base_scaffold_body.dart';
import 'package:client/main.dart';
import 'package:client/utils/colors.dart';
import 'package:client/utils/common.dart';
import 'package:country_picker/country_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:nb_utils/nb_utils.dart';

import '../../utils/configs.dart';

class OTPLoginScreen extends StatefulWidget {
  const OTPLoginScreen({Key? key}) : super(key: key);

  @override
  State<OTPLoginScreen> createState() => _OTPLoginScreenState();
}

class _OTPLoginScreenState extends State<OTPLoginScreen> {
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();

  TextEditingController numberController = TextEditingController();

  Country selectedCountry = defaultCountry();

  @override
  void initState() {
    super.initState();
    afterBuildCreated(() => init());
  }

  Future<void> init() async {
    appStore.setLoading(false);
  }

  //region Methods
  Future<void> changeCountry() async {
    showCountryPicker(
      context: context,
      showPhoneCode: true, // optional. Shows phone code before the country name.
      onSelect: (Country country) {
        selectedCountry = country;
        log(jsonEncode(selectedCountry.toJson()));
        setState(() {});
      },
    );
  }

  Future<void> sendOTP() async {
    if (formKey.currentState!.validate()) {
      formKey.currentState!.save();
      hideKeyboard(context);

      appStore.setLoading(true);

      toast(language.sendingOTP);

      await authService.loginWithOTP(context, phoneNumber: numberController.text.trim(), countryCode: selectedCountry.phoneCode, countryISOCode: selectedCountry.countryCode).then((value) {
        //
      }).catchError(
        (e) {
          appStore.setLoading(false);

          toast(e.toString(), print: true);
        },
      );
    }
  }

  // endregion

  Widget _buildMainWidget() {
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(language.lblEnterPhnNumber, style: boldTextStyle()),
        16.height,
        Form(
          key: formKey,
          child: AppTextField(
            controller: numberController,
            textFieldType: TextFieldType.PHONE,
            decoration: inputDecoration(context).copyWith(
              prefixText: '+${selectedCountry.phoneCode} ',
              hintText: '${language.lblExample}: ${selectedCountry.example}',
            ),
            autoFocus: true,
            onFieldSubmitted: (s) {
              sendOTP();
            },
          ),
        ),
        30.height,
        AppButton(
          onTap: () {
            sendOTP();
          },
          text: language.btnSendOtp,
          color: primaryColor,
          textColor: Colors.white,
          width: context.width(),
        ),
        16.height,
        AppButton(
          onTap: () {
            changeCountry();
          },
          text: language.lblChangeCountry,
          textStyle: boldTextStyle(),
          width: context.width(),
        ),
      ],
    );
  }

  @override
  void setState(fn) {
    if (mounted) super.setState(fn);
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
        child: Container(
          padding: EdgeInsets.all(16),
          child: _buildMainWidget(),
        ),
      ),
    );
  }
}
