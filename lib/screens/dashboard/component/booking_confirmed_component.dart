import 'package:client/main.dart';
import 'package:client/screens/booking/booking_detail_screen.dart';
import 'package:flutter/material.dart';
import 'package:nb_utils/nb_utils.dart';

import '../../../model/booking_data_model.dart';
import '../../../utils/colors.dart';
import '../../../utils/common.dart';
import '../../../utils/constant.dart';

class PendingBookingComponent extends StatefulWidget {
  final List<BookingData>? upcomingData;

  PendingBookingComponent({this.upcomingData});

  @override
  State<PendingBookingComponent> createState() => _PendingBookingComponentState();
}

class _PendingBookingComponentState extends State<PendingBookingComponent> {
  @override
  Widget build(BuildContext context) {
    if (widget.upcomingData.validate().isEmpty) return Offstage();

    if (getBoolAsync('$BOOKING_ID_CLOSED_${widget.upcomingData.validate().first.id}')) {
      return Offstage();
    }

    if (widget.upcomingData!.first.status != BOOKING_STATUS_PENDING && widget.upcomingData!.first.status != BOOKING_STATUS_ACCEPT) {
      return Offstage();
    }

    return Container(
      margin: EdgeInsets.all(16),
      padding: EdgeInsets.all(16),
      decoration: boxDecorationRoundedWithShadow(defaultRadius.toInt(), backgroundColor: primaryColor),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  Container(
                    height: 20,
                    width: 3,
                    decoration: boxDecorationRoundedWithShadow(defaultRadius.toInt(), backgroundColor: Colors.white.withOpacity(0.6)),
                  ),
                  8.width,
                  Text(language.bookingConfirmedMsg, style: primaryTextStyle(color: Colors.white, size: LABEL_TEXT_SIZE, fontStyle: FontStyle.italic)),
                ],
              ),
              IconButton(
                icon: Icon(Icons.cancel, color: Colors.white.withOpacity(0.6)),
                visualDensity: VisualDensity.compact,
                onPressed: () async {
                  await setValue('$BOOKING_ID_CLOSED_${widget.upcomingData.validate().first.id}', true);
                  setState(() {});
                },
              ),
            ],
          ),
          16.height,
          Row(
            children: [
              Container(
                height: 42,
                width: 42,
                decoration: boxDecorationRoundedWithShadow(21, backgroundColor: Colors.white.withOpacity(0.2)),
                child: Icon(Icons.library_add_check_outlined, size: 18, color: Colors.white),
              ),
              8.width,
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(widget.upcomingData.validate().first.serviceName.validate(), style: boldTextStyle(color: Colors.white)),
                  2.height,
                  Text(formatDate(widget.upcomingData.validate().first.date.validate(), format: DATE_FORMAT_1), style: primaryTextStyle(color: Colors.white, size: 14)),
                ],
              ).flexible(),
            ],
          )
        ],
      ).onTap(() {
        BookingDetailScreen(bookingId: widget.upcomingData.validate().first.id!).launch(context);
      }),
    );
  }
}
