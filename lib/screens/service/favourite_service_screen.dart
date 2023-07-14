import 'package:client/component/back_widget.dart';
import 'package:client/component/loader_widget.dart';
import 'package:client/main.dart';
import 'package:client/model/service_data_model.dart';
import 'package:client/network/rest_apis.dart';
import 'package:client/screens/service/component/service_component.dart';
import 'package:client/screens/service/shimmer/favourite_service_shimmer.dart';
import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:nb_utils/nb_utils.dart';

import '../../component/empty_error_state_widget.dart';
import '../../utils/constant.dart';

class FavouriteServiceScreen extends StatefulWidget {
  const FavouriteServiceScreen({Key? key}) : super(key: key);

  @override
  _FavouriteServiceScreenState createState() => _FavouriteServiceScreenState();
}

class _FavouriteServiceScreenState extends State<FavouriteServiceScreen> {
  Future<List<ServiceData>>? future;

  List<ServiceData> services = [];

  int page = 1;

  bool isLastPage = false;

  @override
  void initState() {
    super.initState();
    init();
  }

  Future<void> init() async {
    future = getWishlist(page, services: services, lastPageCallBack: (p0) {
      isLastPage = p0;
    });
  }

  Widget build(BuildContext context) {
    return Scaffold(
      appBar: appBarWidget(
        language.lblFavorite,
        color: context.primaryColor,
        textColor: white,
        backWidget: BackWidget(),
        textSize: APP_BAR_TEXT_SIZE,
      ),
      body: Stack(
        children: [
          FutureBuilder<List<ServiceData>>(
            future: future,
            builder: (context, snap) {
              if (snap.hasData) {
                if (snap.data.validate().isEmpty)
                  return NoDataWidget(
                    title: language.lblNoServicesFound,
                    subTitle: language.noFavouriteSubTitle,
                    imageWidget: EmptyStateWidget(),
                  );

                return AnimatedScrollView(
                  padding: EdgeInsets.fromLTRB(16, 16, 16, 60),
                  listAnimationType: ListAnimationType.FadeIn,
                  fadeInConfiguration: FadeInConfiguration(duration: 2.seconds),
                  physics: AlwaysScrollableScrollPhysics(),
                  onNextPage: () {
                    if (!isLastPage) {
                      page++;
                      appStore.setLoading(true);

                      init();
                      setState(() {});
                    }
                  },
                  onSwipeRefresh: () async {
                    page = 1;

                    init();
                    setState(() {});

                    return await 2.seconds.delay;
                  },
                  children: [
                    AnimatedWrap(
                      spacing: 16,
                      runSpacing: 16,
                      listAnimationType: ListAnimationType.FadeIn,
                      fadeInConfiguration: FadeInConfiguration(duration: 2.seconds),
                      scaleConfiguration: ScaleConfiguration(duration: 300.milliseconds, delay: 50.milliseconds),
                      itemCount: snap.data!.length,
                      itemBuilder: (_, index) {
                        return ServiceComponent(
                          serviceData: snap.data![index],
                          width: context.width() / 2 - 24,
                          isFavouriteService: true,
                          onUpdate: () async {
                            page = 1;
                            await init();
                            setState(() {});
                          },
                        );
                      },
                    )
                  ],
                );
              }

              return snapWidgetHelper(
                snap,
                loadingWidget: FavouriteServiceShimmer(),
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
              );
            },
          ),
          Observer(builder: (context) => LoaderWidget().visible(appStore.isLoading)),
        ],
      ),
    );
  }
}
