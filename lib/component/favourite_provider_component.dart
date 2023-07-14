import 'package:client/screens/booking/provider_info_screen.dart';
import 'package:client/utils/string_extensions.dart';
import 'package:flutter/material.dart';
import 'package:nb_utils/nb_utils.dart';

import '../main.dart';
import '../model/user_data_model.dart';
import '../network/rest_apis.dart';
import '../utils/colors.dart';
import '../utils/images.dart';
import 'cached_image_widget.dart';

class FavouriteProviderComponent extends StatefulWidget {
  final double width;
  final UserData? data;
  final Function? onUpdate;
  final bool isFavouriteProvider;

  FavouriteProviderComponent({required this.width, this.data, this.onUpdate, this.isFavouriteProvider = true});

  @override
  State<FavouriteProviderComponent> createState() => _FavouriteProviderComponentState();
}

class _FavouriteProviderComponentState extends State<FavouriteProviderComponent> {
  //Favourite provider
  Future<bool> addProviderToWishList({required int providerId}) async {
    Map req = {"id": "", "provider_id": providerId, "user_id": appStore.userId};
    return await addProviderWishList(req).then((res) {
      toast(res.message!);
      //toast('Added favourite Provider');
      return true;
    }).catchError((error) {
      toast(error.toString());
      return false;
    });
  }

  Future<bool> removeProviderToWishList({required int providerId}) async {
    Map req = {"user_id": appStore.userId, 'provider_id': providerId};

    return await removeProviderWishList(req).then((res) {
      toast(res.message!);
      //toast('Remove favourite Provider');
      return true;
    }).catchError((error) {
      toast(error.toString());
      return false;
    });
  }

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
    return Stack(
      children: [
        Container(
          width: widget.width,
          decoration: boxDecorationWithRoundedCorners(borderRadius: radius(), backgroundColor: appStore.isDarkMode ? context.scaffoldBackgroundColor : white),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                decoration: BoxDecoration(
                  borderRadius: radiusOnly(topLeft: defaultRadius, topRight: defaultRadius),
                  color: primaryColor.withOpacity(0.2),
                ),
                child: CachedImageWidget(
                  url: widget.data!.profileImage.validate(),
                  width: context.width(),
                  height: 110,
                  fit: BoxFit.cover,
                  circle: false,
                ).cornerRadiusWithClipRRectOnly(topRight: defaultRadius.toInt(), topLeft: defaultRadius.toInt()),
              ),
              16.height,
              Marquee(
                directionMarguee: DirectionMarguee.oneDirection,
                child: Text(widget.data!.displayName.validate(), style: boldTextStyle(size: 16), maxLines: 1),
              ).center(),
              16.height,

              /// Hide email and calling function
              /*8.height,
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      if (widget.data!.contactNumber.validate().isNotEmpty)
                        TextIcon(
                          onTap: () {
                            launchCall(widget.data!.contactNumber.validate());
                          },
                          prefix: Container(
                            padding: EdgeInsets.all(8),
                            decoration: boxDecorationWithRoundedCorners(
                              boxShape: BoxShape.circle,
                              backgroundColor: primaryColor.withOpacity(0.1),
                            ),
                            child: Image.asset(ic_calling, color: primaryColor, height: 14, width: 14),
                          ),
                        ),
                      if (widget.data!.email.validate().isNotEmpty)
                        TextIcon(
                          onTap: () {
                            launchMail(widget.data!.email.validate());
                          },
                          prefix: Container(
                            padding: EdgeInsets.all(8),
                            decoration: boxDecorationWithRoundedCorners(
                              boxShape: BoxShape.circle,
                              backgroundColor: primaryColor.withOpacity(0.1),
                            ),
                            child: ic_message.iconImage(size: 14, color: primaryColor),
                          ),
                        ),
                    ],
                  ),*/
            ],
          ),
        ),
        if (widget.isFavouriteProvider)
          Positioned(
            top: 8,
            right: 0,
            child: Container(
              padding: EdgeInsets.all(8),
              margin: EdgeInsets.only(right: 8),
              decoration: boxDecorationWithShadow(boxShape: BoxShape.circle, backgroundColor: context.cardColor),
              child: widget.data!.isFavourite == 1 ? ic_fill_heart.iconImage(color: favouriteColor, size: 18) : ic_heart.iconImage(color: unFavouriteColor, size: 22),
            ).onTap(() async {
              if (widget.data!.isFavourite == 1) {
                widget.data!.isFavourite = 0;
                setState(() {});

                await removeProviderToWishList(providerId: widget.data!.providerId.validate()).then((value) {
                  if (!value) {
                    widget.data!.isFavourite = 1;
                    setState(() {});
                  }
                });

                widget.onUpdate!.call();
              } else {
                widget.data!.isFavourite = 1;
                setState(() {});

                await addProviderToWishList(providerId: widget.data!.providerId.validate()).then((value) {
                  if (!value) {
                    widget.data!.isFavourite = 0;
                    setState(() {});
                  }
                });

                widget.onUpdate!.call();
              }
            }),
          ),
      ],
    ).onTap(() {
      ProviderInfoScreen(
        providerId: widget.data!.providerId.validate(),
        onUpdate: () {
          widget.onUpdate!.call();
        },
      ).launch(context);
    });
  }
}
