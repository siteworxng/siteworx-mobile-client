import 'package:client/component/shimmer_widget.dart';
import 'package:client/utils/constant.dart';
import 'package:flutter/material.dart';
import 'package:nb_utils/nb_utils.dart';

class ServiceShimmer extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              ShimmerWidget(height: 20, width: context.width() * 0.25).paddingSymmetric(horizontal: 8),
              Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      ShimmerWidget(height: 20, width: context.width() * 0.25),
                      ShimmerWidget(height: 20, width: context.width() * 0.15),
                    ],
                  ).paddingSymmetric(horizontal: 8),
                  16.height,
                  HorizontalList(
                    itemCount: 10,
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
              ).paddingSymmetric(vertical: 16),
              ShimmerWidget(height: 20, width: context.width() * 0.25).paddingSymmetric(horizontal: 8),
              AnimatedWrap(
                itemCount: 20,
                listAnimationType: ListAnimationType.None,
                itemBuilder: (_, index) {
                  return ShimmerWidget(
                    height: 250,
                    width: context.width() / 2 - 26,
                  ).paddingAll(8);
                },
              ).paddingAll(8)
            ],
          ),
        ).paddingTop(90),
        Row(
          children: [
            ShimmerWidget(height: 50, width: context.width()).expand(),
            16.width,
            ShimmerWidget(height: 50, width: 45),
          ],
        ).paddingAll(16),
      ],
    );
  }
}
