import 'package:mac_doc/models/item.dart';

sealed class DragTargetState {}

class DragTargetState$Idle extends DragTargetState {}

class DragTargetState$DragTargetHoveredWithObject extends DragTargetState {}

class DragTargetState$ObjectAccepted extends DragTargetState {
  DragTargetState$ObjectAccepted({required this.acceptedItem});

  final DockItem acceptedItem;
}
