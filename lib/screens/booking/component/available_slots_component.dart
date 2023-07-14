import 'package:client/main.dart';
import 'package:client/screens/booking/component/slot_widget.dart';
import 'package:flutter/material.dart';
import 'package:nb_utils/nb_utils.dart';

class AvailableSlotsComponent extends StatefulWidget {
  final List<String>? selectedSlots;
  final List<String> availableSlots;
  final Function(List<String> selectedSlots) onChanged;
  final bool? isProvider;
  final DateTime? selectedDate;

  AvailableSlotsComponent({
    this.selectedSlots,
    required this.availableSlots,
    required this.onChanged,
    this.isProvider = true,
    this.selectedDate,
    Key? key,
  }) : super(key: key);

  @override
  _AvailableSlotsComponentState createState() => _AvailableSlotsComponentState();
}

class _AvailableSlotsComponentState extends State<AvailableSlotsComponent> {
  List<String> localSelectedSlot = [];

  DateTime currentTime = DateTime.now();

  int selectedIndex = -1;

  @override
  void initState() {
    super.initState();
    afterBuildCreated(() {
      init();
    });
  }

  void init() async {
    if (widget.selectedSlots.validate().isNotEmpty) {
      localSelectedSlot = widget.selectedSlots.validate();
      widget.onChanged.call(localSelectedSlot);
    }
  }

  @override
  void setState(fn) {
    if (mounted) super.setState(fn);
  }

  @override
  Widget build(BuildContext context) {
    if (widget.isProvider.validate()) {
      return AnimatedWrap(
        spacing: 16,
        runSpacing: 16,
        itemCount: widget.availableSlots.length,
        itemBuilder: (_, index) {
          String value = "${(index + 1).toString().length >= 2 ? index + 1 : '0${index + 1}'}:00:00";

          if (widget.selectedDate != null) {
            DateTime finalDate = DateTime(
              widget.selectedDate!.year,
              widget.selectedDate!.month,
              widget.selectedDate!.day,
              widget.selectedDate!.hour,
              widget.selectedDate!.minute,
            );

            DateTime now = DateTime(
              currentTime.year,
              currentTime.month,
              currentTime.day,
              value.substring(0, 2).toInt(),
              value.substring(3, 5).toInt(),
            ).subtract(1.minutes);

            if (widget.selectedDate!.isToday && finalDate.millisecondsSinceEpoch > now.millisecondsSinceEpoch) {
              return Offstage();
            }
          }

          bool isSelected = localSelectedSlot.contains(value);

          return SlotWidget(
            isAvailable: false,
            isSelected: isSelected,
            value: value,
            onTap: () {
              if (isSelected) {
                localSelectedSlot.remove(value);
              } else {
                localSelectedSlot.add(value);
              }

              setState(() {});

              widget.onChanged.call(localSelectedSlot);
            },
          );
        },
      );
    }
    return AnimatedWrap(
      spacing: 16,
      runSpacing: 16,
      itemCount: widget.availableSlots.length,
      itemBuilder: (_, index) {
        String value = widget.availableSlots[index];

        if (widget.selectedDate != null) {
          DateTime finalDate = DateTime(
            widget.selectedDate!.year,
            widget.selectedDate!.month,
            widget.selectedDate!.day,
            widget.selectedDate!.hour,
            widget.selectedDate!.minute,
          );

          DateTime now = DateTime(
            currentTime.year,
            currentTime.month,
            currentTime.day,
            value.substring(0, 2).toInt(),
            value.substring(3, 5).toInt(),
          ).subtract(1.minutes);

          if (widget.selectedDate!.isToday && finalDate.millisecondsSinceEpoch > now.millisecondsSinceEpoch) {
            return Offstage();
          }
        }

        if (widget.selectedSlots.validate().isNotEmpty) {
          if (widget.selectedSlots.validate().first == value) {
            selectedIndex = index;
          }
        }
        bool isSelected = selectedIndex == index;
        bool isAvailable = widget.availableSlots.contains(value);

        return SlotWidget(
          isAvailable: isAvailable,
          isSelected: isSelected,
          value: value,
          onTap: () {
            if (isAvailable) {
              if (isSelected) {
                selectedIndex = -1;
                widget.onChanged.call([]);
              } else {
                selectedIndex = index;
                widget.onChanged.call([value]);
              }
              setState(() {});
            } else {
              toast(language.lblTimeSlotNotAvailable);
            }
          },
        );
      },
    );
  }
}
