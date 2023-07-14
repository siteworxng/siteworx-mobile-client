import 'package:client/component/disabled_rating_bar_widget.dart';
import 'package:client/component/shimmer_widget.dart';
import 'package:client/main.dart';
import 'package:flutter/material.dart';
import 'package:nb_utils/nb_utils.dart';

class BookingDetailShimmer extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ShimmerWidget(height: 100, width: context.width(), backgroundColor: context.cardColor.withOpacity(0.7)),
          Padding(
            padding: EdgeInsets.symmetric(vertical: 16, horizontal: 16),
            child: Column(
              children: [
                /// Booking Id Detail
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    ShimmerWidget(height: 10, width: context.width() * 0.25),
                    ShimmerWidget(height: 10, width: context.width() * 0.12),
                  ],
                ),
                Divider(height: 32, color: context.dividerColor),

                /// Service Detail Widget
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        ShimmerWidget(height: 10, width: context.width() * 0.45),
                        12.height,
                        Row(
                          children: [
                            ShimmerWidget(height: 10, width: context.width() * 0.15),
                            ShimmerWidget(height: 10, width: context.width() * 0.12),
                          ],
                        ),
                        8.height,
                        Row(
                          children: [
                            ShimmerWidget(height: 10, width: context.width() * 0.15),
                            ShimmerWidget(height: 10, width: context.width() * 0.12),
                          ],
                        ),
                      ],
                    ).expand(),
                    Container(
                      decoration: BoxDecoration(borderRadius: radius()),
                      child: ShimmerWidget(height: 90, width: 90),
                    ),
                  ],
                ),
                16.height,
                Divider(height: 0, color: context.dividerColor),

                /// My Service List
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    24.height,
                    ShimmerWidget(height: 10, width: context.width() * 0.25),
                    8.height,
                    AnimatedListView(
                      itemCount: 2,
                      shrinkWrap: true,
                      listAnimationType: ListAnimationType.None,
                      itemBuilder: (_, i) {
                        return Container(
                          width: context.width(),
                          margin: EdgeInsets.symmetric(vertical: 8),
                          padding: EdgeInsets.all(8),
                          decoration: boxDecorationWithRoundedCorners(backgroundColor: context.cardColor, borderRadius: BorderRadius.all(Radius.circular(defaultRadius))),
                          child: Row(
                            children: [
                              Container(
                                decoration: BoxDecoration(borderRadius: radius()),
                                child: ShimmerWidget(height: 50, width: 50),
                              ),
                              16.width,
                              ShimmerWidget(height: 10, width: context.width() * 0.12).expand(),
                            ],
                          ),
                        );
                      },
                    ),
                  ],
                ),

                /// Package List
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    16.height,
                    ShimmerWidget(height: 10, width: context.width() * 0.25),
                    ListView.builder(
                      shrinkWrap: true,
                      physics: NeverScrollableScrollPhysics(),
                      itemCount: 2,
                      padding: EdgeInsets.symmetric(vertical: 8),
                      itemBuilder: (_, i) {
                        return Container(
                          padding: EdgeInsets.all(8),
                          margin: EdgeInsets.symmetric(vertical: 8),
                          decoration: boxDecorationWithRoundedCorners(
                            borderRadius: radius(),
                            backgroundColor: context.cardColor,
                            border: appStore.isDarkMode ? Border.all(color: context.dividerColor) : null,
                          ),
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Container(
                                decoration: BoxDecoration(borderRadius: radius()),
                                child: ShimmerWidget(height: 70, width: 70),
                              ),
                              16.width,
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  4.height,
                                  ShimmerWidget(height: 10, width: context.width() * 0.35),
                                  4.height,
                                  ShimmerWidget(height: 10, width: context.width() * 0.12),
                                  4.height,
                                  ShimmerWidget(height: 10, width: context.width() * 0.12),
                                ],
                              ).flexible()
                            ],
                          ),
                        );
                      },
                    )
                  ],
                ),

                /// Description Widget
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    16.height,
                    ShimmerWidget(height: 10, width: context.width() * 0.25),
                    8.height,
                    ShimmerWidget(height: 10, width: context.width()),
                    4.height,
                    ShimmerWidget(height: 10, width: context.width()),
                  ],
                ),

                /// Service Proof List
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    16.height,
                    ShimmerWidget(height: 10, width: context.width() * 0.25),
                    16.height,
                    Container(
                      decoration: boxDecorationWithRoundedCorners(
                        backgroundColor: context.cardColor,
                        borderRadius: BorderRadius.all(Radius.circular(16)),
                      ),
                      child: ListView.separated(
                        itemCount: 2,
                        shrinkWrap: true,
                        physics: NeverScrollableScrollPhysics(),
                        separatorBuilder: (BuildContext context, int index) {
                          return Divider(height: 0, color: context.dividerColor);
                        },
                        itemBuilder: (context, index) {
                          return Container(
                            padding: EdgeInsets.all(16),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                ShimmerWidget(height: 10, width: context.width()),
                                8.height,
                                ShimmerWidget(height: 10, width: context.width()),
                                16.height,
                                HorizontalList(
                                  crossAxisAlignment: WrapCrossAlignment.start,
                                  itemCount: 4,
                                  padding: EdgeInsets.zero,
                                  itemBuilder: (_, i) {
                                    return Container(
                                      decoration: boxDecorationRoundedWithShadow(10),
                                      clipBehavior: Clip.antiAliasWithSaveLayer,
                                      child: ShimmerWidget(height: 50, width: 50),
                                    );
                                  },
                                ),
                              ],
                            ),
                          );
                        },
                      ),
                    ),
                  ],
                ),

                /// handyman Card
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    16.height,
                    ShimmerWidget(height: 10, width: context.width() * 0.25),
                    16.height,
                    Container(
                      padding: EdgeInsets.all(16),
                      decoration: boxDecorationDefault(color: context.cardColor),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              Container(
                                decoration: BoxDecoration(border: Border.all(color: context.dividerColor, width: 1), shape: BoxShape.circle),
                                child: ShimmerWidget(height: 70, width: 70).cornerRadiusWithClipRRect(35),
                              ),
                              16.width,
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  ShimmerWidget(height: 10, width: context.width()),
                                  4.height,
                                  DisabledRatingBarWidget(rating: 0),
                                ],
                              ).expand(),
                              8.width,
                              Container(
                                decoration: BoxDecoration(border: Border.all(color: context.dividerColor, width: 1), shape: BoxShape.circle),
                                child: ShimmerWidget(height: 20, width: 20),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ],
                ),

                /// Provider Card
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    16.height,
                    ShimmerWidget(height: 10, width: context.width() * 0.25),
                    16.height,
                    Container(
                      padding: EdgeInsets.all(16),
                      decoration: boxDecorationDefault(color: context.cardColor),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              Container(
                                decoration: BoxDecoration(border: Border.all(color: context.dividerColor, width: 1), shape: BoxShape.circle),
                                child: ShimmerWidget(height: 70, width: 70).cornerRadiusWithClipRRect(35),
                              ),
                              16.width,
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  ShimmerWidget(height: 10, width: context.width()),
                                  4.height,
                                  DisabledRatingBarWidget(rating: 0),
                                ],
                              ).expand(),
                              8.width,
                              Container(
                                decoration: BoxDecoration(border: Border.all(color: context.dividerColor, width: 1), shape: BoxShape.circle),
                                child: ShimmerWidget(height: 20, width: 20),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ],
                ),

                /// Extra charges Card
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    24.height,
                    ShimmerWidget(height: 10, width: context.width() * 0.25),
                    16.height,
                    Container(
                      decoration: boxDecorationWithRoundedCorners(backgroundColor: context.cardColor, borderRadius: radius()),
                      padding: EdgeInsets.all(16),
                      child: ListView.builder(
                        itemCount: 2,
                        shrinkWrap: true,
                        padding: EdgeInsets.zero,
                        physics: NeverScrollableScrollPhysics(),
                        itemBuilder: (_, i) {
                          return Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                children: [
                                  ShimmerWidget(height: 10, width: context.width()).expand(),
                                  16.width,
                                  Row(
                                    children: [
                                      ShimmerWidget(height: 10, width: context.width() * 0.12),
                                      4.width,
                                      ShimmerWidget(height: 10, width: context.width() * 0.12),
                                    ],
                                  ),
                                ],
                              ),
                            ],
                          ).paddingSymmetric(vertical: 4);
                        },
                      ),
                    ),
                  ],
                ),

                /// Price Detail
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    16.height,
                    ShimmerWidget(height: 10, width: context.width() * 0.25),
                    16.height,
                    Container(
                      padding: EdgeInsets.all(16),
                      width: context.width(),
                      decoration: boxDecorationDefault(color: context.cardColor),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              ShimmerWidget(height: 10, width: context.width() * 0.15).expand(),
                              16.width,
                              ShimmerWidget(height: 10, width: context.width() * 0.12),
                            ],
                          ),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Divider(height: 26, color: context.dividerColor),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  ShimmerWidget(height: 10, width: context.width() * 0.15).flexible(fit: FlexFit.loose),
                                  ShimmerWidget(height: 10, width: context.width() * 0.12).flexible(flex: 2),
                                ],
                              ),
                            ],
                          ),
                          Column(
                            children: [
                              Divider(height: 26, color: context.dividerColor),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  ShimmerWidget(height: 10, width: context.width() * 0.15),
                                  16.width,
                                  ShimmerWidget(height: 10, width: context.width() * 0.12),
                                ],
                              ),
                            ],
                          ),
                          Column(
                            children: [
                              Divider(height: 26, color: context.dividerColor),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                mainAxisSize: MainAxisSize.max,
                                children: [
                                  ShimmerWidget(height: 10, width: context.width() * 0.15).expand(),
                                  16.width,
                                  ShimmerWidget(height: 10, width: context.width() * 0.12),
                                ],
                              ),
                            ],
                          ),
                          Column(
                            children: [
                              Divider(height: 26, color: context.dividerColor),
                              Row(
                                children: [
                                  ShimmerWidget(height: 10, width: context.width() * 0.15),
                                  ShimmerWidget(height: 10, width: context.width() * 0.14).expand(),
                                  16.width,
                                  ShimmerWidget(height: 10, width: context.width() * 0.12),
                                ],
                              ),
                            ],
                          ),
                          Divider(height: 26, color: context.dividerColor),
                          Row(
                            children: [
                              ShimmerWidget(height: 10, width: context.width() * 0.15).expand(),
                              ShimmerWidget(height: 10, width: context.width() * 0.12),
                            ],
                          ),
                        ],
                      ),
                    )
                  ],
                ),

                /// Payment Detail Card
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    16.height,
                    ShimmerWidget(height: 10, width: context.width() * 0.25),
                    16.height,
                    Container(
                      decoration: boxDecorationWithRoundedCorners(
                        backgroundColor: context.cardColor,
                        borderRadius: BorderRadius.all(Radius.circular(16)),
                      ),
                      padding: EdgeInsets.symmetric(horizontal: 16, vertical: 16),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              ShimmerWidget(height: 10, width: context.width() * 0.15),
                              ShimmerWidget(height: 10, width: context.width() * 0.12),
                            ],
                          ),
                          4.height,
                          Divider(color: context.dividerColor),
                          4.height,
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              ShimmerWidget(height: 10, width: context.width() * 0.15),
                              ShimmerWidget(height: 10, width: context.width() * 0.12),
                            ],
                          ),
                          4.height,
                          Divider(color: context.dividerColor),
                          8.height,
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              ShimmerWidget(height: 10, width: context.width() * 0.15),
                              ShimmerWidget(height: 10, width: context.width() * 0.12),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ],
                ),

                /// Customer Ratting
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    16.height,
                    ShimmerWidget(height: 10, width: context.width() * 0.25),
                    16.height,
                    ListView.builder(
                      shrinkWrap: true,
                      physics: NeverScrollableScrollPhysics(),
                      itemCount: 4,
                      itemBuilder: (context, index) {
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
                                  Container(
                                    decoration: BoxDecoration(border: Border.all(color: context.dividerColor, width: 1), shape: BoxShape.circle),
                                    child: ShimmerWidget(height: 50, width: 50).cornerRadiusWithClipRRect(35),
                                  ),
                                  16.width,
                                  Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      4.height,
                                      ShimmerWidget(height: 10, width: context.width()),
                                      4.height,
                                      ShimmerWidget(height: 10, width: context.width()),
                                      4.height,
                                      ShimmerWidget(height: 10, width: context.width()),
                                    ],
                                  ).flexible(),
                                ],
                              ),
                            ],
                          ),
                        );
                      },
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
