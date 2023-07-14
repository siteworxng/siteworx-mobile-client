import 'package:client/component/back_widget.dart';
import 'package:client/component/cached_image_widget.dart';
import 'package:client/component/price_widget.dart';
import 'package:client/main.dart';
import 'package:client/model/service_data_model.dart';
import 'package:client/screens/auth/sign_in_screen.dart';
import 'package:client/screens/gallery/gallery_component.dart';
import 'package:client/screens/gallery/gallery_screen.dart';
import 'package:client/utils/colors.dart';
import 'package:client/utils/common.dart';
import 'package:client/utils/constant.dart';
import 'package:client/utils/images.dart';
import 'package:client/utils/string_extensions.dart';
import 'package:flutter/material.dart';
import 'package:nb_utils/nb_utils.dart';

class ServiceDetailHeaderComponent extends StatefulWidget {
  final ServiceData serviceDetail;

  const ServiceDetailHeaderComponent({required this.serviceDetail, Key? key}) : super(key: key);

  @override
  State<ServiceDetailHeaderComponent> createState() => _ServiceDetailHeaderComponentState();
}

class _ServiceDetailHeaderComponentState extends State<ServiceDetailHeaderComponent> {
  Future<void> onTapFavourite() async {
    if (widget.serviceDetail.isFavourite == 1) {
      widget.serviceDetail.isFavourite = 0;
      setState(() {});

      await removeToWishList(serviceId: widget.serviceDetail.id.validate()).then((value) {
        if (!value) {
          widget.serviceDetail.isFavourite = 1;
          setState(() {});
        }
      });
    } else {
      widget.serviceDetail.isFavourite = 1;
      setState(() {});

      await addToWishList(serviceId: widget.serviceDetail.id.validate()).then((value) {
        if (!value) {
          widget.serviceDetail.isFavourite = 0;
          setState(() {});
        }
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 475,
      width: context.width(),
      child: Stack(
        clipBehavior: Clip.none,
        children: [
          if (widget.serviceDetail.attachments.validate().isNotEmpty)
            SizedBox(
              height: 400,
              width: context.width(),
              child: CachedImageWidget(
                url: widget.serviceDetail.attachments!.first,
                fit: BoxFit.cover,
                height: 400,
              ),
            ),
          Positioned(
            top: context.statusBarHeight + 8,
            left: 16,
            child: Container(
              child: BackWidget(iconColor: context.iconColor),
              decoration: BoxDecoration(shape: BoxShape.circle, color: context.cardColor.withOpacity(0.7)),
            ),
          ),
          Positioned(
            top: context.statusBarHeight + 8,
            child: Container(
              padding: EdgeInsets.all(10),
              margin: EdgeInsets.only(right: 8),
              decoration: boxDecorationWithShadow(boxShape: BoxShape.circle, backgroundColor: context.cardColor),
              child: widget.serviceDetail.isFavourite == 1 ? ic_fill_heart.iconImage(color: favouriteColor, size: 24) : ic_heart.iconImage(color: unFavouriteColor, size: 24),
            ).onTap(() async {
              if (appStore.isLoggedIn) {
                onTapFavourite();
              } else {
                push(SignInScreen(returnExpected: true)).then((value) {
                  setStatusBarColor(transparentColor, delayInMilliSeconds: 1000);
                  if (value) {
                    onTapFavourite();
                  }
                });
              }
            }, highlightColor: Colors.transparent, splashColor: Colors.transparent, hoverColor: Colors.transparent),
            right: 8,
          ),
          Positioned(
            bottom: 0,
            left: 16,
            right: 16,
            child: Column(
              children: [
                Row(
                  children: [
                    Wrap(
                      spacing: 16,
                      runSpacing: 16,
                      children: List.generate(
                        widget.serviceDetail.attachments!.take(2).length,
                        (i) => Container(
                          decoration: BoxDecoration(border: Border.all(color: white, width: 2), borderRadius: radius()),
                          child: GalleryComponent(images: widget.serviceDetail.attachments!, index: i, padding: 32, height: 60, width: 60),
                        ),
                      ),
                    ),
                    16.width,
                    if (widget.serviceDetail.attachments!.length > 2)
                      Blur(
                        borderRadius: radius(),
                        padding: EdgeInsets.zero,
                        child: Container(
                          height: 60,
                          width: 60,
                          decoration: BoxDecoration(
                            border: Border.all(color: white, width: 2),
                            borderRadius: radius(),
                          ),
                          alignment: Alignment.center,
                          child: Text('+' '${widget.serviceDetail.attachments!.length - 2}', style: boldTextStyle(color: white)),
                        ),
                      ).onTap(() {
                        GalleryScreen(
                          serviceName: widget.serviceDetail.name.validate(),
                          attachments: widget.serviceDetail.attachments.validate(),
                        ).launch(context);
                      }),
                  ],
                ),
                16.height,
                Container(
                  width: context.width(),
                  padding: EdgeInsets.all(16),
                  decoration: boxDecorationDefault(
                    color: context.scaffoldBackgroundColor,
                    border: Border.all(color: context.dividerColor),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      if (widget.serviceDetail.subCategoryName.validate().isNotEmpty)
                        Marquee(
                          child: Row(
                            children: [
                              Text('${widget.serviceDetail.categoryName}', style: boldTextStyle(color: textSecondaryColorGlobal, size: 12)),
                              Text('  >  ', style: boldTextStyle(color: textSecondaryColorGlobal)),
                              Text('${widget.serviceDetail.subCategoryName}', style: boldTextStyle(color: primaryColor, size: 12)),
                            ],
                          ),
                        )
                      else
                        Text('${widget.serviceDetail.categoryName}', style: boldTextStyle(size: 14, color: primaryColor)),
                      8.height,
                      Marquee(
                        child: Text('${widget.serviceDetail.name.validate()}', style: boldTextStyle(size: 18)),
                        directionMarguee: DirectionMarguee.oneDirection,
                      ),
                      8.height,
                      Row(
                        children: [
                          PriceWidget(
                            price: widget.serviceDetail.price.validate(),
                            isHourlyService: widget.serviceDetail.isHourlyService,
                            hourlyTextColor: textSecondaryColorGlobal,
                            isFreeService: widget.serviceDetail.type.validate() == SERVICE_TYPE_FREE,
                          ),
                          4.width,
                          if (widget.serviceDetail.discount.validate() != 0)
                            Text(
                              '(${widget.serviceDetail.discount.validate()}% ${language.lblOff})',
                              style: boldTextStyle(color: Colors.green),
                            ),
                        ],
                      ),
                      4.height,
                      TextIcon(
                        edgeInsets: EdgeInsets.symmetric(horizontal: 0, vertical: 8),
                        text: '${language.duration}',
                        textStyle: secondaryTextStyle(size: 14),
                        expandedText: true,
                        suffix: Text(
                          "${widget.serviceDetail.duration.validate()} ${language.lblHour}",
                          style: boldTextStyle(color: primaryColor),
                        ),
                      ),
                      TextIcon(
                        text: '${language.lblRating}',
                        textStyle: secondaryTextStyle(size: 14),
                        edgeInsets: EdgeInsets.symmetric(vertical: 4),
                        expandedText: true,
                        suffix: Row(
                          children: [
                            Image.asset(ic_star_fill, height: 18, color: getRatingBarColor(widget.serviceDetail.totalRating.validate().toInt())),
                            4.width,
                            Text("${widget.serviceDetail.totalRating.validate().toStringAsFixed(1)}", style: boldTextStyle()),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
