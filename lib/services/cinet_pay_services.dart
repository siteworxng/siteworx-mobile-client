import 'dart:math';

import 'package:client/main.dart';
import 'package:client/model/booking_detail_model.dart';
import 'package:client/services/razor_pay_services.dart';
import 'package:client/utils/constant.dart';
import 'package:cinetpay/cinetpay.dart';
import 'package:flutter/material.dart';
import 'package:nb_utils/nb_utils.dart';

class CinetPayServices {
  String cinetPayApiKey;
  String siteId;
  String secretKey;
  num totalAmount;
  BookingDetailResponse bookDetailData;

  // Local Variable
  Map<String, dynamic>? response;

  CinetPayServices({required this.cinetPayApiKey, required this.totalAmount, required this.bookDetailData, required this.siteId, required this.secretKey});

  final String transactionId = Random().nextInt(100000000).toString();

  Future<void> payWithCinetPay({required BuildContext context}) async {
    await Navigator.push(getContext, MaterialPageRoute(builder: (_) => cinetPay()));
    appStore.setLoading(false);
  }

  Widget cinetPay() {
    return CinetPayCheckout(
      title: language.lblCheckOutWithCinetPay,
      configData: <String, dynamic>{
        'apikey': cinetPayApiKey,
        'site_id': siteId,
        'notify_url': 'http://mondomaine.com/notify/',
        'mode': 'PRODUCTION',
      },
      paymentData: <String, dynamic>{
        'transaction_id': transactionId,
        'amount': totalAmount,
        'currency': appStore.currencyCode,
        'channels': 'ALL',
        'description': '',
      },
      waitResponse: (data) {
        response = data;
        log(response);

        if (data['status'] == "REFUSED") {
          toast(language.yourPaymentFailedPleaseTryAgain);
        } else if (data['status'] == "ACCEPTED") {
          toast(language.yourPaymentHasBeenMadeSuccessfully);
          appStore.setLoading(false);
          savePay(data: bookDetailData, paymentMethod: PAYMENT_METHOD_CINETPAY, paymentStatus: SERVICE_PAYMENT_STATUS_PAID, totalAmount: totalAmount);
        }
      },
      onError: (data) {
        response = data;
        log(response);
        appStore.setLoading(false);
      },
    );
  }
}
