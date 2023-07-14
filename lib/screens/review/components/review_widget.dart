import 'package:client/component/image_border_component.dart';
import 'package:client/model/service_detail_response.dart';
import 'package:client/utils/common.dart';
import 'package:client/utils/constant.dart';
import 'package:flutter/material.dart';
import 'package:nb_utils/nb_utils.dart';

import '../../../utils/images.dart';

class ReviewWidget extends StatelessWidget {
  final RatingData data;
  final bool isCustomer;

  ReviewWidget({required this.data, this.isCustomer = false});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(bottom: 8),
      padding: EdgeInsets.all(16),
      width: context.width(),
      decoration: boxDecorationDefault(color: context.cardColor),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              ImageBorder(
                src: isCustomer ? data.customerProfileImage.validate() : data.profileImage.validate(),
                height: 50,
              ),
              16.width,
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(data.customerName.validate(), style: boldTextStyle(), maxLines: 1, overflow: TextOverflow.ellipsis).flexible(),
                      Row(
                        children: [
                          Image.asset(ic_star_fill, height: 14, fit: BoxFit.fitWidth, color: getRatingBarColor(data.rating.validate().toInt())),
                          4.width,
                          Text(data.rating.validate().toStringAsFixed(1).toString(), style: boldTextStyle(color: getRatingBarColor(data.rating.validate().toInt()), size: 14)),
                        ],
                      ),
                    ],
                  ),
                  data.createdAt.validate().isNotEmpty ? Text(formatDate(data.createdAt.validate(), format: DATE_FORMAT_4), style: secondaryTextStyle()) : SizedBox(),
                  if (data.review.validate().isNotEmpty) ReadMoreText(data.review.validate(), style: secondaryTextStyle(), trimLength: 100).paddingTop(8),
                ],
              ).flexible(),
            ],
          ),
        ],
      ),
    );
  }
}
