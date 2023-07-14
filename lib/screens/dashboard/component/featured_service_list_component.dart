import 'package:client/component/view_all_label_component.dart';
import 'package:client/main.dart';
import 'package:client/model/service_data_model.dart';
import 'package:client/screens/service/component/service_component.dart';
import 'package:flutter/material.dart';
import 'package:nb_utils/nb_utils.dart';

import '../../../component/empty_error_state_widget.dart';
import '../../service/view_all_service_screen.dart';

class FeaturedServiceListComponent extends StatelessWidget {
  final List<ServiceData> serviceList;

  FeaturedServiceListComponent({required this.serviceList});

  @override
  Widget build(BuildContext context) {
    if (serviceList.isEmpty) return Offstage();

    return Container(
      padding: EdgeInsets.only(bottom: 16),
      width: context.width(),
      decoration: BoxDecoration(
        color: appStore.isDarkMode ? context.cardColor : context.primaryColor.withOpacity(0.1),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          16.height,
          ViewAllLabel(
            label: language.lblFeatured,
            list: serviceList,
            onTap: () {
              ViewAllServiceScreen(isFeatured: "1").launch(context);
            },
          ).paddingSymmetric(horizontal: 16),
          if (serviceList.isNotEmpty)
            HorizontalList(
              itemCount: serviceList.length,
              spacing: 16,
              padding: EdgeInsets.symmetric(horizontal: 16, vertical: 16),
              itemBuilder: (context, index) => ServiceComponent(serviceData: serviceList[index], width: 280, isBorderEnabled: true),
            )
          else
            Container(
              padding: EdgeInsets.symmetric(horizontal: 16, vertical: 32),
              child: NoDataWidget(
                title: language.lblNoServicesFound,
                imageWidget: EmptyStateWidget(),
              ),
            ).center(),
        ],
      ),
    );
  }
}
