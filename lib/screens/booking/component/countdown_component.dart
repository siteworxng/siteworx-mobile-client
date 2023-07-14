import 'package:client/main.dart';
import 'package:client/model/booking_detail_model.dart';
import 'package:client/utils/constant.dart';
import 'package:client/utils/model_keys.dart';
import 'package:flutter/material.dart';
import 'package:nb_utils/nb_utils.dart';

class CountdownWidget extends StatefulWidget {
  final String? text;
  final BookingDetailResponse bookingDetailResponse;

  CountdownWidget({this.text, required this.bookingDetailResponse});

  @override
  _CountdownWidgetState createState() => _CountdownWidgetState();
}

class _CountdownWidgetState extends State<CountdownWidget> {
  bool stopTimer = true;

  int value = 0;

  @override
  void initState() {
    if (widget.bookingDetailResponse.bookingDetail!.status.validate() == BookingStatusKeys.inProgress) {
      value = "${(widget.bookingDetailResponse.bookingDetail!.durationDiff.toInt() + DateTime.now().difference(DateTime.parse(widget.bookingDetailResponse.bookingDetail!.startAt.validate())).inSeconds)}".toInt();
      stopTimer = false;
      init();
    } else {
      value = widget.bookingDetailResponse.bookingDetail!.durationDiff.validate().toInt();
    }
    LiveStream().on(LIVESTREAM_START_TIMER, (value) {
      Map<String, dynamic> data = value as Map<String, dynamic>;

      if (data['status'] == BookingStatusKeys.hold || data['status'] == BookingStatusKeys.complete) {
        value = data['inSeconds'] as int;
        stopTimer = true;
        init();
      } else {
        value = data['inSeconds'] as int;
        stopTimer = false;
        init();
      }
      //
    });

    LiveStream().on(LIVESTREAM_PAUSE_TIMER, (value) {
      stopTimer = true;
    });

    super.initState();
  }

  void init() async {
    await 1.seconds.delay;
    value += 1;
    setState(() {});

    if (!stopTimer) init();
  }

  // Logic For Calculate Time
  String calculateTime(int secTime) {
    int hour = 0, minute = 0, seconds = 0;

    hour = secTime ~/ 3600;

    minute = ((secTime - hour * 3600)) ~/ 60;

    seconds = secTime - (hour * 3600) - (minute * 60);

    String hourLeft = hour.toString().length < 2 ? "0" + hour.toString() : hour.toString();

    String minuteLeft = minute.toString().length < 2 ? "0" + minute.toString() : minute.toString();

    String secondsLeft = seconds.toString().length < 2 ? "0" + seconds.toString() : seconds.toString();

    String result = "$hourLeft:$minuteLeft:$secondsLeft";

    return result;
  }

  @override
  void setState(fn) {
    if (mounted) super.setState(fn);
  }

  @override
  void dispose() {
    LiveStream().dispose(LIVESTREAM_PAUSE_TIMER);
    LiveStream().dispose(LIVESTREAM_START_TIMER);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return DottedBorderWidget(
      padding: EdgeInsets.symmetric(horizontal: 8, vertical: 16),
      color: context.dividerColor,
      child: Row(
        children: [
          Text(widget.text ?? '${language.lblServiceTotalTime}: ', style: primaryTextStyle(size: 12)),
          Text(calculateTime(value), style: boldTextStyle(color: Colors.red, size: 14)),
        ],
      ),
    ).withWidth(context.width());
  }
}
