import 'package:client/component/back_widget.dart';
import 'package:client/component/cached_image_widget.dart';
import 'package:client/screens/blog/model/blog_response_model.dart';
import 'package:client/screens/gallery/gallery_component.dart';
import 'package:client/screens/gallery/gallery_screen.dart';
import 'package:flutter/material.dart';
import 'package:nb_utils/nb_utils.dart';

class BlogDetailHeaderComponent extends StatefulWidget {
  final BlogData blogData;

  BlogDetailHeaderComponent({required this.blogData});

  @override
  State<BlogDetailHeaderComponent> createState() => _BlogDetailHeaderComponentState();
}

class _BlogDetailHeaderComponentState extends State<BlogDetailHeaderComponent> {
  @override
  void initState() {
    init();
    super.initState();
  }

  void init() async {
    //
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 375,
      width: context.width(),
      child: Stack(
        clipBehavior: Clip.none,
        children: [
          if (widget.blogData.attachment.validate().isNotEmpty)
            SizedBox(
              height: 400,
              width: context.width(),
              child: CachedImageWidget(
                url: widget.blogData.attachment!.first.url.validate(),
                fit: BoxFit.cover,
                height: 400,
              ),
            ),
          Positioned(
            top: context.statusBarHeight + 8,
            left: 8,
            child: Container(
              child: BackWidget(iconColor: context.iconColor),
              decoration: BoxDecoration(shape: BoxShape.circle, color: context.cardColor.withOpacity(0.7)),
            ),
          ),
          Positioned(
            bottom: 0,
            left: 16,
            right: 16,
            child: Column(
              children: [
                Row(
                  children: [
                    Wrap(
                      spacing: 16,
                      runSpacing: 16,
                      children: List.generate(
                        widget.blogData.attachment!.take(2).length,
                        (i) => Container(
                          decoration: BoxDecoration(border: Border.all(color: white, width: 2), borderRadius: radius()),
                          child: GalleryComponent(
                            images: widget.blogData.attachment.validate().map((e) => e.url.validate()).toList(),
                            index: i,
                            padding: 32,
                            height: 60,
                            width: 60,
                          ),
                        ),
                      ),
                    ),
                    16.width,
                    if (widget.blogData.attachment!.length > 2)
                      Blur(
                        borderRadius: radius(),
                        padding: EdgeInsets.zero,
                        child: Container(
                          height: 60,
                          width: 60,
                          alignment: Alignment.center,
                          decoration: BoxDecoration(border: Border.all(color: white, width: 2), borderRadius: radius()),
                          child: Text('+' '${widget.blogData.attachment!.length - 2}', style: boldTextStyle(color: white)),
                        ),
                      ).onTap(() {
                        GalleryScreen(
                          attachments: widget.blogData.attachment.validate().map((e) => e.url.validate()).toList(),
                          serviceName: widget.blogData.title.validate(),
                        ).launch(context, pageRouteAnimation: PageRouteAnimation.Fade, duration: 400.milliseconds).then((value) {
                          setStatusBarColor(transparentColor, delayInMilliSeconds: 1000);
                        });
                      }),
                  ],
                ),
                16.height,
              ],
            ),
          ),
        ],
      ),
    );
  }
}
