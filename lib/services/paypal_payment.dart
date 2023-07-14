import 'package:client/model/booking_detail_model.dart';

class PaypalPayment {
  num totalAmount;
  String payPalUrl;
  BookingDetailResponse bookDetailData;

  PaypalPayment({required this.payPalUrl, required this.totalAmount, required this.bookDetailData});

/*void brainTreeDrop() async {
    var request = BraintreeDropInRequest(
      tokenizationKey: payPalUrl,
      collectDeviceData: true,
      googlePaymentRequest: BraintreeGooglePaymentRequest(
        totalPrice: totalAmount.toString(),
        currencyCode: appStore.currencyCode,
        billingAddressRequired: false,
      ),
      paypalRequest: BraintreePayPalRequest(amount: totalAmount.toString(), currencyCode: "USD"),
      cardEnabled: true,
    );
    final result = await BraintreeDropIn.start(request);
    if (result != null) {
      log("TXNID?" + result.paymentMethodNonce.nonce);
      log("TXNTYPE_LABEL?" + result.paymentMethodNonce.typeLabel);
      log("desc" + result.paymentMethodNonce.description);
      log("Default" + result.paymentMethodNonce.isDefault.toString());
      await savePay(
        data: bookDetailData,
        paymentMethod: PAYPAL,
        paymentStatus: SERVICE_PAYMENT_STATUS_PAID,
        totalAmount: totalAmount,
        txnId: result.paymentMethodNonce.nonce.validate(),
      );
    }
    appStore.setLoading(false);
    log("result call1");
  }*/
}
