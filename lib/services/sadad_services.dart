import 'package:client/main.dart';
import 'package:client/model/booking_detail_model.dart';
import 'package:client/network/rest_apis.dart';
import 'package:client/screens/payment/payment_webview_screen.dart';
import 'package:client/services/razor_pay_services.dart';
import 'package:client/utils/constant.dart';
import 'package:flutter/cupertino.dart';
import 'package:nb_utils/nb_utils.dart';

class SadadServices {
  String sadadId;
  String sadadKey;
  String sadadDomain;
  num totalAmount;
  BookingDetailResponse bookDetailData;

  SadadServices({required this.sadadId, required this.sadadKey, required this.sadadDomain, required this.totalAmount, required this.bookDetailData});

  Future<void> payWithSadad(BuildContext context) async {
    Map request = {
      "sadadId": sadadId,
      "secretKey": sadadKey,
      "domain": sadadDomain,
    };

    await sadadLogin(request).then((accessToken) async {
      await createInvoice(context, accessToken: accessToken).then((value) async {
        //
      }).catchError((e) {
        appStore.setLoading(false);
        toast(e.toString());
      });
    }).catchError((e) {
      appStore.setLoading(false);
      toast(e.toString());
    });
  }

  Future<void> createInvoice(BuildContext context, {required String accessToken}) async {
    Map<String, dynamic> req = {
      "countryCode": 974,
      "clientname": appStore.userName.validate(),
      "cellnumber": appStore.userContactNumber.validate().splitAfter('-'),
      "invoicedetails": [
        {
          "description": bookDetailData.service!.name.validate(),
          "quantity": 1,
          "amount": totalAmount,
        },
      ],
      "status": 2,
      "remarks": bookDetailData.service!.name.validate(),
      "amount": totalAmount,
    };
    sadadCreateInvoice(request: req, sadadToken: accessToken).then((value) async {
      appStore.setLoading(false);
      log('val:${value[0]['shareUrl']}');

      String? res = await PaymentWebViewScreen(url: value[0]['shareUrl'], accessToken: accessToken).launch(context);

      if (res.validate().isNotEmpty) {
        savePay(data: bookDetailData, paymentMethod: PAYMENT_METHOD_SADAD_PAYMENT, paymentStatus: SERVICE_PAYMENT_STATUS_PAID, txnId: res, totalAmount: totalAmount);
      } else {
        toast(language.transactionFailed, print: true);
      }
    }).catchError((e) {
      appStore.setLoading(false);
      toast('Error: $e', print: true);
    });
  }
}
// Handle CinetPayment
