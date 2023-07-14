import 'package:client/component/cached_image_widget.dart';
import 'package:client/component/price_widget.dart';
import 'package:client/model/get_my_post_job_list_response.dart';
import 'package:client/screens/jobRequest/my_post_detail_screen.dart';
import 'package:client/utils/common.dart';
import 'package:client/utils/constant.dart';
import 'package:client/utils/string_extensions.dart';
import 'package:flutter/material.dart';
import 'package:nb_utils/nb_utils.dart';

import '../../../main.dart';
import '../../../network/rest_apis.dart';
import '../../../utils/images.dart';

class MyPostRequestItemComponent extends StatefulWidget {
  final PostJobData data;
  final Function(bool) callback;

  MyPostRequestItemComponent({required this.data, required this.callback});

  @override
  _MyPostRequestItemComponentState createState() => _MyPostRequestItemComponentState();
}

class _MyPostRequestItemComponentState extends State<MyPostRequestItemComponent> {
  @override
  void initState() {
    super.initState();
    init();
  }

  void init() async {
    //
  }

  void deletePost(num id) {
    widget.callback.call(true);

    deletePostRequest(id: id.validate()).then((value) {
      appStore.setLoading(false);
      toast(value.message.validate());

      widget.callback.call(false);
    }).catchError((e) {
      appStore.setLoading(false);
      toast(e.toString(), print: true);
    });
  }

  @override
  void setState(fn) {
    if (mounted) super.setState(fn);
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        MyPostDetailScreen(
          postRequestId: widget.data.id.validate().toInt(),
          callback: () {
            widget.callback.call(true);
          },
        ).launch(context);
      },
      child: Container(
        decoration: boxDecorationWithRoundedCorners(borderRadius: radius(), backgroundColor: context.cardColor),
        width: context.width(),
        margin: EdgeInsets.only(top: 12, bottom: 8, left: 16, right: 16),
        padding: EdgeInsets.only(top: 12, bottom: 12, left: 16, right: 16),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            CachedImageWidget(
              url: (widget.data.service.validate().isNotEmpty && widget.data.service.validate().first.attachments.validate().isNotEmpty) ? widget.data.service.validate().first.attachments.validate().first.validate() : "",
              fit: BoxFit.cover,
              height: 60,
              width: 60,
              circle: false,
            ).cornerRadiusWithClipRRect(defaultRadius),
            16.width,
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Text(widget.data.title.validate(), style: boldTextStyle(), maxLines: 2, overflow: TextOverflow.ellipsis).expand(),
                    Container(
                      padding: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                      decoration: BoxDecoration(
                        color: widget.data.status.validate().getJobStatusColor.withOpacity(0.1),
                        borderRadius: radius(8),
                      ),
                      child: Text(
                        widget.data.status.validate().toPostJobStatus(),
                        style: boldTextStyle(color: widget.data.status.validate().getJobStatusColor, size: 12),
                      ),
                    ),
                  ],
                ),
                4.height,
                PriceWidget(
                  price: widget.data.status.validate() == JOB_REQUEST_STATUS_ASSIGNED ? widget.data.jobPrice.validate() : widget.data.price.validate(),
                  isHourlyService: false,
                  color: textPrimaryColorGlobal,
                  isFreeService: false,
                  size: 14,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      formatDate(widget.data.createdAt.validate(), format: DATE_FORMAT_2),
                      style: secondaryTextStyle(),
                    ),
                    IconButton(
                      icon: ic_delete.iconImage(size: 16),
                      visualDensity: VisualDensity.compact,
                      onPressed: () {
                        showConfirmDialogCustom(
                          context,
                          dialogType: DialogType.DELETE,
                          title: '${language.deleteMessage}?',
                          positiveText: language.lblYes,
                          negativeText: language.lblNo,
                          onAccept: (p0) {
                            ifNotTester(() {
                              deletePost(widget.data.id.validate());
                            });
                          },
                        );
                      },
                    ),
                  ],
                ),
              ],
            ).expand(),
          ],
        ),
      ),
    );
  }
}
