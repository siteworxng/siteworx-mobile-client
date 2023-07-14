import 'package:client/component/spin_kit_chasing_dots.dart';
import 'package:client/utils/colors.dart';
import 'package:flutter/material.dart';

class LoaderWidget extends StatefulWidget {
  @override
  _LoaderWidgetState createState() => _LoaderWidgetState();
}

class _LoaderWidgetState extends State<LoaderWidget> with TickerProviderStateMixin {
  late AnimationController controller;

  @override
  void initState() {
    super.initState();
    init();
  }

  void init() async {
    controller = AnimationController(vsync: this, duration: Duration(milliseconds: 1000))..repeat(reverse: true);
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SpinKitChasingDots(color: primaryColor);
  }
}
