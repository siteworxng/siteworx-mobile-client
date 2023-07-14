import 'package:client/main.dart';
import 'package:client/model/booking_detail_model.dart';
import 'package:client/network/rest_apis.dart';
import 'package:client/screens/dashboard/dashboard_screen.dart';
import 'package:client/utils/common.dart';
import 'package:client/utils/configs.dart';
import 'package:client/utils/constant.dart';
import 'package:client/utils/model_keys.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:razorpay_flutter/razorpay_flutter.dart';

class RazorPayServices {
  static late Razorpay razorPay;
  static late String razorKeys;
  static late BookingDetailResponse dataValue;
  static num totalAmount = 0;

  static init({required String razorKey, required BookingDetailResponse data, required num totalamount}) {
    razorPay = Razorpay();
    razorPay.on(Razorpay.EVENT_PAYMENT_SUCCESS, RazorPayServices.handlePaymentSuccess);
    razorPay.on(Razorpay.EVENT_PAYMENT_ERROR, RazorPayServices.handlePaymentError);
    razorPay.on(Razorpay.EVENT_EXTERNAL_WALLET, RazorPayServices.handleExternalWallet);
    razorKeys = razorKey;
    dataValue = data;
    totalamount = totalamount;
  }

  static void handlePaymentSuccess(PaymentSuccessResponse response) async {
    savePay(
      data: dataValue,
      paymentMethod: PAYMENT_METHOD_RAZOR,
      paymentStatus: SERVICE_PAYMENT_STATUS_PAID,
      txnId: response.paymentId,
      totalAmount: totalAmount,
    );
  }

  static void handlePaymentError(PaymentFailureResponse response) {
    toast("Error: " + response.code.toString() + " - " + response.message!, print: true);
  }

  static void handleExternalWallet(ExternalWalletResponse response) {
    toast("${language.externalWallet}: " + response.walletName!);
  }

  static void razorPayCheckout(num mAmount) async {
    log('razorPay AMOUNT: $mAmount');
    var options = {
      'key': razorKeys,
      'amount': (mAmount * 100),
      'name': APP_NAME,
      'theme.color': '#5f60b9',
      'description': APP_NAME_TAG_LINE,
      'image': 'https://razorpay.com/assets/razorpay-glyph.svg',
      'currency': appStore.currencyCode,
      'prefill': {'contact': appStore.userContactNumber, 'email': appStore.userEmail},
      'external': {
        'wallets': ['paytm']
      }
    };
    try {
      razorPay.open(options);
    } catch (e) {
      debugPrint(e.toString());
    }
  }
}

Future<void> savePay({
  String? paymentMethod,
  String? txnId,
  String? paymentStatus = SERVICE_PAYMENT_STATUS_PENDING,
  required BookingDetailResponse data,
  num? totalAmount,
}) async {
  Map request = {
    CommonKeys.bookingId: data.bookingDetail!.id.validate(),
    CommonKeys.customerId: appStore.userId,
    CouponKeys.discount: data.bookingDetail!.discount.validate(),
    BookingServiceKeys.totalAmount: data.bookingDetail!.isPackageBooking
        ? totalAmount
        : totalAmount ??
            calculateTotalAmount(
              servicePrice: data.bookingDetail!.price.validate(),
              qty: data.bookingDetail!.quantity.validate(),
              serviceDiscountPercent: data.bookingDetail!.discount,
              taxes: data.bookingDetail!.taxes,
              couponData: data.couponData,
              extraCharges: data.bookingDetail!.extraCharges,
            ),
    CommonKeys.dateTime: DateFormat(BOOKING_SAVE_FORMAT).format(DateTime.now()),
    CommonKeys.txnId: txnId != '' ? txnId : "#${data.bookingDetail!.id.validate()}",
    CommonKeys.paymentStatus: paymentStatus,
    CommonKeys.paymentMethod: paymentMethod
  };

  if (data.service != null && data.service!.isAdvancePayment) {
    request[AdvancePaymentKey.advancePaymentAmount] = totalAmount;

    if ((data.bookingDetail!.paymentStatus == null || data.bookingDetail!.paymentStatus != SERVICE_PAYMENT_STATUS_ADVANCE_PAID || data.bookingDetail!.paymentStatus != SERVICE_PAYMENT_STATUS_PAID) &&
        (data.bookingDetail!.paidAmount == null || data.bookingDetail!.paidAmount.validate() < 1)) {
      request[CommonKeys.paymentStatus] = SERVICE_PAYMENT_STATUS_ADVANCE_PAID;
    } else if (data.bookingDetail!.paymentStatus == SERVICE_PAYMENT_STATUS_ADVANCE_PAID) {
      request[CommonKeys.paymentStatus] = SERVICE_PAYMENT_STATUS_PAID;
    }
  }

  log(request);

  appStore.setLoading(true);

  await savePayment(request).then((value) {
    appStore.setLoading(false);
    push(DashboardScreen(redirectToBooking: true), isNewTask: true, pageRouteAnimation: PageRouteAnimation.Fade);
  }).catchError((e) {
    toast(language.somethingWentWrong);
    appStore.setLoading(false);
  });
}
