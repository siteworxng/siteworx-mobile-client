import 'package:client/component/shimmer_widget.dart';
import 'package:flutter/material.dart';
import 'package:nb_utils/nb_utils.dart';

class MyPostJobShimmer extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return AnimatedListView(
      padding: EdgeInsets.only(top: 12, bottom: 70),
      listAnimationType: ListAnimationType.None,
      itemBuilder: (_, i) {
        return Container(
          decoration: boxDecorationWithRoundedCorners(borderRadius: radius(), backgroundColor: context.cardColor),
          width: context.width(),
          margin: EdgeInsets.only(top: 12, bottom: 8, left: 16, right: 16),
          padding: EdgeInsets.only(top: 12, bottom: 12, left: 16, right: 16),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              ShimmerWidget(height: 80, width: 80).cornerRadiusWithClipRRect(defaultRadius),
              16.width,
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      ShimmerWidget(height: 10, width: context.width() * 0.25).expand(),
                      8.width,
                      Container(
                        padding: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                        decoration: BoxDecoration(color: context.scaffoldBackgroundColor, borderRadius: radius(8)),
                        child: ShimmerWidget(height: 10, width: context.width() * 0.1),
                      ),
                    ],
                  ),
                  4.height,
                  ShimmerWidget(height: 10, width: context.width() * 0.25),
                  4.height,
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      ShimmerWidget(height: 10, width: context.width() * 0.25),
                      ShimmerWidget(height: 20, width: 20).cornerRadiusWithClipRRect(10),
                    ],
                  ),
                ],
              ).expand(),
            ],
          ),
        );
      },
    );
  }
}
