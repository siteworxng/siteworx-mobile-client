import 'package:client/component/back_widget.dart';
import 'package:client/component/cached_image_widget.dart';
import 'package:client/component/loader_widget.dart';
import 'package:client/main.dart';
import 'package:client/model/service_data_model.dart';
import 'package:client/network/rest_apis.dart';
import 'package:client/screens/filter/filter_screen.dart';
import 'package:client/screens/service/component/service_component.dart';
import 'package:client/screens/service/component/subcategory_component.dart';
import 'package:client/screens/service/shimmer/service_shimmer.dart';
import 'package:client/utils/common.dart';
import 'package:client/utils/constant.dart';
import 'package:client/utils/images.dart';
import 'package:client/utils/string_extensions.dart';
import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:nb_utils/nb_utils.dart';

import '../../component/empty_error_state_widget.dart';

@Deprecated('Do not use this file. It will be deleted in the next update.')
class SearchListScreen extends StatefulWidget {
  final int? categoryId;
  final String? categoryName;
  final String isFeatured;
  final bool isFromProvider;
  final bool isFromCategory;
  final bool isFromSearch;
  final int? providerId;

  SearchListScreen({this.categoryId, this.categoryName = '', this.isFromSearch = false, this.isFeatured = '', this.isFromProvider = true, this.isFromCategory = false, this.providerId});

  @override
  SearchListScreenState createState() => SearchListScreenState();
}

class SearchListScreenState extends State<SearchListScreen> {
  FocusNode myFocusNode = FocusNode();

  TextEditingController searchCont = TextEditingController();

  int page = 1;
  List<ServiceData> serviceList = [];

  bool isEnabled = false;
  bool isLastPage = false;
  bool fabIsVisible = true;
  bool isSubCategoryLoaded = false;
  bool isApiCalled = false;

  bool hasError = false;
  String errorMessage = '';

  int? subCategory;

  @override
  void initState() {
    super.initState();

    LiveStream().on(LIVESTREAM_UPDATE_SERVICE_LIST, (p0) {
      subCategory = p0 as int;
      page = 1;

      setState(() {});
      fetchAllServiceData();
    });
    afterBuildCreated(() {
      init();
    });
  }

  void init() async {
    if (filterStore.search.isNotEmpty) {
      filterStore.setSearch('');
    }
    fetchAllServiceData();
  }

  String get setSearchString {
    if (!widget.categoryName.isEmptyOrNull) {
      return widget.categoryName!;
    } else if (widget.isFeatured == "1") {
      return language.lblFeatured;
    } else {
      return language.allServices;
    }
  }

  Future<void> fetchAllServiceData() async {
    appStore.setLoading(true);

    if (appStore.isCurrentLocation) {
      filterStore.setLatitude(getDoubleAsync(LATITUDE).toString());
      filterStore.setLongitude(getDoubleAsync(LONGITUDE).toString());
    } else {
      filterStore.setLatitude("");
      filterStore.setLongitude("");
    }

    String categoryId() {
      if (filterStore.categoryId.isNotEmpty) {
        return filterStore.categoryId.join(",");
      } else {
        if (widget.categoryId != null) {
          return widget.categoryId.toString();
        } else {
          return "";
        }
      }
    }

    await getSearchListServices(
      categoryId: categoryId(),
      providerId: widget.providerId != null ? widget.providerId.toString() : filterStore.providerId.join(","),
      handymanId: filterStore.handymanId.join(","),
      isPriceMin: filterStore.isPriceMin,
      isPriceMax: filterStore.isPriceMax,
      search: filterStore.search,
      latitude: filterStore.latitude,
      longitude: filterStore.longitude,
      isFeatured: widget.isFeatured,
      page: page,
      subCategory: subCategory.toString(),
    ).then((value) async {
      appStore.setLoading(false);

      if (page == 1) {
        serviceList.clear();
      }
      isLastPage = value.serviceList.validate().length != PER_PAGE_ITEM;
      serviceList.addAll(value.serviceList.validate());

      if (widget.isFromSearch && !isApiCalled && serviceList.isNotEmpty) {
        await 1.seconds.delay;
        myFocusNode.requestFocus();
      }
      isApiCalled = true;

      hasError = false;
      errorMessage = '';
      setState(() {});
    }).catchError((e) {
      isApiCalled = true;
      serviceList.clear();
      hasError = true;
      errorMessage = e.toString();
      setState(() {});

      appStore.setLoading(false);
    });
  }

