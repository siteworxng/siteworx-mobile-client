import 'package:client/component/shimmer_widget.dart';
import 'package:flutter/material.dart';
import 'package:nb_utils/nb_utils.dart';

class BookingShimmer extends StatelessWidget {
  const BookingShimmer({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        children: [
          ShimmerWidget(
            height: 50,
            width: context.width(),
          ).paddingSymmetric(vertical: 16, horizontal: 16),
          AnimatedListView(
            physics: NeverScrollableScrollPhysics(),
            padding: EdgeInsets.only(bottom: 16, top: 16, right: 16, left: 16),
            itemCount: 20,
            shrinkWrap: true,
            listAnimationType: ListAnimationType.None,
            itemBuilder: (_, index) {
              return Container(
                width: context.width(),
                padding: EdgeInsets.all(8),
                margin: EdgeInsets.only(bottom: 16),
                decoration: BoxDecoration(color: context.scaffoldBackgroundColor, border: Border.all(color: context.dividerColor), borderRadius: radius()),
                child: Column(
                  children: [
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        ShimmerWidget(height: 80, width: 80),
                        16.width,
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Container(
                                  padding: EdgeInsets.symmetric(vertical: 4),
                                  decoration: BoxDecoration(borderRadius: radius(8), color: Colors.transparent),
                                  child: ShimmerWidget(height: 20, width: context.width() * 0.24),
                                ).flexible(),
                                8.width,
                                ShimmerWidget(height: 20, width: 50),
                              ],
                            ),
                            4.height,
                            ShimmerWidget(height: 20, width: context.width()),
                            4.height,
                            ShimmerWidget(height: 20, width: context.width()),
                          ],
                        ).expand(),
                      ],
                    ).paddingAll(8),
                    Container(
                      decoration: boxDecorationWithRoundedCorners(
                        backgroundColor: context.cardColor,
                        borderRadius: BorderRadius.all(Radius.circular(16)),
                      ),
                      width: context.width(),
                      margin: EdgeInsets.all(8),
                      child: Column(
                        children: [
                          8.height,
                          ShimmerWidget(height: 10, width: context.width()),
                          8.height,
                          Divider(height: 0, color: context.dividerColor),
                          ShimmerWidget(height: 10, width: context.width()),
                          8.height,
                          Divider(height: 0, color: context.dividerColor),
                          ShimmerWidget(height: 10, width: context.width()),
                          8.height,
                          Divider(height: 0, color: context.dividerColor),
                          ShimmerWidget(height: 10, width: context.width()),
                          8.height,
                        ],
                      ).paddingAll(8),
                    ),
                  ],
                ),
              );
            },
          ),
        ],
      ),
    );
  }
}
