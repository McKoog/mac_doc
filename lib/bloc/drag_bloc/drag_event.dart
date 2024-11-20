import 'package:mac_doc/models/item.dart';

sealed class DragEvent {}

class DragEvent$StartDrag extends DragEvent {
  DragEvent$StartDrag({required this.item});

  final DockItem item;
}

class DragEvent$StopDrag extends DragEvent {}