  @override
  void dispose() {
    filterStore.clearFilters();
    myFocusNode.dispose();
    LiveStream().dispose(LIVESTREAM_UPDATE_SERVICE_LIST);
    filterStore.setSelectedSubCategory(catId: 0);

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
        setSearchString,
        textColor: Colors.white,
        color: context.primaryColor,
        textSize: APP_BAR_TEXT_SIZE,
        backWidget: BackWidget(),
        actions: [
          Observer(
            builder: (_) => IconButton(
              icon: ic_active_location.iconImage(size: 24, color: appStore.isCurrentLocation ? Colors.lightGreen : Colors.white),
              visualDensity: VisualDensity.compact,
              onPressed: () {
                locationWiseService(context, () {
                  page = 1;
                  fetchAllServiceData();
                });
              },
            ),
          ).paddingRight(16),
        ],
      ),
      body: RefreshIndicator(
        onRefresh: () async {
          page = 1;
          return await fetchAllServiceData();
        },
        child: Observer(
          builder: (context) {
            return Stack(
              children: [
                AnimatedScrollView(
                  physics: AlwaysScrollableScrollPhysics(),
                  listAnimationType: ListAnimationType.FadeIn,
                  fadeInConfiguration: FadeInConfiguration(duration: 2.seconds),
                  keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  onNextPage: () {
                    if (!isLastPage) {
                      page++;
                      fetchAllServiceData();
                    }
                  },
                  children: [
                    if (widget.categoryId != null)
                      SubCategoryComponent(
                        catId: widget.categoryId != null ? widget.categoryId : null,
                        onDataLoaded: (bool val) async {
                          //appStore.setLoading(false);
                        },
                      ),
                    16.height,
                    if (serviceList.isNotEmpty)
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(language.service, style: boldTextStyle(size: LABEL_TEXT_SIZE)).paddingSymmetric(horizontal: 16),
                          AnimatedWrap(
                            itemCount: serviceList.length,
                            listAnimationType: ListAnimationType.FadeIn,
                            fadeInConfiguration: FadeInConfiguration(duration: 2.seconds),
                            itemBuilder: (_, index) {
                              return ServiceComponent(serviceData: serviceList[index], width: context.width() / 2 - 26).paddingAll(8);
                            },
                          ).paddingAll(8),
                        ],
                      ),
                  ],
                ).paddingTop(70),
                NoDataWidget(
                  imageSize: Size(150, 150),
                  title: language.lblNoServicesFound,
                  imageWidget: EmptyStateWidget(),
                ).center().paddingTop(!appStore.isLoading ? 180 : 26).visible(isApiCalled && serviceList.isEmpty && !appStore.isLoading && !hasError),
                ServiceShimmer().visible(appStore.isLoading && page == 1 && !isApiCalled),
                LoaderWidget().visible(appStore.isLoading && page != 1),
                NoDataWidget(
                  title: errorMessage,
                  retryText: language.reload,
                  onRetry: () {
                    page = 1;
                    init();
                    setState(() {});
                  },
                ).visible(hasError && !appStore.isLoading),
                Container(
                  padding: EdgeInsets.all(16),
                  child: Row(
                    children: [
                      AppTextField(
                        textFieldType: TextFieldType.OTHER,
                        focus: myFocusNode,
                        controller: searchCont,
                        suffix: CloseButton(
                          onPressed: () {
                            page = 1;
                            searchCont.clear();
                            filterStore.setSearch('');
                            fetchAllServiceData();
                          },
                        ).visible(searchCont.text.isNotEmpty),
                        onFieldSubmitted: (s) {
                          page = 1;

                          filterStore.setSearch(s);
                          fetchAllServiceData();
                        },
                        decoration: inputDecoration(context).copyWith(
                          hintText: "${language.lblSearchFor} $setSearchString",
                          prefixIcon: ic_search.iconImage(size: 10).paddingAll(14),
                          hintStyle: secondaryTextStyle(),
                        ),
                      ).expand(),
                      16.width,
                      Container(
                        padding: EdgeInsets.all(10),
                        decoration: boxDecorationDefault(color: context.primaryColor),
                        child: CachedImageWidget(
                          url: ic_filter,
                          height: 26,
                          width: 26,
                          color: Colors.white,
                        ),
                      ).onTap(() {
                        hideKeyboard(context);

                        FilterScreen(isFromProvider: widget.isFromProvider, isFromCategory: widget.isFromCategory).launch(context).then((value) {
                          if (value != null) {
                            page = 1;
                            fetchAllServiceData();
                          }
                        });
                      }, borderRadius: radius())
                    ],
                  ),
                ),
              ],
            );
          },
        ),
      ),
    );
  }
}
