import 'package:client/main.dart';
import 'package:client/model/dashboard_model.dart';
import 'package:client/network/rest_apis.dart';
import 'package:client/screens/dashboard/component/category_component.dart';
import 'package:client/screens/dashboard/component/featured_service_list_component.dart';
import 'package:client/screens/dashboard/component/service_list_component.dart';
import 'package:client/screens/dashboard/component/slider_and_location_component.dart';
import 'package:client/screens/dashboard/shimmer/dashboard_shimmer.dart';
import 'package:client/utils/constant.dart';
import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:nb_utils/nb_utils.dart';

import '../../../component/empty_error_state_widget.dart';
import '../../../component/loader_widget.dart';
import '../component/booking_confirmed_component.dart';
import '../component/new_job_request_component.dart';

class DashboardFragment extends StatefulWidget {
  @override
  _DashboardFragmentState createState() => _DashboardFragmentState();
}

class _DashboardFragmentState extends State<DashboardFragment> {
  Future<DashboardResponse>? future;

  int page = 1;

  @override
  void initState() {
    super.initState();
    init();

    setStatusBarColor(transparentColor, delayInMilliSeconds: 800);

    LiveStream().on(LIVESTREAM_UPDATE_DASHBOARD, (p0) {
      setState(() {});
    });
  }

  void init() async {
    future = userDashboard(isCurrentLocation: appStore.isCurrentLocation, lat: getDoubleAsync(LATITUDE), long: getDoubleAsync(LONGITUDE));
  }

  @override
  void setState(fn) {
    if (mounted) super.setState(fn);
  }

  @override
  void dispose() {
    super.dispose();
    LiveStream().dispose(LIVESTREAM_UPDATE_DASHBOARD);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          SnapHelperWidget<DashboardResponse>(
            initialData: cachedDashboardResponse,
            future: future,
            errorBuilder: (error) {
              return NoDataWidget(
                title: error,
                imageWidget: ErrorStateWidget(),
                retryText: language.reload,
                onRetry: () {
                  appStore.setLoading(true);
                  init();

                  setState(() {});
                },
              );
            },
            loadingWidget: DashboardShimmer(),
            onSuccess: (snap) {
              return AnimatedScrollView(
                physics: AlwaysScrollableScrollPhysics(),
                listAnimationType: ListAnimationType.FadeIn,
                fadeInConfiguration: FadeInConfiguration(duration: 2.seconds),
                onSwipeRefresh: () async {
                  page = 1;
                  appStore.setLoading(true);

                  init();
                  setState(() {});

                  return await 2.seconds.delay;
                },
                children: [
                  SliderLocationComponent(
                    sliderList: snap.slider.validate(),
                    callback: () async {
                      appStore.setLoading(true);
                      init();
                      await 300.milliseconds.delay;
                      setState(() {});
                    },
                  ),
                  30.height,
                  PendingBookingComponent(upcomingData: snap.upcomingData),
                  CategoryComponent(categoryList: snap.category.validate()),
                  16.height,
                  FeaturedServiceListComponent(serviceList: snap.featuredServices.validate()),
                  ServiceListComponent(serviceList: snap.service.validate()),
                  16.height,
                  NewJobRequestComponent(),
                ],
              );
            },
          ),
          Observer(builder: (context) => LoaderWidget().visible(appStore.isLoading)),
        ],
      ),
    );
  }
}
