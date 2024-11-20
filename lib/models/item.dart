import 'package:flutter/material.dart';

/// Base item of the dock
sealed class Item {
  Item({
    required this.id,
  });

  /// Id of item
  final String id;
}

/// Separator (DragTarget) divider between dock elements
class DragTargetSeparatorItem extends Item {
  DragTargetSeparatorItem({required super.id});

  DragTargetSeparatorItem copyWith({String? id, int? linkDockIndex}) {
    return DragTargetSeparatorItem(
      id: id ?? this.id,
    );
  }

  @override
  String toString() {
    return "DragTargetSeparatorItem(id:$id)";
  }
}

/// Dock item with icon
class DockItem extends Item {
  DockItem({
    required super.id,
    required this.iconData,
  });

  final IconData iconData;

  DockItem copyWith(
      {String? id,
      IconData? iconData,
      bool? isDragged,
      bool? isInsideDoc,
      bool? approvedToBeInserted}) {
    return DockItem(
      id: id ?? this.id,
      iconData: iconData ?? this.iconData,
    );
  }

  @override
  String toString() {
    return "DockItem(id:$id,icon:$iconData)";
  }
}
