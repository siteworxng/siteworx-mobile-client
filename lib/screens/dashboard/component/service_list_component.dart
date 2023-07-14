import 'package:client/component/view_all_label_component.dart';
import 'package:client/main.dart';
import 'package:client/model/service_data_model.dart';
import 'package:client/screens/service/component/service_component.dart';
import 'package:flutter/material.dart';
import 'package:nb_utils/nb_utils.dart';

import '../../../component/empty_error_state_widget.dart';
import '../../service/view_all_service_screen.dart';

class ServiceListComponent extends StatelessWidget {
  final List<ServiceData> serviceList;

  ServiceListComponent({required this.serviceList});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        16.height,
        ViewAllLabel(
          label: language.service,
          list: serviceList,
          onTap: () {
            ViewAllServiceScreen().launch(context);
          },
        ).paddingSymmetric(horizontal: 16),
        8.height,
        serviceList.isNotEmpty
            ? Wrap(
                spacing: 16,
                runSpacing: 16,
                children: List.generate(serviceList.length, (index) {
                  return ServiceComponent(serviceData: serviceList[index], width: context.width() / 2 - 26);
                }),
              ).paddingSymmetric(horizontal: 16, vertical: 8)
            : Container(
                padding: EdgeInsets.symmetric(horizontal: 16, vertical: 32),
                child: NoDataWidget(
                  title: language.lblNoServicesFound,
                  imageWidget: EmptyStateWidget(),
                ),
              ).center(),
      ],
    );
  }
}
