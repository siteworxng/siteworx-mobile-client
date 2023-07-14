import 'package:client/network/rest_apis.dart';
import 'package:client/utils/colors.dart';
import 'package:client/utils/common.dart';
import 'package:client/utils/model_keys.dart';
import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:nb_utils/nb_utils.dart';

import '../../main.dart';

class ForgotPasswordScreen extends StatefulWidget {
  @override
  ForgotPasswordScreenState createState() => ForgotPasswordScreenState();
}

class ForgotPasswordScreenState extends State<ForgotPasswordScreen> {
  TextEditingController emailCont = TextEditingController();
  GlobalKey<FormState> formKey = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();
    init();
  }

  Future<void> init() async {
    //
  }

  Future<void> forgotPwd() async {
    hideKeyboard(context);

    if (formKey.currentState!.validate()) {
      formKey.currentState!.save();
      appStore.setLoading(true);

      Map req = {
        UserKeys.email: emailCont.text.validate(),
      };

      forgotPassword(req).then((res) {
        appStore.setLoading(false);
        finish(context);

        toast(res.message.validate());
      }).catchError((e) {
        toast(e.toString(), print: true);
      }).whenComplete(() => appStore.setLoading(false));
    }
  }

  @override
  void setState(fn) {
    if (mounted) super.setState(fn);
  }

  @override
  Widget build(BuildContext context) {
    return Form(
      autovalidateMode: AutovalidateMode.onUserInteraction,
      key: formKey,
      child: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              padding: EdgeInsets.all(16),
              width: context.width(),
              decoration: boxDecorationDefault(
                color: context.primaryColor,
                borderRadius: radiusOnly(topRight: defaultRadius, topLeft: defaultRadius),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(language.forgotPassword, style: boldTextStyle(color: Colors.white)),
                  IconButton(
                    onPressed: () {
                      finish(context);
                    },
                    icon: Icon(Icons.clear, color: Colors.white, size: 20),
                  )
                ],
              ),
            ),
            Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text("${language.hintEmailAddressTxt}", style: boldTextStyle()),
                6.height,
                Text(language.lblForgotPwdSubtitle, style: secondaryTextStyle()),
                24.height,
                Observer(
                  builder: (_) => AppTextField(
                    textFieldType: TextFieldType.EMAIL_ENHANCED,
                    controller: emailCont,
                    autoFocus: true,
                    errorThisFieldRequired: language.requiredText,
                    decoration: inputDecoration(context, labelText: language.hintEmailTxt),
                  ).visible(!appStore.isLoading, defaultWidget: Loader()),
                ),
                16.height,
                AppButton(
                  text: language.resetPassword,
                  color: primaryColor,
                  textColor: Colors.white,
                  width: context.width() - context.navigationBarHeight,
                  onTap: () {
                    forgotPwd();
                  },
                ),
              ],
            ).paddingAll(16),
          ],
        ),
      ),
    );
  }
}
