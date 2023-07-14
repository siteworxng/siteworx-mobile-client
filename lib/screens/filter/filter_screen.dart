import 'package:client/component/base_scaffold_widget.dart';
import 'package:client/main.dart';
import 'package:client/model/category_model.dart';
import 'package:client/model/user_data_model.dart';
import 'package:client/network/rest_apis.dart';
import 'package:client/screens/filter/component/filter_category_component.dart';
import 'package:client/screens/filter/component/filter_price_component.dart';
import 'package:client/screens/filter/component/filter_provider_component.dart';
import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:nb_utils/nb_utils.dart';

import '../../utils/constant.dart';

class FilterScreen extends StatefulWidget {
  final bool isFromProvider;
  final bool isFromCategory;

  FilterScreen({this.isFromProvider = true, this.isFromCategory = false});

  @override
  _FilterScreenState createState() => _FilterScreenState();
}

class _FilterScreenState extends State<FilterScreen> {
  int isSelected = 0;

  List<CategoryData> catList = [];
  List<UserData> providerList = [];

  @override
  void initState() {
    super.initState();
    appStore.setLoading(true);
    afterBuildCreated(() => init());
  }

  void init() async {
    //Get all Provider List
    if (widget.isFromProvider) {
      await getProvider().then((value) {
        appStore.setLoading(false);

        providerList = value.providerList.validate();
        providerList.forEach((element) {
          if (filterStore.providerId.contains(element.id)) {
            element.isSelected = true;
          }
        });
        setState(() {});
      }).catchError((e) {
        appStore.setLoading(false);

        toast(e.toString());
      });
    }

    // Get all Category List
    if (!widget.isFromCategory) {
      await getCategoryList(CATEGORY_LIST_ALL).then((value) {
        catList = value.categoryList.validate();
        catList.forEach((element) {
          if (filterStore.categoryId.contains(element.id)) {
            element.isSelected = true;
          }
        });
        setState(() {});
      }).catchError((e) {
        toast(e.toString());
      });
    }

    appStore.setLoading(false);
  }

  @override
  void setState(fn) {
    if (mounted) super.setState(fn);
  }

  Widget buildItem({required String name, required bool isSelected}) {
    return Container(
      padding: EdgeInsets.fromLTRB(24, 20, 20, 20),
      width: context.width(),
      decoration: boxDecorationDefault(
        color: isSelected ? context.cardColor : context.scaffoldBackgroundColor,
        borderRadius: radius(0),
      ),
      child: Text("$name", style: boldTextStyle(size: 12)),
    );
  }

  void clearFilter() {
    filterStore.clearFilters();
    finish(context, true);
  }

  @override
  Widget build(BuildContext context) {
    return AppScaffold(
      appBarTitle: language.lblFilterBy,
      scaffoldBackgroundColor: context.cardColor,
      child: Column(
        children: [
          Row(
            children: [
              Container(
                decoration: boxDecorationDefault(color: context.scaffoldBackgroundColor, borderRadius: radius(0)),
                child: Column(
                  children: [
                    if (widget.isFromProvider)
                      buildItem(isSelected: isSelected == 0, name: language.textProvider).onTap(() {
                        if (!appStore.isLoading) {
                          isSelected = 0;
                          setState(() {});
                        }
                      }),
                    if (!widget.isFromCategory)
                      buildItem(isSelected: isSelected == ((widget.isFromProvider) ? 1 : 0), name: language.lblCategory).onTap(() {
                        if (!appStore.isLoading) {
                          isSelected = (widget.isFromProvider) ? 1 : 0;
                          setState(() {});
                        }
                      }),
                    buildItem(isSelected: isSelected == ((widget.isFromProvider) ? 2 : 1), name: language.lblPrice).onTap(() {
                      if (!appStore.isLoading) {
                        isSelected = (widget.isFromProvider) ? 2 : 1;
                        setState(() {});
                      }
                    }),
                  ],
                ),
              ).expand(flex: 2),
              [
                if (appStore.isLoading) Offstage(),
                FilterProviderComponent(providerList: providerList),
                FilterCategoryComponent(catList: catList),
                FilterPriceComponent(),
              ][isSelected]
                  .flexible(flex: 5),
            ],
          ).expand(),
          Observer(
            builder: (_) => Container(
              decoration: boxDecorationDefault(color: context.scaffoldBackgroundColor),
              width: context.width(),
              padding: EdgeInsets.all(16),
              child: Row(
                children: [
                  if (filterStore.providerId.validate().isNotEmpty || filterStore.categoryId.validate().isNotEmpty || (filterStore.isPriceMin.validate().isNotEmpty && filterStore.isPriceMax.validate().isNotEmpty))
                    AppButton(
                      text: language.lblClearFilter,
                      textColor: context.primaryColor,
                      shapeBorder: RoundedRectangleBorder(side: BorderSide(color: context.primaryColor), borderRadius: radius()),
                      onTap: () {
                        clearFilter();
                      },
                    ).expand(),
                  16.width,
                  AppButton(
                    text: language.lblApply,
                    textColor: Colors.white,
                    color: context.primaryColor,
                    onTap: () {
                      filterStore.categoryId = [];

                      catList.forEach((element) {
                        if (element.isSelected) {
                          filterStore.addToCategoryIdList(prodId: element.id.validate());
                        }
                      });

                      filterStore.providerId = [];

                      providerList.forEach((element) {
                        if (element.isSelected) {
                          filterStore.addToProviderList(prodId: element.id.validate());
                        }
                      });

                      finish(context, true);
                    },
                  ).expand(),
                ],
              ),
            ).visible(!appStore.isLoading),
          ),
        ],
      ),
    );
  }
}
