import 'package:client/component/back_widget.dart';
import 'package:client/main.dart';
import 'package:client/screens/gallery/gallery_component.dart';
import 'package:flutter/material.dart';
import 'package:nb_utils/nb_utils.dart';

import '../../utils/constant.dart';

class GalleryScreen extends StatefulWidget {
  final String serviceName;
  final List<String> attachments;

  GalleryScreen({required this.serviceName, required this.attachments});

  @override
  State<GalleryScreen> createState() => _GalleryScreenState();
}

class _GalleryScreenState extends State<GalleryScreen> {
  @override
  void initState() {
    afterBuildCreated(() {
      setStatusBarColor(context.primaryColor);
    });
    super.initState();
  }

  @override
  void dispose() {
    setStatusBarColor(Colors.transparent);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: appBarWidget(
        "${language.lblGallery} ${'- ${widget.serviceName}'}",
        textColor: Colors.white,
        color: context.primaryColor,
        backWidget: BackWidget(),
        textSize: APP_BAR_TEXT_SIZE,
      ),
      body: AnimatedWrap(
        spacing: 16,
        runSpacing: 16,
        listAnimationType: ListAnimationType.FadeIn,
        fadeInConfiguration: FadeInConfiguration(duration: 2.seconds),
        scaleConfiguration: ScaleConfiguration(duration: 300.milliseconds, delay: 50.milliseconds),
        itemCount: widget.attachments.length,
        itemBuilder: (context, i) {
          return GalleryComponent(images: widget.attachments, index: i);
        },
      ).paddingSymmetric(horizontal: 16, vertical: 16),
    );
  }
}
