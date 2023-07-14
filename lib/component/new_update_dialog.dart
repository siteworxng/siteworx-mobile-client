import 'dart:io';

import 'package:client/main.dart';
import 'package:client/utils/colors.dart';
import 'package:client/utils/common.dart';
import 'package:client/utils/configs.dart';
import 'package:client/utils/constant.dart';
import 'package:client/utils/images.dart';
import 'package:flutter/material.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:url_launcher/url_launcher.dart';

class NewUpdateDialog extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Stack(
      alignment: Alignment.topCenter,
      clipBehavior: Clip.none,
      children: [
        Container(
          width: context.width() - 16,
          constraints: BoxConstraints(maxHeight: context.height() * 0.6),
          child: AnimatedScrollView(
            listAnimationType: ListAnimationType.FadeIn,
            children: [
              60.height,
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(language.lblNewUpdate, style: boldTextStyle(size: 18)),
                  Text(isAndroid ? remoteConfigDataModel.android!.versionName.validate() : remoteConfigDataModel.iOS!.versionName.validate(), style: boldTextStyle()),
                ],
              ),
              8.height,
              Text('${language.lblAnUpdateTo} $APP_NAME ${language.lblIsAvailableWouldYouLike}', style: secondaryTextStyle(), textAlign: TextAlign.left),
              24.height,
              UL(
                children: remoteConfigDataModel.changeLogs!.map((e) {
                  return Text(e.validate(), style: primaryTextStyle(size: 12));
                }).toList(),
              ),
              24.height,
              Row(
                children: [
                  AppButton(
                    child: Text(language.lblCancel, style: boldTextStyle(color: primaryColor)),
                    shapeBorder: RoundedRectangleBorder(borderRadius: radius(), side: BorderSide(color: primaryColor)),
                    elevation: 0,
                    onTap: () async {
                      if (remoteConfigDataModel.isForceUpdate!) {
                        exit(0);
                      } else {
                        finish(context);
                      }
                    },
                  ).expand(),
                  16.width,
                  AppButton(
                    child: Text(language.lblUpdate, style: boldTextStyle(color: white)),
                    shapeBorder: RoundedRectangleBorder(borderRadius: radius()),
                    color: primaryColor,
                    elevation: 0,
                    onTap: () async {
                      getPackageName().then((value) {
                        String package = '';
                        if (isAndroid) package = value;

                        commonLaunchUrl(
                          isAndroid ? '${getSocialMediaLink(LinkProvider.PLAY_STORE)}$package' : APPSTORE_URL,
                          launchMode: LaunchMode.externalApplication,
                        );

                        if (remoteConfigDataModel.isForceUpdate!) {
                          exit(0);
                        } else {
                          finish(context);
                        }
                      });
                    },
                  ).expand(),
                ],
              ),
            ],
          ).paddingSymmetric(horizontal: 16, vertical: 24),
        ),
        Positioned(
          top: -42,
          child: Image.asset(imgForceUpdate, height: 100, width: 100, fit: BoxFit.cover),
        ),
      ],
    );
  }
}
