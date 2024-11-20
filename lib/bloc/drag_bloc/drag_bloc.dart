import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mac_doc/bloc/drag_bloc/drag_event.dart';
import 'package:mac_doc/bloc/drag_bloc/drag_state.dart';

class DragBloc extends Bloc<DragEvent, DragState> {
  DragBloc() : super(DragState$Idle()) {
    on<DragEvent>((event, emitter) => switch (event) {
          DragEvent$StartDrag() => _startDragging(event, emitter),
          DragEvent$StopDrag() => _stopDragging(event, emitter),
        });
  }

  /// Change state when dragging stopped
  void _stopDragging(DragEvent$StopDrag event, Emitter<DragState> emitter) {
    emitter(DragState$Idle());
  }

  /// Change state when dragging started
  void _startDragging(DragEvent$StartDrag event, Emitter<DragState> emitter) {
    emitter(DragState$Dragging(draggedItem: event.item));
  }
}
