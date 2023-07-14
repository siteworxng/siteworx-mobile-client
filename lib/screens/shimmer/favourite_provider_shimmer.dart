import 'package:client/component/shimmer_widget.dart';
import 'package:client/main.dart';
import 'package:flutter/material.dart';
import 'package:nb_utils/nb_utils.dart';

class FavouriteProviderShimmer extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: AnimatedWrap(
        spacing: 16,
        runSpacing: 16,
        listAnimationType: ListAnimationType.Scale,
        scaleConfiguration: ScaleConfiguration(duration: 300.milliseconds, delay: 50.milliseconds),
        itemCount: 20,
        itemBuilder: (_, index) {
          return Container(
            height: 180,
            width: context.width() * 0.5 - 26,
            decoration: boxDecorationWithRoundedCorners(borderRadius: radius(), backgroundColor: appStore.isDarkMode ? context.scaffoldBackgroundColor : white),
            child: Column(
              children: [
                ShimmerWidget(height: 120, width: context.width(), backgroundColor: context.cardColor),
                16.height,
                ShimmerWidget(height: 10, width: context.width() * 0.23),
              ],
            ),
          );
        },
      ).paddingOnly(left: 16, top: 16, right: 16, bottom: 40),
    );
  }
}
