import 'package:flutter/material.dart';
import 'package:extension/configs/app_globals.dart';
import 'package:extension/configs/constants.dart';
import 'package:extension/generated/l10n.dart';
import 'package:extension/main.dart';
import 'package:extension/screens/home/widgets/wavy_header_image.dart';
import 'package:extension/utils/bottom_bar_items.dart';
import 'package:extension/utils/text_style.dart';
import 'package:extension/widgets/strut_text.dart';
import 'package:extension/model/banners_model.dart'as bann;

import '../../../slider.dart';

/// Delegate for configuring a [SliverPersistentHeader].
///
/// A sliver whose size varies when the sliver is scrolled to the edge
/// of the viewport opposite the sliver's [GrowthDirection].
class HomeHeader extends SliverPersistentHeaderDelegate {
  List<bann.Banner> banners=[];

  HomeHeader({this.expandedHeight,this.banners});

  /// The max height of the header.
  final double expandedHeight;

  @override
  Widget build(BuildContext context, double shrinkOffset, bool overlapsContent) {
    return
      Container(
      child: CarosilSlider(shrinkOffset / expandedHeight,banners),

    );
  }

  /// The size of the header when it is not shrinking at the top of the
  /// viewport.
  ///
  /// This must return a value equal to or greater than [minExtent].
  @override
  double get maxExtent => expandedHeight;

  /// The smallest size to allow the header to reach, when it shrinks at the
  /// start of the viewport.
  ///
  /// This must return a value equal to or less than [maxExtent].
  @override
  double get minExtent => 158;

  /// Whether this delegate is meaningfully different from the old delegate.
  @override
  bool shouldRebuild(SliverPersistentHeaderDelegate oldDelegate) => true;
}
