import 'package:client/main.dart';
import 'package:client/utils/constant.dart';
import 'package:flutter/material.dart';
import 'package:nb_utils/nb_utils.dart';

class ViewAllLabel extends StatelessWidget {
  final String label;
  final List? list;
  final VoidCallback? onTap;
  final int? labelSize;

  ViewAllLabel({required this.label, this.onTap, this.labelSize, this.list});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(label, style: boldTextStyle(size: labelSize ?? LABEL_TEXT_SIZE)),
        TextButton(
          onPressed: (list == null ? true : isViewAllVisible(list!))
              ? () {
                  onTap?.call();
                }
              : null,
          child: (list == null ? true : isViewAllVisible(list!)) ? Text(language.lblViewAll, style: secondaryTextStyle()) : SizedBox(),
        )
      ],
    );
  }
}

bool isViewAllVisible(List list) => list.length >= 4;
