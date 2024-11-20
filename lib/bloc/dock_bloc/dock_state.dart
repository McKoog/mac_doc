import 'package:mac_doc/models/item.dart';

class DockState {
  DockState({required this.items, this.isItemOutside = false});

  final List<Item> items;
  final bool isItemOutside;
}
