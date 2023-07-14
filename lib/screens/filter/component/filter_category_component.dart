import 'package:client/component/selected_item_widget.dart';
import 'package:client/main.dart';
import 'package:client/model/category_model.dart';
import 'package:client/utils/constant.dart';
import 'package:flutter/material.dart';
import 'package:nb_utils/nb_utils.dart';

import '../../../component/empty_error_state_widget.dart';

class FilterCategoryComponent extends StatefulWidget {
  final List<CategoryData> catList;

  FilterCategoryComponent({required this.catList});

  @override
  State<FilterCategoryComponent> createState() => _FilterCategoryComponentState();
}

class _FilterCategoryComponentState extends State<FilterCategoryComponent> {
  int? isSelected;

  @override
  void initState() {
    super.initState();
    init();
  }

  void init() async {
    //
  }

  @override
  Widget build(BuildContext context) {
    if (widget.catList.isEmpty)
      return NoDataWidget(
        title: language.noCategoryFound,
        imageWidget: EmptyStateWidget(),
      );

    return AnimatedListView(
      itemCount: widget.catList.length,
      slideConfiguration: sliderConfigurationGlobal,
      listAnimationType: ListAnimationType.FadeIn,
      fadeInConfiguration: FadeInConfiguration(duration: 2.seconds),
      itemBuilder: (context, index) {
        CategoryData data = widget.catList[index];
        return Container(
          padding: EdgeInsets.all(16),
          child: Row(
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(data.name.validate(), style: boldTextStyle()),
                  4.height,
                  Text('${data.services} ${language.service}', style: secondaryTextStyle()),
                ],
              ).expand(),
              SelectedItemWidget(isSelected: data.isSelected),
            ],
          ),
        ).onTap(() {
          if (data.isSelected) {
            data.isSelected = false;
          } else {
            data.isSelected = true;
          }
          setState(() {});
        });
      },
    );
  }
}
