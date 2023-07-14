import 'package:client/main.dart';
import 'package:client/network/rest_apis.dart';
import 'package:client/utils/colors.dart';
import 'package:client/utils/common.dart';
import 'package:client/utils/model_keys.dart';
import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:nb_utils/nb_utils.dart';

class InvoiceRequestDialogComponent extends StatefulWidget {
  final int? bookingId;

  InvoiceRequestDialogComponent({required this.bookingId});

  @override
  State<InvoiceRequestDialogComponent> createState() => _InvoiceRequestDialogComponentState();
}

class _InvoiceRequestDialogComponentState extends State<InvoiceRequestDialogComponent> {
  GlobalKey<FormState> formKey = GlobalKey<FormState>();

  TextEditingController emailCont = TextEditingController();

  @override
  void initState() {
    init();
    super.initState();
  }

  void init() async {
    emailCont.text = appStore.userEmail.validate();
  }

  Future<void> sentMail() async {
    hideKeyboard(context);

    if (formKey.currentState!.validate()) {
      formKey.currentState!.save();
      appStore.setLoading(true);

      Map req = {
        UserKeys.email: emailCont.text.validate(),
        CommonKeys.bookingId: widget.bookingId.validate(),
      };

      sentInvoiceOnMail(req).then((res) {
        appStore.setLoading(false);
        finish(context, true);

        toast(res.message.validate());
      }).catchError((e) {
        toast(e.toString(), print: true);
      }).whenComplete(() => appStore.setLoading(false));
    }
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
              decoration: boxDecorationDefault(color: context.primaryColor, borderRadius: radiusOnly(topRight: defaultRadius, topLeft: defaultRadius)),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(language.requestInvoice, style: boldTextStyle(color: Colors.white)),
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
                Text(language.invoiceSubTitle, style: primaryTextStyle()),
                20.height,
                Observer(
                  builder: (_) => AppTextField(
                    textFieldType: TextFieldType.EMAIL_ENHANCED,
                    controller: emailCont,
                    errorThisFieldRequired: language.requiredText,
                    decoration: inputDecoration(context, labelText: language.hintEmailTxt),
                  ).visible(!appStore.isLoading, defaultWidget: Loader()),
                ),
                30.height,
                AppButton(
                  text: language.send,
                  height: 40,
                  color: primaryColor,
                  textStyle: primaryTextStyle(color: white),
                  width: context.width() - context.navigationBarHeight,
                  onTap: () {
                    sentMail();
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
