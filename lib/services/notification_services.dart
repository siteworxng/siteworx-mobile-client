import 'dart:convert';
import 'dart:io';

import 'package:client/utils/configs.dart';
import 'package:client/utils/constant.dart';
import 'package:client/utils/images.dart';
import 'package:http/http.dart';
import 'package:nb_utils/nb_utils.dart';

class NotificationService {
  Future<void> sendPushNotifications(String title, String content, {String? image, String? email, String? uid, String? receiverPlayerId}) async {
    Map<String, dynamic> data = {};

    if (email.validate().isNotEmpty) {
      data.putIfAbsent("email", () => email);
      data.putIfAbsent("sender_uid", () => uid);
      data.putIfAbsent("receiver_uid", () => receiverPlayerId);
    }

    String oneSignalAppId = getStringAsync(ONESIGNAL_APP_ID_PROVIDER);
    String oneSignalRestKey = getStringAsync(ONESIGNAL_REST_API_KEY_PROVIDER);
    String oneSignalChannelId = getStringAsync(ONESIGNAL_CHANNEL_KEY_PROVIDER);

    log(oneSignalAppId);
    log(oneSignalRestKey);
    log(oneSignalChannelId);

    Map req = {
      'headings': {
        'en': '$title @Chat Notification',
      },
      'contents': {
        'en': content,
      },
      'big_picture': image.validate().isNotEmpty ? image.validate() : '',
      'large_icon': image.validate().isNotEmpty ? image.validate() : '',
      'small_icon': appLogo,
      'data': data,
      'android_visibility': 1,
      'app_id': oneSignalAppId,
      'android_channel_id': oneSignalChannelId,
      'include_player_ids': [receiverPlayerId.validate().trim()],
      'android_group': '$APP_NAME',
      /*"filters": [
        {"field": "providerApp", "relation": "=", "value": title}
      ]*/
    };

    log(req);
    var header = {
      HttpHeaders.authorizationHeader: 'Basic $oneSignalRestKey',
      HttpHeaders.contentTypeHeader: 'application/json; charset=utf-8',
    };

    Response res = await post(
      Uri.parse('https://onesignal.com/api/v1/notifications'),
      body: jsonEncode(req),
      headers: header,
    );

    log(res.statusCode);
    log(res.body);

    if (res.statusCode.isSuccessful()) {
    } else {
      throw errorSomethingWentWrong;
    }
  }
}
