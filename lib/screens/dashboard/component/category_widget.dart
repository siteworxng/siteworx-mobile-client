import 'package:client/component/cached_image_widget.dart';
import 'package:client/main.dart';
import 'package:client/model/category_model.dart';
import 'package:client/utils/constant.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:nb_utils/nb_utils.dart';

class CategoryWidget extends StatelessWidget {
  final CategoryData categoryData;
  final double? width;
  final bool? isFromCategory;

  CategoryWidget({required this.categoryData, this.width, this.isFromCategory});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: width ?? context.width() / 4 - 24,
      child: Column(
        children: [
          categoryData.categoryImage.validate().endsWith('.svg')
              ? Container(
                  width: CATEGORY_ICON_SIZE,
                  height: CATEGORY_ICON_SIZE,
                  padding: EdgeInsets.all(8),
                  decoration: BoxDecoration(color: context.cardColor, shape: BoxShape.circle),
                  child: SvgPicture.network(
                    categoryData.categoryImage.validate(),
                    height: CATEGORY_ICON_SIZE,
                    width: CATEGORY_ICON_SIZE,
                    color: appStore.isDarkMode ? Colors.white : categoryData.color.validate(value: '000').toColor(),
                    placeholderBuilder: (context) => PlaceHolderWidget(
                      height: CATEGORY_ICON_SIZE,
                      width: CATEGORY_ICON_SIZE,
                      color: transparentColor,
                    ),
                  ).paddingAll(10),
                )
              : Container(
                  padding: EdgeInsets.all(14),
                  decoration: BoxDecoration(color: appStore.isDarkMode ? Colors.white24 : context.cardColor, shape: BoxShape.circle),
                  child: CachedImageWidget(
                    url: categoryData.categoryImage.validate(),
                    fit: BoxFit.cover,
                    width: 40,
                    height: 40,
                    circle: true,
                    placeHolderImage: '',
                  ),
                ),
          4.height,
          Marquee(
            directionMarguee: DirectionMarguee.oneDirection,
            child: Text(
              '${categoryData.name.validate()}',
              style: primaryTextStyle(size: 12),
            ),
          ),
        ],
      ),
    );
  }
}
