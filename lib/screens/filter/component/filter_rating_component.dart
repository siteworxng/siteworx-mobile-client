import 'package:client/component/disabled_rating_bar_widget.dart';
import 'package:client/component/selected_item_widget.dart';
import 'package:flutter/material.dart';
import 'package:nb_utils/nb_utils.dart';

class FilterRatingComponent extends StatefulWidget {
  @override
  State<FilterRatingComponent> createState() => _FilterRatingComponentState();
}

class _FilterRatingComponentState extends State<FilterRatingComponent> {
  List<double> selectedRatingList = [];

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(16),
      width: context.width(),
      decoration: boxDecorationDefault(color: context.cardColor),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ListView.builder(
            shrinkWrap: true,
            itemCount: 5,
            reverse: true,
            itemBuilder: (context, index) {
              bool isSelected = selectedRatingList.contains(index + 1);
              return Padding(
                padding: EdgeInsets.fromLTRB(0, 16, 0, 16),
                child: Row(
                  children: [
                    SelectedItemWidget(isSelected: isSelected),
                    8.width,
                    DisabledRatingBarWidget(rating: (index + 1).toDouble()).expand(),
                    Text('${(index + 1).toDouble()}', style: primaryTextStyle(size: 12)),
                  ],
                ),
              ).onTap(() {
                double selectedIndex = index + 1;

                if (!selectedRatingList.contains(selectedIndex)) {
                  selectedRatingList.add(selectedIndex);
                } else {
                  selectedRatingList.remove(selectedIndex);
                }

                setState(() {});
              });
            },
          )
        ],
      ),
    );
  }
}
