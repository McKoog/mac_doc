import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mac_doc/bloc/dock_bloc/dock_bloc.dart';
import 'package:mac_doc/bloc/dock_bloc/dock_event.dart';
import 'package:mac_doc/bloc/drag_bloc/drag_bloc.dart';
import 'package:mac_doc/bloc/drag_bloc/drag_event.dart';
import 'package:mac_doc/bloc/drag_bloc/drag_state.dart';
import 'package:mac_doc/draggable_child_target_widget.dart';
import 'package:mac_doc/models/item.dart';

/// Dock widget that being dragged by the user.
class DraggableDockWidget extends StatelessWidget {
  const DraggableDockWidget(
      {super.key, required this.dockItem, required this.size});

  final double size;
  final DockItem dockItem;

  @override
  Widget build(BuildContext context) {
    final dockBloc = context.read<DockBloc>();
    final dragBloc = context.read<DragBloc>();

    return Draggable(
      data: dockItem,
      onDragStarted: () {
        dragBloc.add(DragEvent$StartDrag(item: dockItem));
      },
      onDragEnd: (details) {
        if (dockBloc.state.isItemOutside) {
          dockBloc.add(DockEvent$RemoveFromDock(itemId: dockItem.id));
          dragBloc.add(DragEvent$StopDrag());
        }
      },
      feedback: _DockWidget(
        iconData: dockItem.iconData,
        size: size,
      ),
      childWhenDragging: DraggableChildTargetWidget(
        key: key,
        height: size,
        width: size,
        onLeave: () {
          dockBloc.add(DockEvent$DockItemOutside(
              outsideItemId:
                  (dragBloc.state as DragState$Dragging).draggedItem.id));
        },
      ),
      child: _DockWidget(
        // key: key,
        iconData: dockItem.iconData,
        size: size,
      ),
    );
  }
}

class _DockWidget extends StatelessWidget {
  const _DockWidget({required this.iconData, required this.size});

  final IconData iconData;
  final double size;

  @override
  Widget build(BuildContext context) {
    return Container(
      constraints: const BoxConstraints(minWidth: 32),
      height: size,
      width: size,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(8),
        color: Colors.primaries[iconData.hashCode % Colors.primaries.length],
      ),
      child: Center(child: Icon(iconData, color: Colors.white)),
    );
  }
}
