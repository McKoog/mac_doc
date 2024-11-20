import 'package:flutter/material.dart';
import 'package:mac_doc/models/item.dart';

/// Used as a [childWhenDragging] to [DraggableDockWidget]. Reacts to different user
/// actions and handles animations
class DraggableChildTargetWidget extends StatefulWidget {
  const DraggableChildTargetWidget(
      {super.key, required this.height, required this.width, this.onLeave});

  final double height;
  final double width;
  final Function()? onLeave;

  @override
  State<DraggableChildTargetWidget> createState() =>
      _DraggableChildTargetWidgetState();
}

class _DraggableChildTargetWidgetState
    extends State<DraggableChildTargetWidget> {
  bool isOnTarget = true;

  @override
  Widget build(BuildContext context) {
    return DragTarget<DockItem>(onWillAcceptWithDetails: (details) {
      setState(() {
        isOnTarget = true;
      });
      return true;
    }, onLeave: (details) {
      setState(() {
        isOnTarget = false;
      });
      widget.onLeave?.call();
    }, builder: (context, candidateData, rejectedData) {
      return AnimatedSize(
        duration: const Duration(milliseconds: 150),
        child: isOnTarget
            ? SizedBox(
                height: widget.height,
                width: widget.width,
              )
            : const SizedBox.shrink(),
      );
    });
  }
}
