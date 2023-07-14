import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';

class EmptyStateWidget extends StatelessWidget {
  final double? height;
  final double? width;

  const EmptyStateWidget({this.height, this.width});

  @override
  Widget build(BuildContext context) {
    return Lottie.asset('assets/lottie/empty_lottie.json', height: 150, repeat: true);
  }
}

class ErrorStateWidget extends StatelessWidget {
  final double? height;
  final double? width;

  const ErrorStateWidget({this.height, this.width});

  @override
  Widget build(BuildContext context) {
    return Lottie.asset('assets/lottie/error_lottie.json', height: 110, repeat: true);
  }
}
