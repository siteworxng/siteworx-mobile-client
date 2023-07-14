import 'package:client/component/image_border_component.dart';
import 'package:client/model/notification_model.dart';
import 'package:client/utils/images.dart';
import 'package:flutter/material.dart';
import 'package:nb_utils/nb_utils.dart';

class NotificationWidget extends StatelessWidget {
  final NotificationData data;

  NotificationWidget({required this.data});

  /*static String getTime(String inputString, String time) {
    List<String> wordList = inputString.split(" ");
    if (wordList.isNotEmpty) {
      return wordList[0] + ' ' + time;
    } else {
      return ' ';
    }
  }*/

  Color _getBGColor(BuildContext context) {
    if (data.readAt != null) {
      return context.scaffoldBackgroundColor;
    } else {
      return context.cardColor;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: context.width(),
      padding: EdgeInsets.symmetric(vertical: 10, horizontal: 16),
      decoration: boxDecorationDefault(
        color: _getBGColor(context),
        borderRadius: radius(0),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          data.profileImage.validate().isNotEmpty
              ? ImageBorder(
                  src: data.profileImage.validate(),
                  height: 40,
                )
              : ImageBorder(
                  src: ic_notification_user,
                  height: 40,
                ),
          16.width,
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('${data.data!.type.validate().split('_').join(' ').capitalizeFirstLetter()}', style: boldTextStyle(size: 12)).expand(),
                  Text(data.createdAt.validate(), style: secondaryTextStyle()),
                ],
              ),
              4.height,
              Text(data.data!.message!, style: secondaryTextStyle(), maxLines: 3, overflow: TextOverflow.ellipsis),
            ],
          ).expand(),
        ],
      ),
    );
  }
}
