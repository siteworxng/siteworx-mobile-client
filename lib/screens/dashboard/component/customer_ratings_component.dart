import 'package:client/main.dart';
import 'package:client/screens/auth/sign_in_screen.dart';
import 'package:client/screens/dashboard/customer_rating_screen.dart';
import 'package:client/screens/dashboard/dashboard_screen.dart';
import 'package:client/utils/colors.dart';
import 'package:client/utils/images.dart';
import 'package:flutter/material.dart';
import 'package:nb_utils/nb_utils.dart';

class CustomerRatingsComponent extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(vertical: 32, horizontal: 16),
      width: context.width(),
      decoration: boxDecorationDefault(color: primaryColor, borderRadius: radius(0)),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Image.asset(ic_customer_rating_stars),
          26.height,
          Text(language.lblIntroducingCustomerRating, style: primaryTextStyle(size: 18, color: Colors.white)),
          16.height,
          AppButton(
            text: language.lblSeeYourRatings,
            textStyle: primaryTextStyle(color: appStore.isDarkMode ? textPrimaryColorGlobal : primaryColor),
            onTap: () {
              if (appStore.isLoggedIn) {
                CustomerRatingScreen().launch(context);
              } else {
                setStatusBarColor(Colors.white, statusBarIconBrightness: Brightness.dark);

                SignInScreen().launch(context).then((value) {
                  setStatusBarColor(transparentColor, delayInMilliSeconds: 1000);
                  if (value ?? false) {
                    DashboardScreen().launch(context, isNewTask: true, pageRouteAnimation: PageRouteAnimation.Fade);
                  }
                });
              }
            },
          )
        ],
      ),
    );
  }
}
