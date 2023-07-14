import 'package:client/component/disabled_rating_bar_widget.dart';
import 'package:client/component/shimmer_widget.dart';
import 'package:flutter/material.dart';
import 'package:nb_utils/nb_utils.dart';

class RattingShimmer extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return AnimatedListView(
      listAnimationType: ListAnimationType.None,
      padding: EdgeInsets.fromLTRB(8, 16, 8, 80),
      itemBuilder: (_, i) {
        return Container(
          padding: EdgeInsets.all(16),
          margin: EdgeInsets.all(8),
          decoration: boxDecorationDefault(color: context.cardColor),
          child: Column(
            children: [
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  ShimmerWidget(height: 75, width: 75).cornerRadiusWithClipRRect(defaultRadius),
                  16.width,
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      ShimmerWidget(height: 10, width: context.width()),
                      ShimmerWidget(height: 15, width: context.width() * 0.15),
                    ],
                  ).flexible()
                ],
              ),
              16.height,
              Container(
                decoration: boxDecorationDefault(color: context.scaffoldBackgroundColor),
                padding: EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        ShimmerWidget(height: 10, width: context.width()).expand(),
                        8.width,
                        ShimmerWidget(height: 20, width: 20).cornerRadiusWithClipRRect(10),
                        4.width,
                        ShimmerWidget(height: 20, width: 20).cornerRadiusWithClipRRect(10),
                      ],
                    ),
                    Divider(color: context.dividerColor),
                    DisabledRatingBarWidget(rating: 5),
                    8.height,
                    ShimmerWidget(height: 10, width: context.width()),
                  ],
                ),
              )
            ],
          ),
        );
      },
    );
  }
}
