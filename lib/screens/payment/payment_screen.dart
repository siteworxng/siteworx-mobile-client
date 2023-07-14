import 'package:client/component/back_widget.dart';
import 'package:client/component/loader_widget.dart';
import 'package:client/main.dart';
import 'package:client/model/booking_detail_model.dart';
import 'package:client/screens/booking/component/price_common_widget.dart';
import 'package:client/services/cinet_pay_services.dart';
import 'package:client/services/flutter_wave_services.dart';
import 'package:client/services/razor_pay_services.dart';
import 'package:client/services/sadad_services.dart';
import 'package:client/services/stripe_services.dart';
import 'package:client/utils/colors.dart';
import 'package:client/utils/common.dart';
import 'package:client/utils/constant.dart';
import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:nb_utils/nb_utils.dart';

import '../../component/empty_error_state_widget.dart';
import '../../component/wallet_balance_component.dart';
import '../../model/configuration_response.dart';
import '../../network/rest_apis.dart';

class PaymentScreen extends StatefulWidget {
  final BookingDetailResponse bookings;
  final bool isForAdvancePayment;

  PaymentScreen({required this.bookings, this.isForAdvancePayment = false});

  @override
  _PaymentScreenState createState() => _PaymentScreenState();
}

class _PaymentScreenState extends State<PaymentScreen> {
  List<PaymentSetting> paymentList = [];

  PaymentSetting? currentPaymentMethod;

  num totalAmount = 0;

  @override
  void initState() {
    super.initState();
    init();
  }

  void init() async {
    paymentList = PaymentSetting.decode(getStringAsync(PAYMENT_LIST));
    paymentList.removeWhere((element) => element.type == PAYPAL);
    if (widget.bookings.service!.isAdvancePayment) {
      paymentList.removeWhere((element) => element.type == PAYMENT_METHOD_COD);
    }

    currentPaymentMethod = paymentList.first;
    if (appStore.isEnableUserWallet) {
      paymentList.add(PaymentSetting(title: language.wallet, type: PAYMENT_METHOD_FROM_WALLET, status: 1));
    }

    if (widget.bookings.bookingDetail!.isPackageBooking) {
      totalAmount = widget.bookings.bookingDetail!.totalAmount.validate();
    } else {
      if (widget.bookings.bookingDetail!.isHourlyService.validate()) {
        totalAmount = getHourlyPrice(
          price: widget.bookings.bookingDetail!.totalAmount!.toInt(),
          secTime: widget.bookings.bookingDetail!.durationDiff.toInt(),
          date: widget.bookings.bookingDetail!.date.validate(),
        );
      } else {
        totalAmount = calculateTotalAmount(
          serviceDiscountPercent: widget.bookings.service!.discount.validate(),
          qty: widget.bookings.bookingDetail!.quantity!.toInt(),
          detail: widget.bookings.service,
          servicePrice: widget.bookings.bookingDetail!.amount.validate(),
          taxes: widget.bookings.bookingDetail!.taxes.validate(),
          couponData: widget.bookings.couponData,
          extraCharges: widget.bookings.bookingDetail!.extraCharges,
        );
        if (widget.bookings.service!.isAdvancePayment) {
          if (widget.bookings.bookingDetail!.paymentStatus == null) {
            totalAmount = (totalAmount * widget.bookings.service!.advancePaymentPercentage.validate() / 100);
          } else if (widget.bookings.bookingDetail!.paymentStatus == SERVICE_PAYMENT_STATUS_PENDING) {
            totalAmount = (calculateTotalAmount(
              servicePrice: widget.bookings.bookingDetail!.price!,
              qty: widget.bookings.bookingDetail!.quantity!,
              serviceDiscountPercent: widget.bookings.bookingDetail!.discount,
              taxes: widget.bookings.bookingDetail!.taxes,
              extraCharges: widget.bookings.bookingDetail!.extraCharges,
            ));
            var paidAmount = (totalAmount * widget.bookings.service!.advancePaymentPercentage.validate() / 100);

            totalAmount = (totalAmount - paidAmount).toStringAsFixed(DECIMAL_POINT).toDouble();
          } else if (widget.bookings.bookingDetail!.paymentStatus == SERVICE_PAYMENT_STATUS_ADVANCE_PAID) {
            totalAmount = (calculateTotalAmount(
                      servicePrice: widget.bookings.bookingDetail!.price!,
                      qty: widget.bookings.bookingDetail!.quantity!,
                      serviceDiscountPercent: widget.bookings.bookingDetail!.discount,
                      taxes: widget.bookings.bookingDetail!.taxes,
                      extraCharges: widget.bookings.bookingDetail!.extraCharges,
                    ) -
                    widget.bookings.bookingDetail!.paidAmount.validate())
                .validate()
                .toStringAsFixed(DECIMAL_POINT)
                .formatNumberWithComma()
                .toDouble();
          }
        }
      }
    }

    setState(() {});
  }

