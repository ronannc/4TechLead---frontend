import 'package:flutter/widgets.dart';

/// Width thresholds used to switch between mobile and desktop layouts
/// (mobile-first app that must also work well on macOS/Windows).
class Breakpoints {
  Breakpoints._();

  static const mobile = 600.0;
  static const tablet = 1024.0;

  static bool isMobile(BuildContext context) => MediaQuery.sizeOf(context).width < mobile;

  static bool isDesktop(BuildContext context) => MediaQuery.sizeOf(context).width >= tablet;
}
