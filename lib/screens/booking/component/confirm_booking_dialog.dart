import 'dart:convert';

import 'package:client/component/loader_widget.dart';
import 'package:client/main.dart';
import 'package:client/model/package_data_model.dart';
import 'package:client/model/service_detail_response.dart';
import 'package:client/network/rest_apis.dart';
import 'package:client/utils/colors.dart';
import 'package:client/utils/images.dart';
import 'package:client/utils/model_keys.dart';
import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:nb_utils/nb_utils.dart';

import '../../../model/booking_detail_model.dart';
import '../../../utils/constant.dart';
import '../../payment/payment_screen.dart';
import 'booking_confirmation_dialog.dart';

class ConfirmBookingDialog extends StatefulWidget {
  final ServiceDetailResponse data;
  final num? bookingPrice;
  final BookingPackage? selectedPackage;
  final CouponData? appliedCouponData;

  ConfirmBookingDialog({required this.data, required this.bookingPrice, this.selectedPackage, this.appliedCouponData});

  @override
  State<ConfirmBookingDialog> createState() => _ConfirmBookingDialogState();
}

class _ConfirmBookingDialogState extends State<ConfirmBookingDialog> {
  Map? selectedPackage;
  List<int> selectedService = [];

  bool isSelected = false;
  String serviceId = "";

  Future<void> bookServices() async {
    if (widget.selectedPackage != null) {
      if (widget.selectedPackage!.serviceList != null) {
        widget.selectedPackage!.serviceList!.forEach((element) {
          selectedService.add(element.id.validate());
        });

        for (var i in selectedService) {
          if (i == selectedService.last) {
            serviceId = serviceId + i.toString();
          } else {
            serviceId = serviceId + i.toString() + ",";
          }
        }
      }

      selectedPackage = {
        PackageKey.packageId: widget.selectedPackage!.id.validate(),
        PackageKey.categoryId: widget.selectedPackage!.categoryId != -1 ? widget.selectedPackage!.categoryId.validate() : null,
        PackageKey.name: widget.selectedPackage!.name.validate(),
        PackageKey.price: widget.selectedPackage!.price.validate(),
        PackageKey.serviceId: serviceId,
        PackageKey.startDate: widget.selectedPackage!.startDate.validate(),
        PackageKey.endDate: widget.selectedPackage!.endDate.validate(),
        PackageKey.isFeatured: widget.selectedPackage!.isFeatured == 1 ? '1' : '0',
        PackageKey.packageType: widget.selectedPackage!.packageType.validate(),
      };
    }

    log("selectedPackage: ${[selectedPackage]}");

    Map request = {
      CommonKeys.id: "",
      CommonKeys.serviceId: widget.data.serviceDetail!.id.toString(),
      CommonKeys.providerId: widget.data.provider!.id.validate().toString(),
      CommonKeys.customerId: appStore.userId.toString().toString(),
      BookingServiceKeys.description: widget.data.serviceDetail!.bookingDescription.validate().toString(),
      CommonKeys.address: widget.data.serviceDetail!.address.validate().toString(),
      CommonKeys.date: widget.data.serviceDetail!.dateTimeVal.validate().toString(),
      BookingServiceKeys.couponId: widget.data.serviceDetail!.couponCode.validate().toString(),
      BookService.amount: widget.bookingPrice,
      BookService.quantity: '${widget.data.serviceDetail!.qty.validate()}',
      BookingServiceKeys.totalAmount: widget.selectedPackage != null ? widget.bookingPrice.toString() : widget.data.serviceDetail!.totalAmount.toString(),
      CouponKeys.discount: widget.data.serviceDetail!.discount != null ? widget.data.serviceDetail!.discount.toString() : "",
      BookService.bookingAddressId: widget.data.serviceDetail!.bookingAddressId != -1 ? widget.data.serviceDetail!.bookingAddressId : null,
      BookingServiceKeys.type: BOOKING_TYPE_SERVICE,
      BookingServiceKeys.bookingPackage: widget.selectedPackage != null ? selectedPackage : null
    };

    if (widget.data.serviceDetail!.isSlotAvailable) {
      request.putIfAbsent('booking_date', () => widget.data.serviceDetail!.bookingDate.validate().toString());
      request.putIfAbsent('booking_slot', () => widget.data.serviceDetail!.bookingSlot.validate().toString());
      request.putIfAbsent('booking_day', () => widget.data.serviceDetail!.bookingDay.validate().toString());
    }

    if (widget.data.taxes.validate().isNotEmpty) {
      request.putIfAbsent('tax', () => widget.data.taxes);
    }
    if (widget.data.serviceDetail != null && widget.data.serviceDetail!.isAdvancePayment) {
      request.putIfAbsent(CommonKeys.status, () => BookingStatusKeys.waitingAdvancedPayment);
    }

    log("Booking Request:- ${jsonEncode(request)}");

    appStore.setLoading(true);

    bookTheServices(request).then((value) async {
      appStore.setLoading(false);
      if (widget.data.serviceDetail != null && widget.data.serviceDetail!.isAdvancePayment) {
        BookingDetailResponse bookingDetailResponse = await getBookingDetail({
          CommonKeys.bookingId: value[CommonKeys.bookingId],
          CommonKeys.customerId: appStore.userId,
        });
        finish(context);
        finish(context);
        PaymentScreen(bookings: bookingDetailResponse, isForAdvancePayment: true).launch(context);
      } else {
        finish(context);
        finish(context);
        showInDialog(
          context,
          builder: (BuildContext context) => BookingConfirmationDialog(
            data: widget.data,
            bookingId: value[CommonKeys.bookingId],
            bookingPrice: widget.bookingPrice,
            selectedPackage: widget.selectedPackage,
            appliedCouponData: widget.appliedCouponData,
          ),
          backgroundColor: transparentColor,
          contentPadding: EdgeInsets.zero,
        );
      }
    }).catchError((e) {
      appStore.setLoading(false);
      toast(e.toString(), print: true);
    });
  }

