import 'package:flutter/material.dart';

class AppBarSliverDelegate extends SliverPersistentHeaderDelegate {
  AppBarSliverDelegate({
    required this.builder,
    this.maxHeight = 200,
    this.minHeight = 100,
  });
  final double minHeight;
  final double maxHeight;
  final Widget Function(double percent) builder;

  @override
  double get maxExtent => maxHeight;

  @override
  double get minExtent => minHeight;

  @override
  Widget build(BuildContext context, double shrinkOffset, bool overlapsContent) {
    final percent = shrinkOffset / maxExtent;
    return builder(1 - percent);
  }

  @override
  bool shouldRebuild(AppBarSliverDelegate oldDelegate) {
    return builder != oldDelegate.builder;
  }
}
