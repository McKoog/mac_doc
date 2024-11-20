import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mac_doc/bloc/drag_target_bloc/drag_target_event.dart';
import 'package:mac_doc/bloc/drag_target_bloc/drag_target_state.dart';

class DragTargetBloc extends Bloc<DragTargetEvent, DragTargetState> {
  DragTargetBloc() : super(DragTargetState$Idle()) {
    on<DragTargetEvent>((event, emitter) => switch (event) {
          DragTargetEvent$OnHoverWithObject() =>
            _onHoverWithObject(event, emitter),
          DragTargetEvent$OnLeaveTarget() => _onLeaveTarget(event, emitter),
          DragTargetEvent$OnAccept() => _onAccept(event, emitter),
        });
  }

  /// Called when users drags dock item to the new spot(target)
  void _onHoverWithObject(DragTargetEvent$OnHoverWithObject event,
      Emitter<DragTargetState> emitter) {
    emitter(DragTargetState$DragTargetHoveredWithObject());
  }

  /// Called when user drags dock item outside of the dock (drag targets)
  void _onLeaveTarget(
      DragTargetEvent$OnLeaveTarget event, Emitter<DragTargetState> emitter) {
    emitter(DragTargetState$Idle());
  }

  /// Called when user dropped dragged dock item to the new spot successfully
  void _onAccept(
      DragTargetEvent$OnAccept event, Emitter<DragTargetState> emitter) {
    emitter(DragTargetState$ObjectAccepted(acceptedItem: event.acceptedItem));
  }
}
