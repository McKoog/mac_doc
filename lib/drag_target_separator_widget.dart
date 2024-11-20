import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mac_doc/bloc/dock_bloc/dock_bloc.dart';
import 'package:mac_doc/bloc/dock_bloc/dock_event.dart';
import 'package:mac_doc/bloc/drag_target_bloc/drag_target_bloc.dart';
import 'package:mac_doc/bloc/drag_target_bloc/drag_target_event.dart';
import 'package:mac_doc/bloc/drag_target_bloc/drag_target_state.dart';
import 'package:mac_doc/models/item.dart';

/// Separator widget handles reactions to user
/// dragging the doc items, also animates UI.
class DragTargetSeparatorWidget extends StatelessWidget {
  const DragTargetSeparatorWidget(
      {super.key,
      required this.separatorItem,
      required this.height,
      required this.width});

  final DragTargetSeparatorItem separatorItem;
  final double height;
  final double width;

  @override
  Widget build(BuildContext context) {
    final dragTargetBloc = context.read<DragTargetBloc>();

    return BlocBuilder<DragTargetBloc, DragTargetState>(
        builder: (context, state) {
      return DragTarget<DockItem>(
          key: key,
          onAcceptWithDetails: (details) {
            dragTargetBloc
                .add(DragTargetEvent$OnAccept(acceptedItem: details.data));
          },
          onWillAcceptWithDetails: (details) {
            dragTargetBloc.add(DragTargetEvent$OnHoverWithObject());
            return true;
          },
          onLeave: (details) {
            dragTargetBloc.add(DragTargetEvent$OnLeaveTarget());
          },
          builder: (context, candidateData, rejectedData) {
            if (state is DragTargetState$ObjectAccepted) {
              context.read<DockBloc>().add(DockEvent$InsertAtSeparator(
                  separatorItem: separatorItem, dockItem: state.acceptedItem));

              dragTargetBloc.add(DragTargetEvent$OnLeaveTarget());
            }

            return AnimatedSize(
                duration: const Duration(milliseconds: 150),
                child: switch (state) {
                  DragTargetState$Idle() => SizedBox(
                      height: height,
                      width: width,
                    ),
                  DragTargetState$DragTargetHoveredWithObject() =>
                    AnimatedPadding(
                      duration: const Duration(milliseconds: 150),
                      padding: EdgeInsets.symmetric(horizontal: height / 2),
                      child: SizedBox(
                        height: height,
                        width: width,
                      ),
                    ),
                  DragTargetState$ObjectAccepted() => const SizedBox.shrink(),
                });
          });
    });
  }
}
