import 'package:client/component/app_common_dialog.dart';
import 'package:client/component/cached_image_widget.dart';
import 'package:client/component/custom_stepper.dart';
import 'package:client/component/price_widget.dart';
import 'package:client/main.dart';
import 'package:client/model/package_data_model.dart';
import 'package:client/model/service_detail_response.dart';
import 'package:client/screens/booking/component/confirm_booking_dialog.dart';
import 'package:client/screens/booking/component/coupon_widget.dart';
import 'package:client/screens/service/package/package_info_bottom_sheet.dart';
import 'package:client/utils/colors.dart';
import 'package:client/utils/common.dart';
import 'package:client/utils/constant.dart';
import 'package:client/utils/images.dart';
import 'package:client/utils/string_extensions.dart';
import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:nb_utils/nb_utils.dart';

import '../../../component/wallet_balance_component.dart';

class BookingServiceStep3 extends StatefulWidget {
  final ServiceDetailResponse data;
  final BookingPackage? selectedPackage;

  BookingServiceStep3({required this.data, this.selectedPackage});

  @override
  _BookingServiceStep3State createState() => _BookingServiceStep3State();
}

class _BookingServiceStep3State extends State<BookingServiceStep3> {
  int itemCount = 1;
  CouponData? appliedCouponData;
  num price = 0;

  @override
  void initState() {
    super.initState();
    init();
  }

  void init() async {
    if (widget.selectedPackage != null) {
      price = widget.selectedPackage!.price.validate();
    } else {
      price = widget.data.serviceDetail!.price.validate();
    }
    setPrice();
  }

  void setPrice() async {
    num temp = calculateTotalAmount(
      serviceDiscountPercent: widget.data.serviceDetail!.discount.validate(),
      qty: itemCount,
      detail: widget.data.serviceDetail,
      servicePrice: price,
      taxes: widget.data.taxes!,
      couponData: appliedCouponData,
    );

    if (temp.isNegative) {
      toast(language.couponCantApplied);
      appliedCouponData = null;
      widget.data.serviceDetail!.appliedCouponData = null;
      widget.data.serviceDetail!.couponCode = "";

      num temp1 = calculateTotalAmount(
        serviceDiscountPercent: widget.data.serviceDetail!.discount.validate(),
        qty: itemCount,
        detail: widget.data.serviceDetail,
        servicePrice: price,
        taxes: widget.data.taxes!,
      );
      log(temp1);
    }
    setState(() {});
  }

