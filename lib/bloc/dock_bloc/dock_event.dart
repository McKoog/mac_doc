import 'package:mac_doc/models/item.dart';

sealed class DockEvent {}

class DockEvent$DockItemOutside extends DockEvent {
  DockEvent$DockItemOutside({required this.outsideItemId});

  final String outsideItemId;
}

class DockEvent$RemoveFromDock extends DockEvent {
  DockEvent$RemoveFromDock({required this.itemId});

  final String itemId;
}

class DockEvent$InsertAtSeparator extends DockEvent {
  DockEvent$InsertAtSeparator(
      {required this.separatorItem, required this.dockItem});

  final DragTargetSeparatorItem separatorItem;
  final DockItem dockItem;
}

class DockEvent$UpdateSeparators extends DockEvent {
  DockEvent$UpdateSeparators({this.items});

  final List<Item>? items;
}
