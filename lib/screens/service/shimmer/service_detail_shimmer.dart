import 'package:client/component/back_widget.dart';
import 'package:client/component/disabled_rating_bar_widget.dart';
import 'package:client/component/shimmer_widget.dart';
import 'package:client/main.dart';
import 'package:client/utils/common.dart';
import 'package:client/utils/images.dart';
import 'package:flutter/material.dart';
import 'package:nb_utils/nb_utils.dart';

class ServiceDetailShimmer extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          /// Service Detail Header
          SizedBox(
            height: 475,
            width: context.width(),
            child: Stack(
              children: [
                SizedBox(height: 400, width: context.width(), child: ShimmerWidget()),
                Positioned(
                  top: context.statusBarHeight + 8,
                  left: 16,
                  child: Container(
                    child: BackWidget(iconColor: context.iconColor),
                    decoration: BoxDecoration(shape: BoxShape.circle, color: context.cardColor.withOpacity(0.7)),
                  ),
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
                              3,
                              (i) => Container(
                                decoration: BoxDecoration(borderRadius: radius()),
                                child: ShimmerWidget(height: 60, width: 60),
                              ),
                            ),
                          ),
                          16.width,
                          Blur(
                            borderRadius: radius(),
                            padding: EdgeInsets.zero,
                            child: Container(
                              height: 60,
                              width: 60,
                              decoration: BoxDecoration(borderRadius: radius()),
                              alignment: Alignment.center,
                              child: Text('+' '5', style: boldTextStyle(color: white)),
                            ),
                          ),
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
                            ShimmerWidget(height: 10, width: context.width()),
                            4.height,
                            ShimmerWidget(height: 10, width: context.width() * 0.2),
                            4.height,
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                ShimmerWidget(height: 10, width: context.width() * 0.2),
                                4.width,
                                ShimmerWidget(height: 10, width: context.width() * 0.2),
                              ],
                            ),
                            8.height,
                            ShimmerWidget(height: 10, width: context.width()),
                            8.height,
                            ShimmerWidget(height: 10, width: context.width()),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),

          /// Service Detail Description
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              8.height,
              ShimmerWidget(height: 10, width: context.width() * 0.2),
              8.height,
              ShimmerWidget(height: 10, width: context.width()),
              2.height,
              ShimmerWidget(height: 10, width: context.width()),
              2.height,
              ShimmerWidget(height: 10, width: context.width()),
              2.height,
              ShimmerWidget(height: 10, width: context.width()),
            ],
          ).paddingAll(16),

          /// Time Slot Detail
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              ShimmerWidget(height: 10, width: context.width() * 0.25),
              16.height,
              Wrap(
                spacing: 16,
                runSpacing: 8,
                children: List.generate(5, (index) {
                  return Container(
                    padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                    decoration: boxDecorationDefault(color: context.cardColor),
                    child: ShimmerWidget(height: 20, width: context.width() * 0.12),
                  );
                }),
              ),
            ],
          ).paddingAll(16),

          /// Available Service Address
          Container(
            padding: EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                ShimmerWidget(height: 10, width: context.width() * 0.25),
                16.height,
                Wrap(
                  spacing: 16,
                  runSpacing: 16,
                  children: List.generate(
                    5,
                    (index) {
                      return Container(
                        padding: EdgeInsets.symmetric(vertical: 8, horizontal: 16),
                        decoration: boxDecorationDefault(color: context.cardColor),
                        child: ShimmerWidget(height: 20, width: context.width() * 0.12),
                      );
                    },
                  ),
                )
              ],
            ),
          ),

          /// Provider Card
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              ShimmerWidget(height: 10, width: context.width() * 0.25),
              16.height,
              Container(
                padding: EdgeInsets.all(16),
                decoration: boxDecorationDefault(color: context.cardColor),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Container(
                          decoration: BoxDecoration(shape: BoxShape.circle),
                          child: ShimmerWidget(height: 70, width: 70).cornerRadiusWithClipRRect(35),
                        ),
                        16.width,
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            ShimmerWidget(height: 10, width: context.width()),
                            4.height,
                            DisabledRatingBarWidget(rating: 0),
                          ],
                        ).expand(),
                        8.width,
                        Container(
                          decoration: BoxDecoration(shape: BoxShape.circle),
                          child: ShimmerWidget(height: 20, width: 20),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ).paddingAll(16),

          /// Package Service
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              ShimmerWidget(height: 10, width: context.width() * 0.25).paddingSymmetric(horizontal: 16, vertical: 16),
              ListView.builder(
                shrinkWrap: true,
                itemCount: 2,
                padding: EdgeInsets.zero,
                physics: NeverScrollableScrollPhysics(),
                itemBuilder: (_, i) {
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
                        Container(
                          decoration: BoxDecoration(borderRadius: radius(defaultRadius)),
                          child: ShimmerWidget(height: 60, width: 60),
                        ),
                        16.width,
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                ShimmerWidget(height: 10, width: context.width() * 0.12),
                                4.height,
                                ShimmerWidget(height: 10, width: context.width() * 0.25),
                                4.height,
                                ShimmerWidget(height: 10, width: context.width() * 0.12),
                              ],
                            ),
                          ],
                        ).expand(),
                        16.width,
                        Container(
                          decoration: BoxDecoration(borderRadius: radius(defaultRadius)),
                          child: ShimmerWidget(height: 45, width: 70),
                        ),
                      ],
                    ),
                  );
                },
              )
            ],
          ),

          /// Service FAQ
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              ShimmerWidget(height: 10, width: context.width() * 0.25).paddingSymmetric(horizontal: 16, vertical: 16),
              ListView.builder(
                shrinkWrap: true,
                itemCount: 2,
                padding: EdgeInsets.zero,
                physics: NeverScrollableScrollPhysics(),
                itemBuilder: (_, i) {
                  return Container(
                    width: context.width(),
                    padding: EdgeInsets.all(16),
                    margin: EdgeInsets.all(8),
                    decoration: boxDecorationWithRoundedCorners(
                      borderRadius: radius(),
                      backgroundColor: context.cardColor,
                      border: appStore.isDarkMode ? Border.all(color: context.dividerColor) : null,
                    ),
                    child: Column(
                      children: [
                        ShimmerWidget(height: 10, width: context.width()),
                        16.height,
                        ShimmerWidget(height: 10, width: context.width()),
                      ],
                    ),
                  );
                },
              ),
            ],
          ),

          /// Review List
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              ShimmerWidget(height: 10, width: context.width() * 0.25).paddingSymmetric(horizontal: 16, vertical: 16),
              Wrap(
                children: List.generate(
                  2,
                  (index) => Container(
                    margin: EdgeInsets.only(bottom: 8),
                    padding: EdgeInsets.all(16),
                    width: context.width(),
                    decoration: boxDecorationDefault(color: context.cardColor),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Container(
                              decoration: BoxDecoration(border: Border.all(color: white, width: 2), shape: BoxShape.circle),
                              child: ShimmerWidget(height: 50, width: 50).cornerRadiusWithClipRRect(25),
                            ),
                            16.width,
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: [
                                    ShimmerWidget(height: 10, width: context.width() * 0.25).flexible(),
                                    Row(
                                      children: [
                                        Image.asset(ic_star_fill, height: 14, fit: BoxFit.fitWidth, color: getRatingBarColor(5)),
                                        4.width,
                                        Text('5', style: boldTextStyle(color: getRatingBarColor(5), size: 14)),
                                      ],
                                    ),
                                  ],
                                ),
                                4.height,
                                ShimmerWidget(height: 10, width: context.width()),
                                8.height,
                                ShimmerWidget(height: 20, width: context.width()),
                              ],
                            ).flexible(),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              ).paddingTop(8)
            ],
          ),

          /// Related Service
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              8.height,
              ShimmerWidget(height: 10, width: context.width() * 0.25).paddingSymmetric(horizontal: 16),
              HorizontalList(
                itemCount: 4,
                padding: EdgeInsets.all(16),
                spacing: 8,
                runSpacing: 16,
                itemBuilder: (_, index) => Container(
                  width: context.width() / 2 - 26,
                  decoration: boxDecorationWithRoundedCorners(
                    borderRadius: radius(),
                    backgroundColor: context.cardColor,
                    border: appStore.isDarkMode ? Border.all(color: context.dividerColor) : null,
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      ShimmerWidget(height: 205, width: context.width() / 2 - 24),
                      16.height,
                      ShimmerWidget(height: 10, width: 100).paddingSymmetric(horizontal: 16),
                      16.height,
                      Row(
                        children: [
                          ShimmerWidget(
                            child: Container(
                              height: 30,
                              width: 30,
                              decoration: boxDecorationDefault(shape: BoxShape.circle, color: context.cardColor),
                            ),
                          ),
                          8.width,
                          ShimmerWidget(height: 10, width: context.width()).expand(),
                        ],
                      ).paddingSymmetric(horizontal: 16),
                      16.height,
                    ],
                  ),
                ).paddingOnly(right: 8),
              ),
              16.height,
            ],
          )
        ],
      ),
    );
  }
}
