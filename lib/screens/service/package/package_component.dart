import 'package:client/component/price_widget.dart';
import 'package:client/main.dart';
import 'package:client/model/package_data_model.dart';
import 'package:client/screens/service/package/package_info_bottom_sheet.dart';
import 'package:client/utils/common.dart';
import 'package:client/utils/constant.dart';
import 'package:flutter/material.dart';
import 'package:nb_utils/nb_utils.dart';

import '../../../component/cached_image_widget.dart';
import '../../../component/view_all_label_component.dart';

class PackageComponent extends StatefulWidget {
  final List<BookingPackage> servicePackage;
  final Function(BookingPackage?) callBack;

  PackageComponent({required this.servicePackage, required this.callBack});

  @override
  _PackageComponentState createState() => _PackageComponentState();
}

class _PackageComponentState extends State<PackageComponent> {
  int selectedIndex = -1;

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
    if (widget.servicePackage.isEmpty) return Offstage();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        ViewAllLabel(
          label: language.frequentlyBoughtTogether,
          list: [],
          onTap: () {
            //
          },
        ).paddingSymmetric(horizontal: 16),
        AnimatedListView(
          listAnimationType: ListAnimationType.FadeIn,
          fadeInConfiguration: FadeInConfiguration(duration: 2.seconds),
          shrinkWrap: true,
          itemCount: widget.servicePackage.length,
          padding: EdgeInsets.zero,
          physics: NeverScrollableScrollPhysics(),
          itemBuilder: (_, i) {
            BookingPackage data = widget.servicePackage[i];

            return Container(
              width: context.width(),
              padding: EdgeInsets.all(16),
              margin: EdgeInsets.all(8),
              decoration: boxDecorationWithRoundedCorners(
                borderRadius: radius(),
                backgroundColor: context.cardColor,
                border: appStore.isDarkMode ? Border.all(color: context.dividerColor) : null,
              ),
              child: Row(
                children: [
                  CachedImageWidget(
                    url: data.imageAttachments.validate().isNotEmpty ? data.imageAttachments!.first.validate() : "",
                    height: 60,
                    fit: BoxFit.cover,
                    radius: defaultRadius,
                  ),
                  16.width,
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(data.name.validate(), style: boldTextStyle(), maxLines: 1, overflow: TextOverflow.ellipsis),
                          2.height,
                          PriceWidget(
                            price: data.price.validate(),
                            hourlyTextColor: Colors.white,
                            size: 12,
                          ),
                        ],
                      ),
                      if (data.endDate.validate().isNotEmpty)
                        Column(
                          children: [
                            8.height,
                            Text(
                              '${language.endOn}: ${formatDate(data.endDate.validate(), format: DATE_FORMAT_2)}',
                              style: boldTextStyle(color: Colors.green, size: 12),
                            ),
                          ],
                        ),
                    ],
                  ).expand(),
                  16.width,
                  AppButton(
                    child: Text(
                      language.buy,
                      style: boldTextStyle(color: selectedIndex != i ? white : textPrimaryColorGlobal),
                    ),
                    color: selectedIndex != i ? context.primaryColor : context.scaffoldBackgroundColor,
                    onTap: () async {
                      bool? res = await showModalBottomSheet(
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
                            builder: (context, scrollController) => PackageInfoComponent(packageData: data, scrollController: scrollController, isFromServiceDetail: true),
                          );
                        },
                      );

                      if (res ?? false) {
                        widget.callBack.call(data);
                      }
                    },
                  ),
                ],
              ),
            );
          },
        )
      ],
    );
  }
}
