import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';

class ShimmerBox extends StatelessWidget {
  final int flex;
  final double widthFactor;

  const ShimmerBox({
    required this.flex,
    required this.widthFactor,
  });

  @override
  Widget build(BuildContext context) {
    return Expanded(
      flex: flex,
      child: FractionallySizedBox(
        widthFactor: widthFactor,
        child: Shimmer.fromColors(
          baseColor: Colors.grey.shade300,
          highlightColor: Colors.grey.shade100,
          child: Container(
            height: 20.0, // Height for the shimmer box
            decoration: BoxDecoration(
              color: Colors.grey,
              borderRadius: BorderRadius.circular(15),
            ),
          ),
        ),
      ),
    );
  }
}

class ShimmerView extends StatelessWidget {
  final int flex; // Make the flex parameter a class member.

  const ShimmerView({required this.flex});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        ShimmerBox(flex: flex, widthFactor: 1),
        SizedBox(height: 10),
        ShimmerBox(flex: flex, widthFactor: 1),
        SizedBox(height: 10),
        ShimmerBox(flex: flex, widthFactor: 1),
        SizedBox(height: 10),
        ShimmerBox(flex: flex, widthFactor: 1),
        SizedBox(height: 10),
        ShimmerBox(flex: flex, widthFactor: 1),
        SizedBox(height: 10),
        ShimmerBox(flex: flex, widthFactor: 1),
        SizedBox(height: 10),
        ShimmerBox(flex: flex, widthFactor: 1),
        SizedBox(height: 10),
        ShimmerBox(flex: flex, widthFactor: 1),
        SizedBox(height: 10),
      ],
    );
  }
}
