import 'package:client/component/back_widget.dart';
import 'package:client/component/loader_widget.dart';
import 'package:client/main.dart';
import 'package:client/model/category_model.dart';
import 'package:client/network/rest_apis.dart';
import 'package:client/screens/category/shimmer/category_shimmer.dart';
import 'package:client/screens/dashboard/component/category_widget.dart';
import 'package:client/utils/colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:nb_utils/nb_utils.dart';

import '../../component/empty_error_state_widget.dart';
import '../../utils/constant.dart';
import '../service/view_all_service_screen.dart';

class CategoryScreen extends StatefulWidget {
  @override
  _CategoryScreenState createState() => _CategoryScreenState();
}

class _CategoryScreenState extends State<CategoryScreen> {
  late Future<List<CategoryData>> future;
  List<CategoryData> categoryList = [];

  int page = 1;
  bool isLastPage = false;
  bool isApiCalled = false;

  UniqueKey key = UniqueKey();

  void initState() {
    super.initState();
    init();
  }

  void init() async {
    future = getCategoryListWithPagination(page, categoryList: categoryList, lastPageCallBack: (val) {
      isLastPage = val;
    });
    if (page == 1) {
      key = UniqueKey();
    }
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  void setState(fn) {
    if (mounted) super.setState(fn);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: appBarWidget(
        language.lblCategory,
        textColor: Colors.white,
        textSize: APP_BAR_TEXT_SIZE,
        color: primaryColor,
        systemUiOverlayStyle: SystemUiOverlayStyle(statusBarIconBrightness: appStore.isDarkMode ? Brightness.light : Brightness.light, statusBarColor: context.primaryColor),
        showBack: Navigator.canPop(context),
        backWidget: BackWidget(),
      ),
      body: Stack(
        children: [
          SnapHelperWidget<List<CategoryData>>(
            initialData: cachedCategoryList,
            future: future,
            loadingWidget: CategoryShimmer(),
            onSuccess: (snap) {
              if (snap.isEmpty) {
                return NoDataWidget(
                  title: language.noCategoryFound,
                  imageWidget: EmptyStateWidget(),
                );
              }

              return AnimatedScrollView(
                onSwipeRefresh: () async {
                  page = 1;

                  init();
                  setState(() {});

                  return await 2.seconds.delay;
                },
                physics: AlwaysScrollableScrollPhysics(),
                padding: EdgeInsets.all(16),
                listAnimationType: ListAnimationType.FadeIn,
                fadeInConfiguration: FadeInConfiguration(duration: 2.seconds),
                onNextPage: () {
                  if (!isLastPage) {
                    page++;
                    appStore.setLoading(true);

                    init();
                    setState(() {});
                  }
                },
                children: [
                  AnimatedWrap(
                    key: key,
                    runSpacing: 16,
                    spacing: 16,
                    itemCount: snap.length,
                    listAnimationType: ListAnimationType.FadeIn,
                    fadeInConfiguration: FadeInConfiguration(duration: 2.seconds),
                    scaleConfiguration: ScaleConfiguration(duration: 300.milliseconds, delay: 50.milliseconds),
                    itemBuilder: (_, index) {
                      CategoryData data = snap[index];

                      return GestureDetector(
                        onTap: () {
                          ViewAllServiceScreen(categoryId: data.id.validate(), categoryName: data.name, isFromCategory: true).launch(context);
                        },
                        child: CategoryWidget(categoryData: data, width: context.width() / 4 - 20),
                      );
                    },
                  ),
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
          ),
          Observer(builder: (BuildContext context) => LoaderWidget().visible(appStore.isLoading.validate())),
        ],
      ),
    );
  }
}
