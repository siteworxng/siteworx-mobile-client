import 'package:client/component/shimmer_widget.dart';
import 'package:client/main.dart';
import 'package:client/utils/constant.dart';
import 'package:flutter/material.dart';
import 'package:nb_utils/nb_utils.dart';

class DashboardShimmer extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        children: [
          /// Slider UI
          ShimmerWidget(
            child: Stack(
              clipBehavior: Clip.none,
              children: [
                Container(
                  height: 325,
                  width: context.width(),
                  color: context.cardColor,
                ),
                Positioned(
                  bottom: -24,
                  right: 16,
                  left: 16,
                  child: Container(
                    height: 60,
                    width: context.width(),
                    decoration: boxDecorationWithRoundedCorners(backgroundColor: appStore.isDarkMode ? Colors.black12 : Colors.white30),
                  ),
                )
              ],
            ),
          ),
          30.height,

          /// Upcoming Booking UI
          ShimmerWidget(height: 130, width: context.width()).paddingSymmetric(vertical: 16, horizontal: 16),

          /// Category UI
          Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  ShimmerWidget(height: 20, width: context.width() * 0.25),
                  ShimmerWidget(height: 20, width: context.width() * 0.15),
                ],
              ).paddingSymmetric(horizontal: 16, vertical: 16),
              HorizontalList(
                itemCount: 10,
                padding: EdgeInsets.only(left: 16, right: 16),
                runSpacing: 8,
                spacing: 12,
                itemBuilder: (_, i) {
                  return ShimmerWidget(
                    child: SizedBox(
                      width: context.width() / 4 - 24,
                      child: Column(
                        children: [
                          Container(
                            width: CATEGORY_ICON_SIZE,
                            height: CATEGORY_ICON_SIZE,
                            padding: EdgeInsets.all(8),
                            decoration: BoxDecoration(color: context.cardColor, shape: BoxShape.circle),
                          ),
                          4.height,
                          Container(
                            width: 60,
                            height: 10,
                            decoration: boxDecorationWithRoundedCorners(backgroundColor: context.cardColor),
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ),
            ],
          ),
          16.height,

          /// Featured Service List UI
          Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  ShimmerWidget(height: 20, width: context.width() * 0.25),
                  ShimmerWidget(height: 20, width: context.width() * 0.15),
                ],
              ).paddingSymmetric(horizontal: 16, vertical: 16),
              HorizontalList(
                itemCount: 10,
                spacing: 16,
                padding: EdgeInsets.symmetric(horizontal: 16, vertical: 16),
                itemBuilder: (context, index) {
                  return Container(
                    decoration: boxDecorationWithRoundedCorners(
                      borderRadius: radius(),
                      backgroundColor: context.cardColor,
                      border: appStore.isDarkMode ? Border.all(color: context.dividerColor) : null,
                    ),
                    child: ShimmerWidget(width: 280, height: 200),
                  );
                },
              )
            ],
          ).paddingSymmetric(vertical: 16),

          /// Service List UI
          Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  ShimmerWidget(height: 20, width: context.width() * 0.25),
                  ShimmerWidget(height: 20, width: context.width() * 0.15),
                ],
              ).paddingSymmetric(horizontal: 16),
              16.height,
              Wrap(
                spacing: 16,
                runSpacing: 16,
                children: List.generate(4, (index) {
                  return Container(
                    width: context.width() / 2 - 26,
                    decoration: boxDecorationWithRoundedCorners(
                      borderRadius: radius(),
                      backgroundColor: context.cardColor,
                      border: appStore.isDarkMode ? Border.all(color: context.dividerColor) : null,
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        ShimmerWidget(height: 205, width: context.width() / 2 - 26),
                        16.height,
                        ShimmerWidget(height: 10, width: context.width() * 0.5).paddingSymmetric(horizontal: 16),
                        16.height,
                        Row(
                          children: [
                            ShimmerWidget(
                              child: Container(height: 30, width: 30, decoration: boxDecorationDefault(shape: BoxShape.circle, color: context.cardColor)),
                            ),
                            8.width,
                            ShimmerWidget(height: 10, width: context.width()).expand(),
                          ],
                        ).paddingSymmetric(horizontal: 16),
                        16.height,
                      ],
                    ),
                  );
                }),
              ).paddingSymmetric(horizontal: 16, vertical: 8)
            ],
          ),

          /// Post Job UI
          16.height,
          ShimmerWidget(
            child: Container(
              height: 160,
              width: context.width(),
              decoration: boxDecorationWithRoundedCorners(
                backgroundColor: context.cardColor,
                borderRadius: BorderRadius.only(topLeft: Radius.circular(defaultRadius), topRight: Radius.circular(defaultRadius)),
              ),
            ),
          )
        ],
      ),
    );
  }
}
