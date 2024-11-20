import 'package:mac_doc/models/item.dart';

sealed class DragTargetEvent {}

class DragTargetEvent$OnHoverWithObject extends DragTargetEvent {}

class DragTargetEvent$OnLeaveTarget extends DragTargetEvent {}

class DragTargetEvent$OnAccept extends DragTargetEvent {
  DragTargetEvent$OnAccept({required this.acceptedItem});

  final DockItem acceptedItem;
}
