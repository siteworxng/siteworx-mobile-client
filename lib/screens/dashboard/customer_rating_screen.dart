import 'package:client/component/base_scaffold_widget.dart';
import 'package:client/main.dart';
import 'package:client/utils/constant.dart';
import 'package:client/utils/string_extensions.dart';
import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:nb_utils/nb_utils.dart';

import '../../component/add_review_dialog.dart';
import '../../component/cached_image_widget.dart';
import '../../component/disabled_rating_bar_widget.dart';
import '../../component/empty_error_state_widget.dart';
import '../../component/loader_widget.dart';
import '../../model/service_detail_response.dart';
import '../../network/rest_apis.dart';
import '../../utils/images.dart';
import '../review/shimmer/ratting_shimmer.dart';
import '../service/service_detail_screen.dart';

class CustomerRatingScreen extends StatefulWidget {
  @override
  State<CustomerRatingScreen> createState() => _CustomerRatingScreenState();
}

class _CustomerRatingScreenState extends State<CustomerRatingScreen> {
  ScrollController scrollController = ScrollController();

  Future<List<RatingData>>? future;

  bool isLastPage = false;

  @override
  void initState() {
    super.initState();
    init();
  }

  Future<void> init() async {
    future = customerReviews();
  }

  @override
  Widget build(BuildContext context) {
    return AppScaffold(
      appBarTitle: language.lblReviewsOnServices,
      child: Stack(
        children: [
          SnapHelperWidget<List<RatingData>>(
            future: future,
            loadingWidget: RattingShimmer(),
            onSuccess: (snap) {
              return AnimatedListView(
                padding: EdgeInsets.fromLTRB(8, 16, 8, 50),
                slideConfiguration: sliderConfigurationGlobal,
                listAnimationType: ListAnimationType.FadeIn,
                fadeInConfiguration: FadeInConfiguration(duration: 2.seconds),
                itemCount: snap.length,
                onSwipeRefresh: () async {
                  init();
                  setState(() {});

                  return await 2.seconds.delay;
                },
                itemBuilder: (context, index) {
                  RatingData data = snap[index];

                  return Container(
                    padding: EdgeInsets.all(16),
                    margin: EdgeInsets.all(8),
                    decoration: boxDecorationDefault(color: context.cardColor),
                    child: Column(
                      children: [
                        Container(
                          child: Column(
                            children: [
                              Row(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  CachedImageWidget(
                                    url: data.attachments.validate().isNotEmpty ? data.attachments!.first : '',
                                    height: 75,
                                    width: 75,
                                    fit: BoxFit.cover,
                                    radius: defaultRadius,
                                  ),
                                  16.width,
                                  Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Text('${data.serviceName.validate()}', style: boldTextStyle(size: LABEL_TEXT_SIZE), maxLines: 3, overflow: TextOverflow.ellipsis),
                                      TextButton(
                                        style: ButtonStyle(padding: MaterialStateProperty.all(EdgeInsets.all(0))),
                                        onPressed: () {
                                          ServiceDetailScreen(serviceId: data.serviceId.validate()).launch(context);
                                        },
                                        child: Text(language.viewDetail, style: secondaryTextStyle()),
                                      ),
                                    ],
                                  ).flexible()
                                ],
                              ),
                            ],
                          ),
                        ),
                        16.height,
                        Container(
                          decoration: boxDecorationDefault(color: context.scaffoldBackgroundColor),
                          padding: EdgeInsets.all(16),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                children: [
                                  Text(language.lblYourComment, style: boldTextStyle()).expand(),
                                  ic_edit_square.iconImage(size: 16).paddingAll(8).onTap(() async {
                                    Map<String, dynamic>? dialogData = await showInDialog(
                                      context,
                                      contentPadding: EdgeInsets.zero,
                                      builder: (p0) {
                                        return AddReviewDialog(
                                          customerReview: RatingData(
                                            bookingId: data.bookingId,
                                            createdAt: data.createdAt,
                                            customerId: data.customerId,
                                            id: data.id,
                                            profileImage: data.profileImage,
                                            rating: data.rating,
                                            review: data.review,
                                            serviceId: data.serviceId,
                                            customerName: data.customerName,
                                          ),
                                          isCustomerRating: true,
                                        );
                                      },
                                    );

                                    if (dialogData != null) {
                                      data.rating = dialogData['rating'];
                                      data.review = dialogData['review'];

                                      setState(() {});

                                      LiveStream().emit(LIVESTREAM_UPDATE_DASHBOARD);
                                    }
                                  }),
                                  ic_delete.iconImage(size: 16).paddingAll(8).onTap(() {
                                    showConfirmDialogCustom(
                                      context,
                                      title: language.lblDeleteReview,
                                      subTitle: language.lblConfirmReviewSubTitle,
                                      positiveText: language.lblYes,
                                      negativeText: language.lblNo,
                                      dialogType: DialogType.DELETE,
                                      onAccept: (p0) async {
                                        appStore.setLoading(true);

                                        if (getStringAsync(USER_EMAIL) != DEFAULT_EMAIL) {
                                          await deleteReview(id: data.id.validate()).then((value) {
                                            appStore.setLoading(false);
                                            toast(value.message);
                                            init();
                                          }).catchError((e) {
                                            appStore.setLoading(false);
                                            toast(e.toString(), print: true);
                                          });
                                        } else {
                                          toast(language.lblUnAuthorized);
                                        }

                                        setState(() {});
                                      },
                                    );
                                    return;
                                  }),
                                ],
                              ),
                              Divider(color: context.dividerColor),
                              DisabledRatingBarWidget(rating: data.rating.validate().toDouble()),
                              8.height,
                              Text(data.review.validate(), style: secondaryTextStyle()),
                            ],
                          ),
                        )
                      ],
                    ),
                  );
                },
                emptyWidget: NoDataWidget(
                  title: language.lblNoRateYet,
                  image: no_rating_bar,
                  subTitle: language.customerRatingMessage,
                ),
              );
            },
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
          ),
          Observer(builder: (_) => LoaderWidget().visible(appStore.isLoading)),
        ],
      ),
    );
  }
}
