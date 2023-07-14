import 'package:client/component/disabled_rating_bar_widget.dart';
import 'package:client/component/image_border_component.dart';
import 'package:client/main.dart';
import 'package:client/model/user_data_model.dart';
import 'package:client/utils/colors.dart';
import 'package:client/utils/common.dart';
import 'package:client/utils/images.dart';
import 'package:client/utils/string_extensions.dart';
import 'package:flutter/material.dart';
import 'package:nb_utils/nb_utils.dart';

class BookingDetailProviderWidget extends StatefulWidget {
  final UserData providerData;
  final bool canCustomerContact;

  BookingDetailProviderWidget({required this.providerData, this.canCustomerContact = false});

  @override
  BookingDetailProviderWidgetState createState() => BookingDetailProviderWidgetState();
}

class BookingDetailProviderWidgetState extends State<BookingDetailProviderWidget> {
  UserData userData = UserData();

  int? flag;

  @override
  void initState() {
    super.initState();
    init();
  }

  Future<void> init() async {
    userData = widget.providerData;

    setState(() {});
  }

  @override
  void setState(fn) {
    if (mounted) super.setState(fn);
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(16),
      decoration: boxDecorationDefault(color: context.cardColor),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              ImageBorder(src: widget.providerData.profileImage.validate(), height: 70),
              16.width,
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Text(widget.providerData.displayName.validate(), style: boldTextStyle()).flexible(),
                      16.width,
                      ic_info.iconImage(size: 20),
                    ],
                  ),
                  4.height,
                  DisabledRatingBarWidget(rating: widget.providerData.providersServiceRating.validate()),
                ],
              ).expand(),
              Image.asset(ic_verified, height: 24, width: 24, color: verifyAcColor).visible(widget.providerData.isVerifyProvider == 1),
            ],
          ),
          if (widget.canCustomerContact)
            Column(
              children: [
                16.height,
                TextIcon(
                  spacing: 10,
                  onTap: () {
                    launchMail("${widget.providerData.email.validate()}");
                  },
                  prefix: Image.asset(ic_message, width: 20, height: 20, color: appStore.isDarkMode ? Colors.white : Colors.black),
                  text: widget.providerData.email.validate(),
                  expandedText: true,
                ),
                if (widget.providerData.address.validate().isNotEmpty)
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      8.height,
                      TextIcon(
                        spacing: 10,
                        onTap: () {
                          launchMap("${widget.providerData.address.validate()}");
                        },
                        expandedText: true,
                        prefix: Image.asset(ic_location, width: 20, height: 20, color: appStore.isDarkMode ? Colors.white : Colors.black),
                        text: '${widget.providerData.address.validate()}',
                      ),
                    ],
                  ),
                8.height,
                TextIcon(
                  spacing: 10,
                  onTap: () {
                    launchCall(widget.providerData.contactNumber.validate());
                  },
                  prefix: Image.asset(ic_calling, width: 20, height: 20, color: appStore.isDarkMode ? Colors.white : Colors.black),
                  text: '${widget.providerData.contactNumber.validate()}',
                  expandedText: true,
                ),
              ],
            ),
        ],
      ),
    );
  }
}
