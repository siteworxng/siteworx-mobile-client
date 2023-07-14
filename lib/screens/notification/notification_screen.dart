import 'package:client/component/base_scaffold_widget.dart';
import 'package:client/component/loader_widget.dart';
import 'package:client/main.dart';
import 'package:client/model/notification_model.dart';
import 'package:client/network/rest_apis.dart';
import 'package:client/screens/booking/booking_detail_screen.dart';
import 'package:client/screens/notification/components/notification_widget.dart';
import 'package:client/utils/constant.dart';
import 'package:client/utils/model_keys.dart';
import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:nb_utils/nb_utils.dart';

import '../../component/empty_error_state_widget.dart';

class NotificationScreen extends StatefulWidget {
  @override
  _NotificationScreenState createState() => _NotificationScreenState();
}

class _NotificationScreenState extends State<NotificationScreen> {
  Future<List<NotificationData>>? future;

  @override
  void initState() {
    super.initState();
    init();
  }

  Future<void> init({Map? req}) async {
    future = getNotification(request: req);
  }

  Future<void> readNotification({String? id}) async {
    Map request = {CommonKeys.bookingId: id};

    getBookingDetail(request).then((value) {}).catchError(onError);
  }

  @override
  void setState(fn) {
    if (mounted) super.setState(fn);
  }

  @override
  Widget build(BuildContext context) {
    return AppScaffold(
      appBarTitle: language.lblNotification,
      actions: [
        IconButton(
          icon: Icon(Icons.clear_all_rounded, color: Colors.white),
          onPressed: () async {
            appStore.setLoading(true);

            init(req: {NotificationKey.type: MARK_AS_READ});

            setState(() {});
          },
        ),
      ],
      child: Stack(
        alignment: Alignment.center,
        children: [
          SnapHelperWidget<List<NotificationData>>(
            future: future,
            loadingWidget: LoaderWidget(),
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
            onSuccess: (list) {
              return AnimatedListView(
                shrinkWrap: true,
                itemCount: list.length,
                slideConfiguration: sliderConfigurationGlobal,
                listAnimationType: ListAnimationType.FadeIn,
                fadeInConfiguration: FadeInConfiguration(duration: 2.seconds),
                emptyWidget: NoDataWidget(
                  title: language.noNotifications,
                  subTitle: language.noNotificationsSubTitle,
                  imageWidget: EmptyStateWidget(),
                ),
                itemBuilder: (context, index) {
                  NotificationData data = list[index];

                  return GestureDetector(
                    onTap: () async {
                      if (data.data!.notificationType.validate() == NOTIFICATION_TYPE_BOOKING) {
                        readNotification(id: data.data!.id.toString());
                        await BookingDetailScreen(bookingId: data.data!.id.validate()).launch(context);

                        init();
                        setState(() {});
                      } else if (data.data!.notificationType.validate() == NOTIFICATION_TYPE_POST_JOB) {
                        //
                      } else {
                        //
                      }
                    },
                    child: NotificationWidget(data: data),
                  );
                },
              );
            },
          ),
          Observer(builder: (context) => LoaderWidget().center().visible(appStore.isLoading)),
        ],
      ),
    );
  }
}
