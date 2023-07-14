import 'package:client/component/shimmer_widget.dart';
import 'package:client/utils/common.dart';
import 'package:client/utils/constant.dart';
import 'package:client/utils/images.dart';
import 'package:flutter/material.dart';
import 'package:nb_utils/nb_utils.dart';

class ReviewShimmer extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return AnimatedListView(
      slideConfiguration: sliderConfigurationGlobal,
      shrinkWrap: true,
      padding: EdgeInsets.all(16),
      listAnimationType: ListAnimationType.None,
      itemBuilder: (context, index) {
        return Container(
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
                  ShimmerWidget(height: 50, width: 50),
                  16.width,
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          ShimmerWidget(height: 10, width: context.width()).flexible(),
                          8.width,
                          Row(
                            children: [
                              Image.asset(ic_star_fill, height: 16, color: getRatingBarColor(5)),
                              4.width,
                              Text('5', style: boldTextStyle(color: getRatingBarColor(5), size: 14)),
                            ],
                          ),
                        ],
                      ),
                      8.height,
                      ShimmerWidget(height: 10, width: context.width() * 0.15),
                      ShimmerWidget(height: 10, width: context.width()).paddingTop(8),
                      ShimmerWidget(height: 10, width: context.width()).paddingTop(8),
                    ],
                  ).flexible(),
                ],
              ),
            ],
          ),
        );
      },
    );
  }
}
