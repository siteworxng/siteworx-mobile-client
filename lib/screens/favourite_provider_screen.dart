import 'package:client/component/back_widget.dart';
import 'package:client/component/loader_widget.dart';
import 'package:client/main.dart';
import 'package:client/model/user_data_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:nb_utils/nb_utils.dart';

import '../component/empty_error_state_widget.dart';
import '../component/favourite_provider_component.dart';
import '../network/rest_apis.dart';
import '../utils/constant.dart';
import 'shimmer/favourite_provider_shimmer.dart';

class FavouriteProviderScreen extends StatefulWidget {
  const FavouriteProviderScreen({Key? key}) : super(key: key);

  @override
  _FavouriteProviderScreenState createState() => _FavouriteProviderScreenState();
}

class _FavouriteProviderScreenState extends State<FavouriteProviderScreen> {
  Future<List<UserData>>? future;

  List<UserData> providers = [];

  int page = 1;

  bool isLastPage = false;

  @override
  void initState() {
    super.initState();
    init();
  }

  Future<void> init() async {
    future = getProviderWishlist(page, providers: providers, lastPageCallBack: (p0) {
      isLastPage = p0;
    });
  }

  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: context.cardColor,
      appBar: appBarWidget(
        language.favouriteProvider,
        textSize: APP_BAR_TEXT_SIZE,
        color: context.primaryColor,
        textColor: white,
        backWidget: BackWidget(),
      ),
      body: Stack(
        children: [
          FutureBuilder<List<UserData>>(
            future: future,
            builder: (context, snap) {
              if (snap.hasData) {
                if (snap.data.validate().isEmpty)
                  return NoDataWidget(
                    title: language.noProviderFound,
                    subTitle: language.noProviderFoundMessage,
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
                        return FavouriteProviderComponent(
                          data: snap.data![index],
                          width: context.width() * 0.5 - 26,
                          onUpdate: () {
                            page = 1;
                            init();
                            setState(() {});
                          },
                        );
                      },
                    ),
                  ],
                );
              }

              return snapWidgetHelper(
                snap,
                loadingWidget: FavouriteProviderShimmer(),
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
