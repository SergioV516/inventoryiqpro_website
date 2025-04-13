import 'package:flutter/material.dart';

class Responsive extends StatelessWidget {
  final Widget small;
  final Widget? medium;
  final Widget large;

  const Responsive({
    Key? key,
    required this.small,
    this.medium,
    required this.large,
  }) : super(key: key);

  static bool isSmall(BuildContext context) =>
      MediaQuery.of(context).size.width < 800;

  static bool isMedium(BuildContext context) =>
      MediaQuery.of(context).size.width >= 800 &&
      MediaQuery.of(context).size.width < 1200;

  static bool isLarge(BuildContext context) =>
      MediaQuery.of(context).size.width >= 1200;

  @override
  Widget build(BuildContext context) {
    if (isLarge(context)) {
      return large;
    } else if (isMedium(context) && medium != null) {
      return medium!;
    } else {
      return small;
    }
  }
}
