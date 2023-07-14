import 'package:client/component/back_widget.dart';
import 'package:client/component/user_info_widget.dart';
import 'package:client/component/view_all_label_component.dart';
import 'package:client/main.dart';
import 'package:client/model/provider_info_response.dart';
import 'package:client/network/rest_apis.dart';
import 'package:client/screens/review/components/review_widget.dart';
import 'package:client/screens/review/rating_view_all_screen.dart';
import 'package:client/utils/constant.dart';
import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:nb_utils/nb_utils.dart';

import '../../component/base_scaffold_widget.dart';
import '../../component/empty_error_state_widget.dart';
import '../../component/loader_widget.dart';
import '../../utils/colors.dart';
import '../../utils/common.dart';
import '../../utils/images.dart';

class HandymanInfoScreen extends StatefulWidget {
  final int? handymanId;

  HandymanInfoScreen({this.handymanId});

  @override
  HandymanInfoScreenState createState() => HandymanInfoScreenState();
}

class HandymanInfoScreenState extends State<HandymanInfoScreen> {
  Future<ProviderInfoResponse>? future;

  int page = 1;

  @override
  void initState() {
    super.initState();
    init();
  }

  Future<void> init() async {
    future = getProviderDetail(widget.handymanId.validate(), userId: appStore.userId.validate());
  }

  @override
  void setState(fn) {
    if (mounted) super.setState(fn);
  }

  @override
  Widget build(BuildContext context) {
    return AppScaffold(
      child: Stack(
        children: [
          SnapHelperWidget<ProviderInfoResponse>(
            future: future,
            onSuccess: (data) {
              return AnimatedScrollView(
                listAnimationType: ListAnimationType.FadeIn,
                physics: AlwaysScrollableScrollPhysics(),
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    margin: EdgeInsets.only(top: context.statusBarHeight),
                    color: context.primaryColor,
                    child: Row(
                      children: [
                        BackWidget(),
                        16.width,
                        Text(language.lblAboutHandyman, style: boldTextStyle(color: Colors.white, size: 18)),
                      ],
                    ),
                  ),
                  UserInfoWidget(data: data.userData!, isOnTapEnabled: true, forProvider: false),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          if (data.userData!.knownLanguagesArray.isNotEmpty)
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(language.knownLanguages, style: boldTextStyle()),
                                8.height,
                                Wrap(
                                  children: data.userData!.knownLanguagesArray.map((e) {
                                    return Container(
                                      decoration: boxDecorationWithRoundedCorners(
                                        borderRadius: BorderRadius.all(Radius.circular(4)),
                                        backgroundColor: appStore.isDarkMode ? cardDarkColor : primaryColor.withOpacity(0.1),
                                      ),
                                      padding: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                                      margin: EdgeInsets.all(4),
                                      child: Text(e, style: secondaryTextStyle(weight: FontWeight.bold)),
                                    );
                                  }).toList(),
                                ),
                                16.height,
                              ],
                            ),
                          if (data.userData!.skillsArray.isNotEmpty)
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(language.essentialSkills, style: boldTextStyle()),
                                8.height,
                                Wrap(
                                  children: data.userData!.skillsArray.map((e) {
                                    return Container(
                                      decoration: boxDecorationWithRoundedCorners(
                                        borderRadius: BorderRadius.all(Radius.circular(4)),
                                        backgroundColor: appStore.isDarkMode ? cardDarkColor : primaryColor.withOpacity(0.1),
                                      ),
                                      padding: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                                      margin: EdgeInsets.all(4),
                                      child: Text(e, style: secondaryTextStyle(weight: FontWeight.bold)),
                                    );
                                  }).toList(),
                                ),
                                16.height,
                              ],
                            ),
                          if (data.userData!.description != null)
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(language.lblAboutHandyman, style: boldTextStyle()),
                                8.height,
                                Text(data.userData!.description.validate(), style: secondaryTextStyle()),
                                16.height,
                              ],
                            ),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(language.personalInfo, style: boldTextStyle()),
                              8.height,
                              TextIcon(
                                spacing: 10,
                                onTap: () {
                                  launchMail("${data.userData!.email.validate()}");
                                },
                                prefix: Image.asset(ic_message, width: 16, height: 16, color: appStore.isDarkMode ? Colors.white : context.primaryColor),
                                text: data.userData!.email.validate(),
                                textStyle: secondaryTextStyle(size: 14),
                                expandedText: true,
                              ),
                              4.height,
                              TextIcon(
                                spacing: 10,
                                onTap: () {
                                  launchCall("${data.userData!.contactNumber.validate()}");
                                },
                                prefix: Image.asset(ic_calling, width: 16, height: 16, color: appStore.isDarkMode ? Colors.white : context.primaryColor),
                                text: data.userData!.contactNumber.validate(),
                                textStyle: secondaryTextStyle(size: 14),
                                expandedText: true,
                              ),
                            ],
                          ),
                          8.height,
                        ],
                      ),
                      ViewAllLabel(
                        label: language.review,
                        list: data.handymanRatingReviewList,
                        onTap: () {
                          RatingViewAllScreen(handymanId: data.userData!.id).launch(context);
                        },
                      ),
                      data.handymanRatingReviewList.validate().isNotEmpty
                          ? AnimatedListView(
                              shrinkWrap: true,
                              physics: NeverScrollableScrollPhysics(),
                              slideConfiguration: sliderConfigurationGlobal,
                              padding: EdgeInsets.symmetric(vertical: 6),
                              itemCount: data.handymanRatingReviewList.validate().length,
                              itemBuilder: (context, index) => ReviewWidget(data: data.handymanRatingReviewList.validate()[index], isCustomer: true),
                            )
                          : Text(language.lblNoReviews, style: secondaryTextStyle()).center().paddingOnly(top: 16),
                    ],
                  ).paddingAll(16),
                ],
              );
            },
            errorBuilder: (error) {
              return NoDataWidget(
                title: error,
                imageWidget: ErrorStateWidget(),
                retryText: language.reload,
                onRetry: () {
                  page = 1;
                  appStore.setLoading(true);

                  init();
                  setState(() {});
                },
              );
            },
            loadingWidget: LoaderWidget(),
          ),
          Observer(builder: (_) => LoaderWidget().visible(appStore.isLoading)),
        ],
      ),
    );
  }
}
