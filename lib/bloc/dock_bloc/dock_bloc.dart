import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mac_doc/bloc/dock_bloc/dock_event.dart';
import 'package:mac_doc/bloc/dock_bloc/dock_state.dart';
import 'package:mac_doc/models/item.dart';
import 'package:uuid/uuid.dart';

class DockBloc extends Bloc<DockEvent, DockState> {
  DockBloc({final List<Item> initialItems = const []})
      : super(DockState(items: initialItems)) {
    on<DockEvent>((event, emitter) => switch (event) {
          DockEvent$DockItemOutside() => _onDockItemOutside(event, emitter),
          DockEvent$RemoveFromDock() => _removeItem(event, emitter),
          DockEvent$InsertAtSeparator() => _insertAtSeparator(event, emitter),
          DockEvent$UpdateSeparators() =>
            _updateSeparators(event, emitter),
        });
    add(DockEvent$UpdateSeparators());
  }
  
  /// Reconstruct all separators of drag target between dock items
  void _updateSeparators(
      DockEvent$UpdateSeparators event, Emitter<DockState> emitter) {
    final List<Item> updatedStateItems = [];

    final List<DockItem> dockItems =
        event.items?.whereType<DockItem>().toList() ??
            state.items.whereType<DockItem>().toList();

    final List<DragTargetSeparatorItem> separators =
        List<DragTargetSeparatorItem>.generate(dockItems.length + 1,
            (index) => DragTargetSeparatorItem(id: const Uuid().v4()));

    for (int i = 0; i < separators.length; i++) {
      updatedStateItems.add(separators[i]);
      if (i < dockItems.length) {
        updatedStateItems.add(dockItems[i]);
      }
    }

    emitter(DockState(items: updatedStateItems));
  }

  /// On hover outside of the dock update state and remove separator
  void _onDockItemOutside(
      DockEvent$DockItemOutside event, Emitter<DockState> emitter) {
    final items = state.items.toList();
    final outsideItemIndex =
        items.indexWhere((item) => item.id == event.outsideItemId);
    items.removeAt(outsideItemIndex - 1);
    emitter(DockState(items: items, isItemOutside: true));
  }

  /// Remove dock item from the list
  void _removeItem(DockEvent$RemoveFromDock event, Emitter<DockState> emitter) {
    final items = state.items.toList();
    items.removeWhere((item) => item.id == event.itemId);
    emitter(DockState(items: items));
  }

  /// Insert item on the next index after the picked separator
  void _insertAtSeparator(
      DockEvent$InsertAtSeparator event, Emitter<DockState> emitter) {
    final updatedStateItems = state.items.toList();
    final insertedPositionIndex =
        updatedStateItems.indexOf(event.separatorItem) + 1;
    updatedStateItems.insert(insertedPositionIndex, event.dockItem);

    add(DockEvent$UpdateSeparators(items: updatedStateItems));
  }

  /// Calculate adaptive size of dock items
  double calculateItemSize() {
    final dockItems = state.items.whereType<DockItem>();
    double calculatedItemSize = 54 - dockItems.length.toDouble();

    if (state.isItemOutside) {
      calculatedItemSize++;
    }

    if (calculatedItemSize <= 32) {
      return 32;
    } else {
      return calculatedItemSize;
    }
  }
}
