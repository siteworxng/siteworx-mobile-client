import 'package:client/component/cached_image_widget.dart';
import 'package:client/component/price_widget.dart';
import 'package:client/main.dart';
import 'package:client/model/package_data_model.dart';
import 'package:client/model/service_data_model.dart';
import 'package:client/utils/constant.dart';
import 'package:flutter/material.dart';
import 'package:nb_utils/nb_utils.dart';

class PackageInfoComponent extends StatefulWidget {
  final BookingPackage packageData;
  final bool? isFromServiceDetail;
  final ScrollController scrollController;

  PackageInfoComponent({required this.packageData, required this.scrollController, this.isFromServiceDetail = false});

  @override
  _PackageInfoComponentState createState() => _PackageInfoComponentState();
}

class _PackageInfoComponentState extends State<PackageInfoComponent> {
  @override
  void initState() {
    super.initState();
    init();
  }

  void init() async {
    //
  }

  @override
  void setState(fn) {
    if (mounted) super.setState(fn);
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: boxDecorationWithRoundedCorners(borderRadius: radius(20), backgroundColor: context.cardColor),
      padding: EdgeInsets.all(16),
      child: AnimatedScrollView(
        controller: widget.scrollController,
        listAnimationType: ListAnimationType.FadeIn,
        fadeInConfiguration: FadeInConfiguration(duration: 2.seconds),
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              8.height,
              Container(width: 40, height: 2, color: gray.withOpacity(0.3)).center(),
              16.height,
              Text(
                widget.packageData.name.validate(),
                style: boldTextStyle(size: LABEL_TEXT_SIZE),
              ),
              8.height,
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  4.height,
                  widget.packageData.description.validate().isNotEmpty
                      ? ReadMoreText(
                          widget.packageData.description.validate(),
                          style: primaryTextStyle(),
                          textAlign: TextAlign.justify,
                        )
                      : Text(language.lblNotDescription, style: secondaryTextStyle()),
                ],
              ),
              16.width,
              if (widget.isFromServiceDetail.validate())
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    AppButton(
                      text: language.lblBookNow,
                      textColor: Colors.white,
                      color: context.primaryColor,
                      padding: EdgeInsets.symmetric(horizontal: 16),
                      margin: EdgeInsets.symmetric(vertical: 16),
                      onTap: () {
                        finish(context, true);
                      },
                    ),
                  ],
                ),
              Text(language.getTheseServiceWithThisPackage, style: secondaryTextStyle()),
              8.height,
              if (widget.packageData.serviceList != null)
                ListView.builder(
                  shrinkWrap: true,
                  physics: NeverScrollableScrollPhysics(),
                  itemCount: widget.packageData.serviceList!.length,
                  itemBuilder: (_, i) {
                    ServiceData data = widget.packageData.serviceList![i];

                    return Container(
                      width: context.width(),
                      padding: EdgeInsets.symmetric(vertical: 12, horizontal: 8),
                      margin: EdgeInsets.symmetric(vertical: 8),
                      decoration: boxDecorationWithRoundedCorners(
                        borderRadius: radius(),
                        backgroundColor: context.scaffoldBackgroundColor,
                        border: appStore.isDarkMode ? Border.all(color: context.dividerColor) : null,
                      ),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          CachedImageWidget(
                            url: data.attachments!.isNotEmpty ? data.attachments!.first : "",
                            height: 70,
                            width: 70,
                            fit: BoxFit.cover,
                            radius: 8,
                          ),
                          16.width,
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Marquee(child: Text(data.name.validate(), style: boldTextStyle(size: LABEL_TEXT_SIZE))),
                              4.height,
                              if (data.subCategoryName.validate().isNotEmpty)
                                Marquee(
                                  child: Row(
                                    children: [
                                      Text('${data.categoryName}', style: boldTextStyle(size: 12, color: textSecondaryColorGlobal)),
                                      Text('  >  ', style: boldTextStyle(size: 14, color: textSecondaryColorGlobal)),
                                      Text('${data.subCategoryName}', style: boldTextStyle(size: 12, color: context.primaryColor)),
                                    ],
                                  ),
                                )
                              else
                                Text('${data.categoryName}', style: boldTextStyle(size: 14, color: context.primaryColor)),
                              4.height,
                              PriceWidget(
                                price: data.price.validate(),
                                hourlyTextColor: Colors.white,
                                size: 14,
                              ),
                            ],
                          ).expand()
                        ],
                      ),
                    );
                  },
                )
            ],
          ),
        ],
      ),
    );
  }
}