  num get getAdvancePaymentAmount {
    num advancePaymentAmount = (widget.data.serviceDetail!.totalAmount.validate() * widget.data.serviceDetail!.advancePaymentPercentage.validate() / 100);
    return advancePaymentAmount;
  }

  @override
  Widget build(BuildContext context) {
    return Observer(
      builder: (context) {
        return Container(
          width: context.width(),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisSize: MainAxisSize.min,
            children: [
              Image.asset(ic_confirm_check, height: 100, width: 100, color: primaryColor),
              24.height,
              Text(language.lblConfirmBooking, style: boldTextStyle(size: 20)),
              16.height,
              Text(language.lblConfirmMsg, style: primaryTextStyle(), textAlign: TextAlign.center),
              16.height,
              CheckboxListTile(
                value: isSelected,
                onChanged: (val) async {
                  await setValue(IS_SELECTED, isSelected);
                  isSelected = !isSelected;
                  setState(() {});
                },
                title: Text(language.confirmationTermsConditions, style: secondaryTextStyle()),
                controlAffinity: ListTileControlAffinity.leading,
                contentPadding: EdgeInsets.zero,
              ),
              32.height,
              Row(
                children: [
                  AppButton(
                    onTap: () {
                      finish(context);
                    },
                    text: language.lblCancel,
                    textColor: textPrimaryColorGlobal,
                  ).expand(),
                  16.width,
                  AppButton(
                    text: language.confirm,
                    textColor: Colors.white,
                    color: context.primaryColor,
                    onTap: () {
                      if (isSelected) {
                        bookServices();
                      } else {
                        toast(language.termsConditionsAccept);
                      }
                    },
                  ).expand(),
                ],
              )
            ],
          ).visible(
            !appStore.isLoading,
            defaultWidget: LoaderWidget().withSize(width: 250, height: 280),
          ),
        );
      },
    );
  }
}
