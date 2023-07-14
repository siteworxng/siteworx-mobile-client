import 'package:client/component/back_widget.dart';
import 'package:client/component/loader_widget.dart';
import 'package:client/main.dart';
import 'package:client/model/user_data_model.dart';
import 'package:client/screens/chat/widget/user_item_widget.dart';
import 'package:client/utils/constant.dart';
import 'package:firebase_pagination/firebase_pagination.dart';
import 'package:flutter/material.dart';
import 'package:nb_utils/nb_utils.dart';

import '../../component/empty_error_state_widget.dart';

class ChatListScreen extends StatefulWidget {
  @override
  _ChatListScreenState createState() => _ChatListScreenState();
}

class _ChatListScreenState extends State<ChatListScreen> {
  @override
  void initState() {
    super.initState();
    init();
  }

  void init() async {
    //
  }

  @override
  void setState(fn) {
    if (mounted) super.setState(fn);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: appBarWidget(
        language.lblChat,
        textColor: white,
        showBack: Navigator.canPop(context),
        textSize: APP_BAR_TEXT_SIZE,
        elevation: 3.0,
        backWidget: BackWidget(),
        color: context.primaryColor,
      ),
      body: appStore.uid.validate().isNotEmpty
          ? FirestorePagination(
              itemBuilder: (context, snap, index) {
                UserData contact = UserData.fromJson(snap.data() as Map<String, dynamic>);

                return UserItemWidget(userUid: contact.uid.validate());
              },
              physics: AlwaysScrollableScrollPhysics(),
              query: chatServices.fetchChatListQuery(userId: appStore.uid.validate()),
              onEmpty: NoDataWidget(
                title: language.noConversation,
                subTitle: language.noConversationSubTitle,
                imageWidget: EmptyStateWidget(),
              ).paddingSymmetric(horizontal: 16),
              initialLoader: LoaderWidget(),
              gridDelegate: SliverGridDelegateWithMaxCrossAxisExtent(maxCrossAxisExtent: 10),
              isLive: true,
              shrinkWrap: true,
              padding: EdgeInsets.only(left: 0, top: 8, right: 0, bottom: 0),
              limit: PER_PAGE_CHAT_LIST_COUNT,
              separatorBuilder: (_, i) => Divider(height: 0, indent: 82, color: context.dividerColor),
              viewType: ViewType.list,
            )
          : NoDataWidget(
              title: language.noConversation,
              subTitle: language.noConversationSubTitle,
              imageWidget: EmptyStateWidget(),
            ).paddingSymmetric(horizontal: 16),
    );
  }
}
