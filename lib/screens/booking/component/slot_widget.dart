import 'package:client/main.dart';
import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:nb_utils/nb_utils.dart';

class SlotWidget extends StatelessWidget {
  final bool isAvailable;
  final bool isSelected;
  final String value;
  final Color activeColor;
  final Color inActiveColor;
  final Function() onTap;

  SlotWidget({
    required this.isAvailable,
    required this.isSelected,
    required this.value,
    this.activeColor = Colors.green,
    this.inActiveColor = Colors.green,
    required this.onTap,
  });

  Color _getBackgroundColor(BuildContext context) {
    if (isAvailable && isSelected) {
      return activeColor;
    } else if (isSelected) {
      return activeColor;
    } else {
      return context.cardColor;
    }
  }

  Color _getTextColor() {
    if (isAvailable && isSelected) {
      return Colors.white;
    } else if (isSelected) {
      return Colors.white;
    } else {
      return textPrimaryColorGlobal;
    }
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: context.width() / 3 - 22,
        decoration: boxDecorationDefault(
          boxShadow: defaultBoxShadow(blurRadius: 0, spreadRadius: 0),
          border: Border.all(color: isAvailable ? activeColor : transparentColor),
          color: _getBackgroundColor(context),
        ),
        padding: EdgeInsets.all(12),
        child: Observer(builder: (context) {
          return Text(
            appStore.is24HourFormat ? value.splitBefore(':00') : TimeOfDay(hour: value.split(':').first.toInt(), minute: 00).format(context),
            style: primaryTextStyle(color: _getTextColor()),
          ).center();
        }),
      ),
    );
  }
}
