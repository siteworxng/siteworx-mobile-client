import 'package:client/component/shimmer_widget.dart';
import 'package:flutter/material.dart';
import 'package:nb_utils/nb_utils.dart';

import '../../../utils/constant.dart';

class CategoryShimmer extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: EdgeInsets.all(16),
      physics: AlwaysScrollableScrollPhysics(),
      child: AnimatedWrap(
        key: key,
        runSpacing: 16,
        spacing: 16,
        itemCount: 16,
        listAnimationType: ListAnimationType.None,
        scaleConfiguration: ScaleConfiguration(duration: 300.milliseconds, delay: 50.milliseconds),
        itemBuilder: (_, index) {
          return ShimmerWidget(
            child: SizedBox(
              width: context.width() / 4 - 20,
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
    );
  }
}
