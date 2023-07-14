import 'package:client/main.dart';
import 'package:client/model/service_detail_response.dart';
import 'package:client/utils/colors.dart';
import 'package:client/utils/constant.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:nb_utils/nb_utils.dart';

import '../../../component/price_widget.dart';

class CouponWidget extends StatefulWidget {
  final List<CouponData> couponData;
  final CouponData? appliedCouponData;

  CouponWidget({required this.couponData, this.appliedCouponData});

  @override
  State<CouponWidget> createState() => _CouponWidgetState();
}

class _CouponWidgetState extends State<CouponWidget> {
  int? selectedIndex;

  TextEditingController couponCont = TextEditingController();

  bool isUpdate = false;

  @override
  void initState() {
    isUpdate = widget.appliedCouponData != null;
    if (isUpdate) {
      selectedIndex = widget.couponData.indexWhere((element) => element.code == widget.appliedCouponData!.code);
      couponCont.text = widget.appliedCouponData!.code.validate();

      setState(() {});
    }

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: context.width(),
      decoration: boxDecorationDefault(color: context.cardColor),
      child: Column(
        children: [
          if (widget.couponData.isNotEmpty)
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  decoration: boxDecorationDefault(color: context.scaffoldBackgroundColor),
                  padding: EdgeInsets.all(16),
                  width: context.width(),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      HorizontalList(
                        itemCount: widget.couponData.length,
                        spacing: 16,
                        padding: EdgeInsets.symmetric(horizontal: 0),
                        itemBuilder: (context, index) {
                          CouponData data = widget.couponData[index];

                          return DottedBorderWidget(
                            color: selectedIndex == index ? primaryColor : context.dividerColor,
                            strokeWidth: 1.5,
                            dotsWidth: 8,
                            padding: EdgeInsets.all(0),
                            child: Container(
                              padding: EdgeInsets.all(8),
                              color: selectedIndex == index ? context.primaryColor.withOpacity(0.15) : context.cardColor,
                              child: Text(
                                data.code.validate(),
                                style: primaryTextStyle(color: selectedIndex == index ? context.primaryColor : null),
                              ),
                            ),
                          ).onTap(() {
                            hideKeyboard(context);
                            selectedIndex = index;
                            couponCont.text = data.code.validate();
                            setState(() {});
                          });
                        },
                      ),
                      16.height,
                      widget.couponData[selectedIndex ?? 0].discountType == SERVICE_TYPE_FIXED
                          ? Row(
                              children: [
                                PriceWidget(price: widget.couponData[selectedIndex ?? 0].discount.validate(), decimalPoint: 0, color: appTextSecondaryColor),
                                Text(" ${language.lblOff.toLowerCase()}", style: primaryTextStyle()),
                              ],
                            )
                          : Text("${widget.couponData[selectedIndex ?? 0].discount.validate()}% ${language.lblOff.toLowerCase()}", style: primaryTextStyle()),
                      16.height,
                      RichTextWidget(
                        list: [
                          TextSpan(text: '${language.lblExpiryDate} ', style: secondaryTextStyle()),
                          TextSpan(
                            text: " ${DateFormat(DATE_FORMAT_2).format(DateTime.parse(widget.couponData[selectedIndex ?? 0].expireDate.validate()))}",
                            style: boldTextStyle(size: 12),
                          ),
                        ],
                      ),
                      if (isUpdate)
                        TextIcon(
                          text: language.lblRemoveCoupon,
                          textStyle: boldTextStyle(color: Colors.red),
                          onTap: () {
                            couponCont.clear();
                            selectedIndex = null;
                            setState(() {});
                            finish(context, null);
                          },
                          edgeInsets: EdgeInsets.symmetric(vertical: 16),
                        )
                    ],
                  ),
                ),
                16.height,
              ],
            )
          else
            Text(language.lblNoCouponsAvailable, style: secondaryTextStyle()).center().paddingSymmetric(vertical: 50),
          16.height,
          Row(
            children: [
              AppButton(
                color: widget.couponData.isEmpty ? primaryColor : context.scaffoldBackgroundColor,
                onTap: () {
                  finish(context);
                },
                text: language.lblCancel,
                textColor: widget.couponData.isEmpty ? Colors.white : textPrimaryColorGlobal,
              ).expand(),
              if (widget.couponData.isNotEmpty) 16.width,
              if (widget.couponData.isNotEmpty)
                AppButton(
                  color: primaryColor,
                  onTap: () {
                    if (couponCont.text.isNotEmpty) {
                      if (widget.couponData.any((element) => element.code == couponCont.text)) {
                        finish(context, widget.couponData[selectedIndex ?? 0]);
                      } else {
                        toast(language.lblInvalidCoupon);
                      }
                    } else {
                      if (isUpdate) {
                        finish(context, null);
                      } else {
                        toast(language.lblSelectCode);
                      }
                    }
                  },
                  text: language.lblApply,
                ).expand(),
            ],
          )
        ],
      ).paddingAll(16),
    );
  }
}
