import 'package:client/component/disabled_rating_bar_widget.dart';
import 'package:client/component/image_border_component.dart';
import 'package:client/model/user_data_model.dart';
import 'package:client/screens/auth/sign_in_screen.dart';
import 'package:client/screens/booking/provider_info_screen.dart';
import 'package:client/utils/colors.dart';
import 'package:client/utils/images.dart';
import 'package:client/utils/string_extensions.dart';
import 'package:flutter/material.dart';
import 'package:nb_utils/nb_utils.dart';

import '../main.dart';
import '../network/rest_apis.dart';

class UserInfoWidget extends StatefulWidget {
  final UserData data;
  final bool? isOnTapEnabled;
  final bool forProvider;
  final VoidCallback? onUpdate;

  UserInfoWidget({required this.data, this.isOnTapEnabled, this.forProvider = true, this.onUpdate});

  @override
  State<UserInfoWidget> createState() => _UserInfoWidgetState();
}

class _UserInfoWidgetState extends State<UserInfoWidget> {
  @override
  void initState() {
    setStatusBarColor(primaryColor);
    super.initState();
  }

  //Favourite provider
  Future<bool> addProviderToWishList({required int providerId}) async {
    Map req = {"id": "", "provider_id": providerId, "user_id": appStore.userId};
    return await addProviderWishList(req).then((res) {
      toast(res.message!);
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
      return true;
    }).catchError((error) {
      toast(error.toString());
      return false;
    });
  }

  Future<void> onTapFavouriteProvider() async {
    if (widget.data.isFavourite == 1) {
      widget.data.isFavourite = 0;
      setState(() {});

      await removeProviderToWishList(providerId: widget.data.id.validate()).then((value) {
        if (!value) {
          widget.data.isFavourite = 1;
          setState(() {});
          widget.onUpdate!.call();
        }
      });
    } else {
      widget.data.isFavourite = 1;
      setState(() {});

      await addProviderToWishList(providerId: widget.data.id.validate()).then((value) {
        if (!value) {
          widget.data.isFavourite = 0;
          setState(() {});
          widget.onUpdate!.call();
        }
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: widget.isOnTapEnabled.validate(value: false)
          ? null
          : () {
              ProviderInfoScreen(providerId: widget.data.id).launch(context);
            },
      child: SizedBox(
        width: context.width(),
        child: Stack(
          children: [
            Container(
              height: 95,
              padding: EdgeInsets.all(16),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.vertical(bottom: radiusCircular()),
                color: context.primaryColor,
              ),
            ),
            Positioned(
              child: Container(
                padding: EdgeInsets.all(16),
                margin: EdgeInsets.only(top: 16, left: 16, right: 16),
                decoration: boxDecorationDefault(
                  color: context.scaffoldBackgroundColor,
                  border: Border.all(color: context.dividerColor, width: 1),
                  borderRadius: radius(),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        ImageBorder(
                          src: widget.data.profileImage.validate(),
                          height: 90,
                        ),
                        16.width,
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              children: [
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Row(
                                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                      children: [
                                        Text(widget.data.displayName.validate(), style: boldTextStyle(size: 18)).expand(),
                                        Image.asset(ic_verified, height: 18, width: 18, color: verifyAcColor).visible(widget.data.isVerifyProvider == 1),
                                        8.width,

                                        //Favourite provider
                                        if (widget.data.isProvider)
                                          Container(
                                            padding: EdgeInsets.all(8),
                                            decoration: boxDecorationWithShadow(boxShape: BoxShape.circle, backgroundColor: context.cardColor),
                                            child: widget.data.isFavourite == 1 ? ic_fill_heart.iconImage(color: favouriteColor, size: 20) : ic_heart.iconImage(color: unFavouriteColor, size: 20),
                                          ).onTap(() async {
                                            if (appStore.isLoggedIn) {
                                              onTapFavouriteProvider();
                                            } else {
                                              bool? res = await push(SignInScreen(returnExpected: true));

                                              if (res ?? false) {
                                                onTapFavouriteProvider();
                                              }
                                            }
                                          }),
                                      ],
                                    ),
                                    if (widget.data.designation.validate().isNotEmpty)
                                      Column(
                                        children: [
                                          4.height,
                                          Marquee(child: Text(widget.data.designation.validate(), style: secondaryTextStyle(size: 12, weight: FontWeight.bold))),
                                          4.height,
                                        ],
                                      ),
                                  ],
                                ).flexible(),
                              ],
                            ),
                            4.height,
                            Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(language.lblMemberSince, style: secondaryTextStyle(size: 12, weight: FontWeight.bold)),
                                Text(" ${DateTime.parse(widget.data.createdAt.validate()).year}", style: secondaryTextStyle(size: 12, weight: FontWeight.bold)),
                              ],
                            ),
                            8.height,
                            DisabledRatingBarWidget(rating: widget.forProvider ? widget.data.providersServiceRating.validate() : widget.data.handymanRating.validate()),
                          ],
                        ).expand(),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
