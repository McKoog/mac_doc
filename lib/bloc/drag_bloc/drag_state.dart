import 'package:mac_doc/models/item.dart';

sealed class DragState {}

class DragState$Idle extends DragState {}

class DragState$Dragging extends DragState {
  DragState$Dragging({required this.draggedItem});

  final DockItem draggedItem;
}