  @override
  void setState(fn) {
    if (mounted) super.setState(fn);
  }

  void _handleClick() async {
    if (currentPaymentMethod!.type == PAYMENT_METHOD_COD) {
      savePay(data: widget.bookings, paymentMethod: PAYMENT_METHOD_COD, totalAmount: totalAmount);
    } else if (currentPaymentMethod!.type == PAYMENT_METHOD_STRIPE) {
      if (currentPaymentMethod!.isTest == 1) {
        appStore.setLoading(true);

        await stripeServices.init(
          stripePaymentPublishKey: currentPaymentMethod!.testValue!.stripePublickey.validate(),
          data: widget.bookings,
          totalAmount: totalAmount,
          stripeURL: currentPaymentMethod!.testValue!.stripeUrl.validate(),
          stripePaymentKey: currentPaymentMethod!.testValue!.stripeKey.validate(),
          isTest: true,
        );
        await 1.seconds.delay;
        stripeServices.stripePay();
      } else {
        appStore.setLoading(true);

        await stripeServices.init(
          stripePaymentPublishKey: currentPaymentMethod!.liveValue!.stripePublickey.validate(),
          data: widget.bookings,
          totalAmount: totalAmount,
          stripeURL: currentPaymentMethod!.liveValue!.stripeUrl.validate(),
          stripePaymentKey: currentPaymentMethod!.liveValue!.stripeKey.validate(),
          isTest: false,
        );
        await 1.seconds.delay;
        stripeServices.stripePay();
      }
    } else if (currentPaymentMethod!.type == PAYMENT_METHOD_RAZOR) {
      if (currentPaymentMethod!.isTest == 1) {
        appStore.setLoading(true);
        RazorPayServices.init(razorKey: currentPaymentMethod!.testValue!.razorKey!, data: widget.bookings, totalamount: totalAmount);
        await 1.seconds.delay;
        appStore.setLoading(false);
        RazorPayServices.razorPayCheckout(totalAmount);
      } else {
        appStore.setLoading(true);
        RazorPayServices.init(razorKey: currentPaymentMethod!.liveValue!.razorKey!, data: widget.bookings, totalamount: totalAmount);
        await 1.seconds.delay;
        appStore.setLoading(false);
        RazorPayServices.razorPayCheckout(totalAmount);
      }
    } else if (currentPaymentMethod!.type == PAYMENT_METHOD_FLUTTER_WAVE) {
      if (currentPaymentMethod!.isTest == 1) {
        appStore.setLoading(true);

        FlutterWaveServices().payWithFlutterWave(
          bookDetailData: widget.bookings,
          totalAmount: totalAmount,
          flutterWavePublicKey: currentPaymentMethod!.testValue!.flutterwavePublic.validate(),
          flutterWaveSecretKey: currentPaymentMethod!.testValue!.flutterwaveSecret.validate(),
          isTestMode: true,
        );
      } else {
        appStore.setLoading(true);

        FlutterWaveServices().payWithFlutterWave(
          bookDetailData: widget.bookings,
          totalAmount: totalAmount,
          flutterWavePublicKey: currentPaymentMethod!.liveValue!.flutterwavePublic.validate(),
          flutterWaveSecretKey: currentPaymentMethod!.liveValue!.flutterwaveSecret.validate(),
          isTestMode: false,
        );
      }
    } else if (currentPaymentMethod!.type == PAYMENT_METHOD_CINETPAY) {
      List<String> supportedCurrencies = ["XOF", "XAF", "CDF", "GNF", "USD"];

      if (!supportedCurrencies.contains(appStore.currencyCode)) {
        toast(language.cinetPayNotSupportedMessage);
        return;
      }

      appStore.setLoading(true);

      if (currentPaymentMethod!.isTest == 1) {
        CinetPayServices cinetPayServices = CinetPayServices(
          cinetPayApiKey: currentPaymentMethod!.testValue!.cinetPublicKey.validate(),
          totalAmount: totalAmount,
          bookDetailData: widget.bookings,
          siteId: currentPaymentMethod!.testValue!.cinetId.validate(),
          secretKey: currentPaymentMethod!.testValue!.cinetKey.validate(),
        );
        await 1.seconds.delay;

        cinetPayServices.payWithCinetPay(context: context);
      } else {
        CinetPayServices cinetPayServices = CinetPayServices(
          cinetPayApiKey: currentPaymentMethod!.liveValue!.cinetPublicKey.validate(),
          totalAmount: totalAmount,
          bookDetailData: widget.bookings,
          siteId: currentPaymentMethod!.liveValue!.cinetId.validate(),
          secretKey: currentPaymentMethod!.liveValue!.cinetKey.validate(),
        );
        await 1.seconds.delay;

        cinetPayServices.payWithCinetPay(context: context);
      }
    } else if (currentPaymentMethod!.type == PAYMENT_METHOD_SADAD_PAYMENT) {
      if (currentPaymentMethod!.isTest == 1) {
        appStore.setLoading(true);
        SadadServices sadadServices = SadadServices(
          sadadId: currentPaymentMethod!.testValue!.sadadId.validate(),
          sadadKey: currentPaymentMethod!.testValue!.sadadKey.validate(),
          sadadDomain: currentPaymentMethod!.testValue!.sadadDomain.validate(),
          totalAmount: totalAmount,
          bookDetailData: widget.bookings,
        );

        await 1.seconds.delay;
        await sadadServices.payWithSadad(context);
        appStore.setLoading(false);
      } else {
        appStore.setLoading(true);
        SadadServices sadadServices = SadadServices(
          sadadId: currentPaymentMethod!.liveValue!.sadadId.validate(),
          sadadKey: currentPaymentMethod!.liveValue!.sadadKey.validate(),
          sadadDomain: currentPaymentMethod!.liveValue!.sadadDomain.validate(),
          totalAmount: totalAmount,
          bookDetailData: widget.bookings,
        );

        await 1.seconds.delay;
        await sadadServices.payWithSadad(context);
        appStore.setLoading(false);
      }
    } else if (currentPaymentMethod!.type == PAYMENT_METHOD_FROM_WALLET) {
      savePay(
        data: widget.bookings,
        paymentMethod: PAYMENT_METHOD_FROM_WALLET,
        paymentStatus: widget.isForAdvancePayment ? SERVICE_PAYMENT_STATUS_ADVANCE_PAID : SERVICE_PAYMENT_STATUS_PAID,
        txnId: null,
        totalAmount: totalAmount,
      );
    }
    /*else if (currentPaymentMethod!.type == PAYPAL) {
      if (currentPaymentMethod!.isTest == 1) {
        appStore.setLoading(true);

        PaypalPayment paypalPayment = PaypalPayment(totalAmount: totalAmount, bookDetailData: widget.bookings, payPalUrl: currentPaymentMethod!.testValue!.paypalUrl.validate());

        await 1.seconds.delay;
        paypalPayment.brainTreeDrop();
      } else {
        appStore.setLoading(true);

        PaypalPayment paypalPayment = PaypalPayment(totalAmount: totalAmount, bookDetailData: widget.bookings, payPalUrl: currentPaymentMethod!.liveValue!.cinetKey.validate());

        await 1.seconds.delay;
        paypalPayment.brainTreeDrop();
      }
    }*/
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: appBarWidget(
        language.payment,
        color: context.primaryColor,
        textColor: Colors.white,
        backWidget: BackWidget(),
        textSize: APP_BAR_TEXT_SIZE,
      ),
      body: Stack(
        children: [
          AnimatedScrollView(
            listAnimationType: ListAnimationType.FadeIn,
            fadeInConfiguration: FadeInConfiguration(duration: 2.seconds),
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      PriceCommonWidget(
                        bookingDetail: widget.bookings.bookingDetail!,
                        serviceDetail: widget.bookings.service!,
                        taxes: widget.bookings.bookingDetail!.taxes.validate(),
                        couponData: widget.bookings.couponData,
                        bookingPackage: widget.bookings.bookingDetail!.bookingPackage != null ? widget.bookings.bookingDetail!.bookingPackage : null,
                      ),
                      32.height,
                      Text(language.lblChoosePaymentMethod, style: boldTextStyle(size: LABEL_TEXT_SIZE)),
                    ],
                  ).paddingAll(16),
                  if (paymentList.isNotEmpty)
                    AnimatedListView(
                      itemCount: paymentList.length,
                      shrinkWrap: true,
                      physics: NeverScrollableScrollPhysics(),
                      listAnimationType: ListAnimationType.FadeIn,
                      fadeInConfiguration: FadeInConfiguration(duration: 2.seconds),
                      itemBuilder: (context, index) {
                        PaymentSetting value = paymentList[index];

                        if (value.status.validate() == 0) return Offstage();

                        return RadioListTile<PaymentSetting>(
                          dense: true,
                          activeColor: primaryColor,
                          value: value,
                          controlAffinity: ListTileControlAffinity.trailing,
                          groupValue: currentPaymentMethod,
                          onChanged: (PaymentSetting? ind) {
                            currentPaymentMethod = ind;

                            setState(() {});
                          },
                          title: Text(value.title.validate(), style: primaryTextStyle()),
                        );
                      },
                    )
                  else
                    NoDataWidget(
                      title: language.lblNoPayments,
                      imageWidget: EmptyStateWidget(),
                    ),
                  Observer(builder: (context) {
                    return WalletBalanceComponent().paddingSymmetric(vertical: 8, horizontal: 16).visible(appStore.isEnableUserWallet);
                  }),
                  if (paymentList.isNotEmpty)
                    AppButton(
                      onTap: () async {
                        if (currentPaymentMethod!.type == PAYMENT_METHOD_COD || currentPaymentMethod!.type == PAYMENT_METHOD_FROM_WALLET) {
                          if (currentPaymentMethod!.type == PAYMENT_METHOD_FROM_WALLET) {
                            appStore.setLoading(true);
                            num walletBalance = await getUserWalletBalance();

                            appStore.setLoading(false);
                            if (walletBalance >= totalAmount) {
                              showConfirmDialogCustom(
                                context,
                                dialogType: DialogType.CONFIRMATION,
                                title: "${language.lblPayWith} ${currentPaymentMethod!.title.validate()}?",
                                primaryColor: primaryColor,
                                positiveText: language.lblYes,
                                negativeText: language.lblCancel,
                                onAccept: (p0) {
                                  _handleClick();
                                },
                              );
                            } else {
                              toast(language.insufficientBalanceMessage);
                            }
                          } else {
                            showConfirmDialogCustom(
                              context,
                              dialogType: DialogType.CONFIRMATION,
                              title: "${language.lblPayWith} ${currentPaymentMethod!.title.validate()}?",
                              primaryColor: primaryColor,
                              positiveText: language.lblYes,
                              negativeText: language.lblCancel,
                              onAccept: (p0) {
                                _handleClick();
                              },
                            );
                          }
                        } else {
                          _handleClick();
                        }
                      },
                      text: "${language.payWith} ${currentPaymentMethod!.title.validate()}",
                      color: context.primaryColor,
                      width: context.width(),
                    ).paddingAll(16),
                ],
              ),
            ],
          ),
          Observer(builder: (context) => LoaderWidget().visible(appStore.isLoading)).center()
        ],
      ),
    );
  }
}
