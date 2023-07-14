import 'package:client/utils/shimmer/shimmer.dart';
import 'package:flutter/material.dart';
import 'package:nb_utils/nb_utils.dart';

class ShimmerWidget extends StatelessWidget {
  final double? height;
  final double? width;
  final Widget? child;
  final Color? backgroundColor;
  final Color? baseColor;
  final Color? highlightColor;

  ShimmerWidget({this.height, this.width, this.child, this.backgroundColor, this.baseColor, this.highlightColor});

  @override
  Widget build(BuildContext context) {
    return Shimmer.fromColors(
      baseColor: baseColor ?? Colors.grey.withOpacity(0.2),
      highlightColor: highlightColor ?? Colors.transparent,
      enabled: true,
      direction: ShimmerDirection.ltr,
      period: Duration(seconds: 1),
      child: child ??
          Container(
            height: height?.validate(),
            width: width.validate(),
            decoration: boxDecorationWithRoundedCorners(backgroundColor: backgroundColor ?? context.cardColor),
          ),
    );
  }
}
