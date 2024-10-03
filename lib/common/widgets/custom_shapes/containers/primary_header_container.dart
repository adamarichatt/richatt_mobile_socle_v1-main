import 'package:flutter/material.dart';
import 'package:Remeet/common/widgets/custom_shapes/containers/circular_container.dart';
import 'package:Remeet/common/widgets/custom_shapes/curved_edges/curved_edges_widget.dart';
import 'package:Remeet/utils/constants/colors.dart';

class RPrimaryHeaderContainer extends StatelessWidget {
  const RPrimaryHeaderContainer({super.key, required this.child});

  final Widget child;

  @override
  Widget build(BuildContext context) {
    return RCurvedEdgeWidget(
      child: Container(
        color: RColors.primary,
        padding: const EdgeInsets.all(0),
        child: SizedBox(
          height: 400,
          child: Stack(
            children: [
              Positioned(
                  top: -150,
                  right: -250,
                  child: RCircularContainer(
                    backgroundColor: RColors.textWhite.withOpacity(0.1),
                  )),
              Positioned(
                  top: 100,
                  right: -300,
                  child: RCircularContainer(
                    backgroundColor: RColors.textWhite.withOpacity(0.1),
                  )),
              child,
            ],
          ),
        ),
      ),
    );
  }
}
