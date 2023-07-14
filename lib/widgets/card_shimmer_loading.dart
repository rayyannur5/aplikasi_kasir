import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';

class CardShimmerLoading extends StatelessWidget {
  const CardShimmerLoading({super.key});

  @override
  Widget build(BuildContext context) {
    return Shimmer.fromColors(
      baseColor: Colors.transparent,
      highlightColor: Colors.white.withOpacity(0.5),
      child: const Card(margin: EdgeInsets.zero, elevation: 0),
    );
  }
}
