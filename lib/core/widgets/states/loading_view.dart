import 'package:flutter/material.dart';

/// Standard full-space loading indicator for a screen's body.
class LoadingView extends StatelessWidget {
  const LoadingView({super.key});

  @override
  Widget build(BuildContext context) {
    return const Center(child: CircularProgressIndicator());
  }
}
