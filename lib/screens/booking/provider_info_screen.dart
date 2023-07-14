import 'package:client/component/back_widget.dart';
import 'package:client/component/loader_widget.dart';
import 'package:client/component/user_info_widget.dart';
import 'package:client/component/view_all_label_component.dart';
import 'package:client/main.dart';
import 'package:client/model/provider_info_response.dart';
import 'package:client/model/service_data_model.dart';
import 'package:client/network/rest_apis.dart';
import 'package:client/screens/service/component/service_component.dart';
import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:nb_utils/nb_utils.dart';

import '../../component/empty_error_state_widget.dart';
import '../../utils/colors.dart';
import '../../utils/common.dart';
import '../../utils/images.dart';
import '../service/view_all_service_screen.dart';

class ProviderInfoScreen extends StatefulWidget {
  final int? providerId;
  final bool canCustomerContact;
  final VoidCallback? onUpdate;

  ProviderInfoScreen({this.providerId, this.canCustomerContact = false, this.onUpdate});

  @override
  ProviderInfoScreenState createState() => ProviderInfoScreenState();
}

class ProviderInfoScreenState extends State<ProviderInfoScreen> {
  Future<ProviderInfoResponse>? future;
  int page = 1;

  @override
  void initState() {
    super.initState();
    init();
  }

  Future<void> init() async {
    future = getProviderDetail(widget.providerId.validate(), userId: appStore.userId.validate());
  }

  @override
  void setState(fn) {
    if (mounted) super.setState(fn);
  }

  Widget servicesWidget({required List<ServiceData> list, int? providerId}) {
    return Column(
      children: [
        ViewAllLabel(
          label: language.service,
          list: list,
          onTap: () {
            ViewAllServiceScreen(providerId: providerId).launch(context, pageRouteAnimation: PageRouteAnimation.Fade);
          },
        ),
        8.height,
        if (list.isEmpty) NoDataWidget(title: language.lblNoServicesFound, imageWidget: EmptyStateWidget()),
        if (list.isNotEmpty)
          AnimatedWrap(
            spacing: 16,
            runSpacing: 16,
            itemCount: list.length,
            listAnimationType: ListAnimationType.FadeIn,
            fadeInConfiguration: FadeInConfiguration(duration: 2.seconds),
            scaleConfiguration: ScaleConfiguration(duration: 300.milliseconds, delay: 50.milliseconds),
            itemBuilder: (_, index) => ServiceComponent(serviceData: list[index], width: context.width()),
          )
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () {
        finish(context);
        widget.onUpdate?.call();
        return Future.value(true);
      },
      child: Scaffold(
        body: SnapHelperWidget<ProviderInfoResponse>(
          future: future,
          onSuccess: (data) {
            return Stack(
              children: [
                AnimatedScrollView(
                  listAnimationType: ListAnimationType.FadeIn,
                  physics: AlwaysScrollableScrollPhysics(),
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      margin: EdgeInsets.only(top: context.statusBarHeight),
                      color: context.primaryColor,
                      child: Row(
                        children: [
                          BackWidget(onPressed: () {
                            finish(context);
                            widget.onUpdate?.call();
                          }),
                          16.width,
                          Text(language.lblAboutProvider, style: boldTextStyle(color: Colors.white, size: 18)),
                        ],
                      ),
                    ),
                    UserInfoWidget(
                      data: data.userData!,
                      isOnTapEnabled: true,
                      onUpdate: () {
                        widget.onUpdate?.call();
                      },
                    ),
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
                              Text(language.lblAboutProvider, style: boldTextStyle()),
                              8.height,
                              Text(data.userData!.description.validate(), style: secondaryTextStyle()),
                              16.height,
                            ],
                          ),
                        if (widget.canCustomerContact)
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
                              8.height,
                            ],
                          ),
                        servicesWidget(list: data.serviceList!, providerId: widget.providerId.validate()),
                      ],
                    ).paddingAll(16),
                  ],
                  onSwipeRefresh: () async {
                    page = 1;

                    init();
                    setState(() {});

                    return await 2.seconds.delay;
                  },
                ),
                Observer(builder: (context) => LoaderWidget().visible(appStore.isLoading))
              ],
            );
          },
          loadingWidget: LoaderWidget(),
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
        ),
      ),
    );
  }
}
