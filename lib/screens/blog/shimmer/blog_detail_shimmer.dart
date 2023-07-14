import 'package:client/component/back_widget.dart';
import 'package:client/component/shimmer_widget.dart';
import 'package:flutter/material.dart';
import 'package:nb_utils/nb_utils.dart';

class BlogDetailShimmer extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          /// Blog Header Widget
          SizedBox(
            height: 400,
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
                  bottom: 16,
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
                              decoration: BoxDecoration(borderRadius: radius(), color: Colors.grey.withOpacity(0.2)),
                              alignment: Alignment.center,
                              child: Text('+' '5', style: boldTextStyle(color: white)),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),

          /// blog Detail
          16.height,
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              ShimmerWidget(height: 10, width: context.width()),
              8.height,
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  ShimmerWidget(height: 10, width: context.width() * 0.25),
                  ShimmerWidget(height: 10, width: context.width() * 0.25),
                ],
              ),
              12.height,
              ListView.builder(
                shrinkWrap: true,
                itemCount: 15,
                physics: NeverScrollableScrollPhysics(),
                itemBuilder: (_, i) {
                  return Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      ShimmerWidget(height: 10, width: context.width()),
                      8.height,
                    ],
                  );
                },
              ),
            ],
          ).paddingSymmetric(vertical: 16, horizontal: 16)
        ],
      ),
    );
  }
}
