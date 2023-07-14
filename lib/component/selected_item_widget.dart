import 'package:client/utils/colors.dart';
import 'package:flutter/material.dart';
import 'package:nb_utils/nb_utils.dart';

// ignore: must_be_immutable
class SelectedItemWidget extends StatelessWidget {
  Decoration? decoration;
  double itemSize;
  bool isSelected;

  SelectedItemWidget({this.decoration, this.itemSize = 12.0, required this.isSelected});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(2),
      height: 18,
      width: 18,
      decoration: decoration ??
          boxDecorationDefault(
            color: isSelected ? primaryColor : context.cardColor,
            border: Border.all(color: primaryColor),
            shape: BoxShape.circle,
          ),
      child: isSelected ? Icon(Icons.check, color: Colors.white, size: itemSize) : Offstage(),
    );
  }
}
