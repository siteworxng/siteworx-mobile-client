import 'package:client/component/back_widget.dart';
import 'package:client/component/loader_widget.dart';
import 'package:client/main.dart';
import 'package:flutter/material.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:photo_view/photo_view.dart';
import 'package:photo_view/photo_view_gallery.dart';

class ZoomImageScreen extends StatefulWidget {
  final int index;
  final List<String>? galleryImages;

  ZoomImageScreen({required this.index, this.galleryImages});

  @override
  _ZoomImageScreenState createState() => _ZoomImageScreenState();
}

class _ZoomImageScreenState extends State<ZoomImageScreen> {
  bool showAppBar = false;

  @override
  void initState() {
    super.initState();
    init();
  }

  Future<void> init() async {
    enterFullScreen();
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () {
        exitFullScreen();

        return Future.value(true);
      },
      child: Scaffold(
        backgroundColor: Colors.black,
        appBar: showAppBar
            ? appBarWidget(
                language.lblGallery,
                textColor: Colors.white,
                color: context.primaryColor,
                backWidget: BackWidget(),
              )
            : null,
        body: GestureDetector(
          onTap: () {
            showAppBar = !showAppBar;

            if (showAppBar) {
              exitFullScreen();
            } else {
              enterFullScreen();
            }

            setState(() {});
          },
          child: PhotoViewGallery.builder(
            scrollPhysics: BouncingScrollPhysics(),
            enableRotation: false,
            backgroundDecoration: BoxDecoration(color: Colors.black),
            pageController: PageController(initialPage: widget.index),
            builder: (BuildContext context, int index) {
              return PhotoViewGalleryPageOptions(
                imageProvider: Image.network(widget.galleryImages![index], errorBuilder: (context, error, stackTrace) => PlaceHolderWidget()).image,
                initialScale: PhotoViewComputedScale.contained,
                minScale: PhotoViewComputedScale.contained,
                errorBuilder: (context, error, stackTrace) => PlaceHolderWidget(),
                heroAttributes: PhotoViewHeroAttributes(
                  tag: widget.galleryImages![index],
                ),
              );
            },
            itemCount: widget.galleryImages!.length,
            loadingBuilder: (context, event) => LoaderWidget(),
          ),
        ),
      ),
    );
  }
}
