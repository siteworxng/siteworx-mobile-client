import 'package:client/utils/common.dart';
import 'package:flutter/material.dart';
import 'package:nb_utils/nb_utils.dart';

class DisabledRatingBarWidget extends StatelessWidget {
  final num rating;
  final double? size;

  DisabledRatingBarWidget({required this.rating, this.size});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        RatingBarWidget(
          onRatingChanged: null,
          itemCount: 5,
          size: size ?? 18,
          disable: true,
          rating: rating.validate().toDouble(),
          // activeColor: ratingBarColor,
          activeColor: getRatingBarColor(rating.toInt()),
        ),
      ],
    );
  }
}
