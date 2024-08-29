import 'package:flutter/material.dart';
import 'package:richatt_mobile_rimeet/common/widgets/custom_shapes/curved_edges/curved_edges.dart';

class RCurvedEdgeWidget extends StatelessWidget {
  const RCurvedEdgeWidget({super.key, this.child});

  final Widget? child;

  @override
  Widget build(BuildContext context) {
    return ClipPath(
      clipper: RCustomCurvedEdges(),
      child: child,
    );
  }
}