  Widget priceWidget() {
    return Container(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(language.priceDetail, style: boldTextStyle(size: LABEL_TEXT_SIZE)),
          16.height,
          Container(
            padding: EdgeInsets.all(16),
            width: context.width(),
            decoration: boxDecorationDefault(color: context.cardColor),
            child: Column(
              children: [
                if (widget.selectedPackage == null)
                  Row(
                    children: [
                      Text(language.lblPrice, style: secondaryTextStyle(size: 14)).expand(),
                      16.width,
                      PriceWidget(price: price, color: textPrimaryColorGlobal, isBoldText: true),
                    ],
                  ),
                if (!widget.data.serviceDetail!.isHourlyService && widget.selectedPackage == null)
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Divider(height: 26, color: context.dividerColor),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(language.lblSubTotal, style: secondaryTextStyle(size: 14)).flexible(fit: FlexFit.loose),
                          16.width,
                          Marquee(
                            child: Row(
                              children: [
                                PriceWidget(price: price, size: 12, isBoldText: false, color: textSecondaryColorGlobal),
                                Text(' * $itemCount  = ', style: secondaryTextStyle()),
                                PriceWidget(price: price * itemCount, color: textPrimaryColorGlobal),
                              ],
                            ),
                          ).flexible(flex: 2),
                        ],
                      ),
                    ],
                  ),
                if (widget.data.serviceDetail!.taxAmount.validate() != 0 && widget.selectedPackage == null)
                  Column(
                    children: [
                      Divider(height: 26, color: context.dividerColor),
                      Row(
                        children: [
                          Text(language.lblTax, style: secondaryTextStyle(size: 14)).expand(),
                          16.width,
                          PriceWidget(price: widget.data.serviceDetail!.taxAmount!, color: Colors.red, isBoldText: false),
                        ],
                      ),
                    ],
                  ),
                if (widget.data.serviceDetail!.discount.validate() != 0 && widget.selectedPackage == null)
                  Column(
                    children: [
                      Divider(height: 26, color: context.dividerColor),
                      Row(
                        children: [
                          Text(language.lblDiscount, style: secondaryTextStyle(size: 14)),
                          Text(
                            " (${widget.data.serviceDetail!.discount.validate()}% ${language.lblOff.toLowerCase()})",
                            style: boldTextStyle(color: Colors.green),
                          ).expand(),
                          16.width,
                          PriceWidget(
                            price: widget.data.serviceDetail!.discountPrice!,
                            color: Colors.green,
                            isBoldText: true,
                          ),
                        ],
                      ),
                    ],
                  ),
                if (widget.selectedPackage == null) Divider(height: 26, color: context.dividerColor),
                if (widget.selectedPackage == null)
                  Row(
                    children: [
                      if (widget.data.serviceDetail!.appliedCouponData != null) Text(language.lblCoupon, style: secondaryTextStyle(size: 14)) else Text(language.lblCoupon, style: secondaryTextStyle(size: 14)).expand(),
                      if (widget.data.serviceDetail!.appliedCouponData != null)
                        Text(
                          " (${widget.data.serviceDetail!.appliedCouponData!.code})",
                          style: boldTextStyle(color: primaryColor),
                        ).onTap(() {
                          showInDialog<CouponData>(
                            context,
                            backgroundColor: context.cardColor,
                            contentPadding: EdgeInsets.zero,
                            builder: (p0) {
                              return AppCommonDialog(
                                title: language.lblAvailableCoupons,
                                child: CouponWidget(
                                  couponData: widget.data.couponData.validate(),
                                  appliedCouponData: widget.data.serviceDetail!.appliedCouponData ?? null,
                                ),
                              );
                            },
                          ).then((CouponData? value) {
                            if (value != null) {
                              appliedCouponData = value;
                              setPrice();
                            } else {
                              appliedCouponData = null;
                              widget.data.serviceDetail!.appliedCouponData = null;
                              widget.data.serviceDetail!.couponCode = "";
                              setPrice();
                            }
                          });
                        }).expand(),
                      Text(
                        widget.data.serviceDetail!.appliedCouponData != null ? "" : language.applyCoupon,
                        style: boldTextStyle(color: primaryColor),
                      ).onTap(() {
                        showInDialog<CouponData>(
                          context,
                          backgroundColor: context.cardColor,
                          contentPadding: EdgeInsets.zero,
                          builder: (p0) {
                            return AppCommonDialog(
                              title: language.lblAvailableCoupons,
                              child: CouponWidget(
                                couponData: widget.data.couponData.validate(),
                                appliedCouponData: widget.data.serviceDetail!.appliedCouponData ?? null,
                              ),
                            );
                          },
                        ).then((CouponData? value) {
                          if (value != null) {
                            appliedCouponData = value;
                            setPrice();
                          } else {
                            appliedCouponData = null;
                            widget.data.serviceDetail!.appliedCouponData = null;
                            widget.data.serviceDetail!.couponCode = "";
                            setPrice();
                          }
                        });
                      }),
                      if (widget.data.serviceDetail!.appliedCouponData != null)
                        PriceWidget(
                          price: widget.data.serviceDetail!.couponDiscountAmount.validate(),
                          color: Colors.green,
                          isBoldText: true,
                        ),
                    ],
                  ),
                if (widget.selectedPackage == null) Divider(height: 32, color: context.dividerColor),
                Row(
                  children: [
                    Text(language.totalAmount, style: secondaryTextStyle(size: 14)).expand(),
                    if (widget.selectedPackage != null)
                      PriceWidget(
                        price: calculateTotalAmount(servicePrice: price, qty: itemCount, serviceDiscountPercent: null, taxes: null),
                        color: context.primaryColor,
                      )
                    else
                      PriceWidget(
                        price: calculateTotalAmount(
                          serviceDiscountPercent: widget.data.serviceDetail!.discount.validate(),
                          qty: itemCount,
                          detail: widget.data.serviceDetail,
                          servicePrice: price,
                          taxes: widget.data.taxes.validate(),
                          couponData: appliedCouponData,
                        ),
                        color: primaryColor,
                      )
                  ],
                ),
                if (widget.data.serviceDetail!.isAdvancePayment) Divider(height: 26, color: context.dividerColor),
                if (widget.data.serviceDetail!.isAdvancePayment)
                  Row(
                    children: [
                      RichTextWidget(
                        list: [
                          TextSpan(text: language.advancePayAmount, style: secondaryTextStyle(size: 14)),
                          TextSpan(
                            text: " (${widget.data.serviceDetail!.advancePaymentPercentage.validate().toString()}%)  ",
                            style: boldTextStyle(color: Colors.green),
                          ),
                        ],
                      ).expand(),
                      PriceWidget(price: getAdvancePaymentAmount, color: primaryColor),
                    ],
                  ),
              ],
            ),
          )
        ],
      ),
    );
  }

  num get getAdvancePaymentAmount {
    num getTotalValue = calculateTotalAmount(
      serviceDiscountPercent: widget.data.serviceDetail!.discount.validate(),
      qty: itemCount,
      detail: widget.data.serviceDetail,
      servicePrice: price,
      taxes: widget.data.taxes!,
      couponData: appliedCouponData,
    );
    num advancePaymentAmount = (getTotalValue * widget.data.serviceDetail!.advancePaymentPercentage.validate() / 100);
    return advancePaymentAmount;
  }

  Widget buildDateWidget() {
    if (widget.data.serviceDetail!.isSlotAvailable) {
      return Text(widget.data.serviceDetail!.dateTimeVal.validate(), style: boldTextStyle(size: 12));
    }
    return Text(formatDate(widget.data.serviceDetail!.dateTimeVal.validate(), format: DATE_FORMAT_3), style: boldTextStyle(size: 12));
  }

  Widget buildTimeWidget() {
    if (widget.data.serviceDetail!.bookingSlot == null) {
      return Text(formatDate(widget.data.serviceDetail!.dateTimeVal.validate(), format: HOUR_12_FORMAT), style: boldTextStyle(size: 12));
    }
    return Text(TimeOfDay(hour: widget.data.serviceDetail!.bookingSlot.validate().splitBefore(':').split(":").first.toInt(), minute: widget.data.serviceDetail!.bookingSlot.validate().splitBefore(':').split(":").last.toInt()).format(context),
        style: boldTextStyle(size: 12));
  }

  Widget buildBookingSummaryWidget() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(language.bookingDateAndSlot, style: boldTextStyle(size: LABEL_TEXT_SIZE)),
        16.height,
        Container(
          padding: EdgeInsets.all(16),
          decoration: boxDecorationDefault(color: context.cardColor),
          width: context.width(),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Text("${language.lblDate}: ", style: secondaryTextStyle()),
                  buildDateWidget(),
                ],
              ),
              8.height,
              Row(
                children: [
                  Text("${language.lblTime}: ", style: secondaryTextStyle()),
                  buildTimeWidget(),
                ],
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget packageWidget() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(language.package, style: boldTextStyle(size: LABEL_TEXT_SIZE)),
        16.height,
        Container(
          padding: EdgeInsets.all(16),
          decoration: boxDecorationDefault(color: context.cardColor),
          width: context.width(),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Marquee(child: Text(widget.selectedPackage!.name.validate(), style: boldTextStyle())),
                      4.height,
                      Row(
                        children: [
                          Text(language.includedServices, style: secondaryTextStyle()),
                          8.width,
                          ic_info.iconImage(size: 20),
                        ],
                      ),
                    ],
                  ).expand(),
                  16.width,
                  CachedImageWidget(
                    url: widget.selectedPackage!.imageAttachments.validate().isNotEmpty ? widget.selectedPackage!.imageAttachments!.first.validate() : '',
                    height: 60,
                    width: 60,
                    fit: BoxFit.cover,
                  ).cornerRadiusWithClipRRect(defaultRadius),
                ],
              ).onTap(
                () {
                  showModalBottomSheet(
                    backgroundColor: Colors.transparent,
                    context: context,
                    isScrollControlled: true,
                    isDismissible: true,
                    shape: RoundedRectangleBorder(borderRadius: radiusOnly(topLeft: defaultRadius, topRight: defaultRadius)),
                    builder: (_) {
                      return DraggableScrollableSheet(
                        initialChildSize: 0.50,
                        minChildSize: 0.2,
                        maxChildSize: 1,
                        builder: (context, scrollController) => PackageInfoComponent(packageData: widget.selectedPackage!, scrollController: scrollController),
                      );
                    },
                  );
                },
              ),
            ],
          ),
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
      body: SingleChildScrollView(
        padding: EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (widget.selectedPackage == null)
              Container(
                padding: EdgeInsets.all(16),
                decoration: boxDecorationDefault(color: context.cardColor),
                width: context.width(),
                child: Row(
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(widget.data.serviceDetail!.name.validate(), style: boldTextStyle()),
                        16.height,
                        Container(
                          height: 40,
                          padding: EdgeInsets.all(8),
                          decoration: boxDecorationWithRoundedCorners(
                            backgroundColor: context.scaffoldBackgroundColor,
                          ),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Icon(Icons.arrow_drop_down_sharp, size: 24).onTap(
                                () {
                                  if (itemCount != 1) itemCount--;
                                  setPrice();
                                },
                              ),
                              16.width,
                              Text(itemCount.toString(), style: primaryTextStyle()),
                              16.width,
                              Icon(Icons.arrow_drop_up_sharp, size: 24).onTap(
                                () {
                                  itemCount++;
                                  setPrice();
                                },
                              ),
                            ],
                          ),
                        ).visible(widget.data.serviceDetail!.isFixedService)
                      ],
                    ).expand(),
                    CachedImageWidget(
                      url: widget.data.serviceDetail!.attachments.validate().isNotEmpty ? widget.data.serviceDetail!.attachments!.first.validate() : '',
                      height: 80,
                      width: 80,
                      fit: BoxFit.cover,
                    ).cornerRadiusWithClipRRect(defaultRadius)
                  ],
                ),
              ),
            if (widget.selectedPackage != null) packageWidget(),
            16.height,
            buildBookingSummaryWidget(),
            16.height,
            if (!widget.data.serviceDetail!.isFreeService) priceWidget(),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Observer(builder: (context) {
                  return WalletBalanceComponent().visible(appStore.isEnableUserWallet && widget.data.serviceDetail!.isFixedService);
                }),
                16.height,
                Text(language.disclaimer, style: boldTextStyle(size: LABEL_TEXT_SIZE)),
                Text(language.disclaimerContent, style: secondaryTextStyle()),
              ],
            ).paddingSymmetric(vertical: 16),
            36.height,
            Row(
              children: [
                AppButton(
                  onTap: () {
                    customStepperController.previousPage(duration: 200.milliseconds, curve: Curves.easeInOut);
                  },
                  shapeBorder: RoundedRectangleBorder(borderRadius: radius(), side: BorderSide(color: context.primaryColor)),
                  text: language.lblPrevious,
                  textColor: textPrimaryColorGlobal,
                ).expand(flex: 1),
                16.width,
                AppButton(
                  color: context.primaryColor,
                  text: widget.data.serviceDetail!.isAdvancePayment ? language.advancePayment : language.confirm,
                  textColor: Colors.white,
                  onTap: () {
                    showInDialog(
                      context,
                      builder: (p0) {
                        return ConfirmBookingDialog(
                          data: widget.data,
                          bookingPrice: price,
                          selectedPackage: widget.selectedPackage,
                          appliedCouponData: appliedCouponData,
                        );
                      },
                    );
                  },
                ).expand(flex: 2),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
