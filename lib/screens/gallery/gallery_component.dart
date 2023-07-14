import 'package:client/component/cached_image_widget.dart';
import 'package:client/screens/zoom_image_screen.dart';
import 'package:flutter/material.dart';
import 'package:nb_utils/nb_utils.dart';

class GalleryComponent extends StatelessWidget {
  final List<String> images;
  final int index;
  final int? padding;
  final double? height;
  final double? width;

  GalleryComponent({required this.images, required this.index, this.padding, this.height, this.width});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        ZoomImageScreen(galleryImages: images, index: index).launch(context, pageRouteAnimation: PageRouteAnimation.Fade, duration: 200.milliseconds);
      },
      child: CachedImageWidget(
        url: images[index],
        height: height ?? 100,
        width: width ?? (context.width() / 3 - (padding ?? 22)),
        fit: BoxFit.cover,
        radius: defaultRadius,
      ),
    );
  }
}
