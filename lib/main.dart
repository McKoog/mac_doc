import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mac_doc/bloc/dock_bloc/dock_bloc.dart';
import 'package:mac_doc/bloc/dock_bloc/dock_state.dart';
import 'package:mac_doc/bloc/drag_bloc/drag_bloc.dart';
import 'package:mac_doc/bloc/drag_target_bloc/drag_target_bloc.dart';
import 'package:mac_doc/drag_target_separator_widget.dart';
import 'package:mac_doc/draggable_dock_widget.dart';
import 'package:mac_doc/models/item.dart';
import 'package:uuid/uuid.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        body: MultiBlocProvider(
          providers: [
            BlocProvider(
              create: (context) => DockBloc(initialItems: [
                DockItem(id: const Uuid().v1(), iconData: Icons.person),
                DockItem(id: const Uuid().v1(), iconData: Icons.message),
                DockItem(id: const Uuid().v1(), iconData: Icons.call),
                DockItem(id: const Uuid().v1(), iconData: Icons.camera),
                DockItem(id: const Uuid().v1(), iconData: Icons.photo),
                DockItem(id: const Uuid().v1(), iconData: Icons.access_alarm),
                DockItem(id: const Uuid().v1(), iconData: Icons.add_a_photo),
              ]),
            ),
            BlocProvider(create: (context) => DragBloc()),
          ],
          child: Builder(builder: (context) {
            return BlocBuilder<DockBloc, DockState>(
                bloc: context.read<DockBloc>(),
                builder: (context, docState) {
                  return Center(
                    child: Dock(
                      items: docState.items,
                      builder: (item, size) {
                        return switch (item) {
                          DragTargetSeparatorItem separatorItem => BlocProvider(
                              create: (context) => DragTargetBloc(),
                              child: DragTargetSeparatorWidget(
                                key: ValueKey(item.id),
                                separatorItem: separatorItem,
                                height: size,
                                width: 6,
                              ),
                            ),
                          DockItem() => DraggableDockWidget(
                              key: ValueKey(item.id),
                              dockItem: item,
                              size: size),
                        };
                      },
                    ),
                  );
                });
          }),
        ),
      ),
    );
  }
}

/// Dock of the reorderable [items].
class Dock<T> extends StatelessWidget {
  const Dock({
    super.key,
    this.items = const [],
    required this.builder,
  });

  /// Initial [T] items to put in this [Dock].
  final List<T> items;

  /// Builder building the provided [T] item.
  final Widget Function(T item, double size) builder;

  @override
  Widget build(BuildContext context) {
    final dockBlock = context.read<DockBloc>();

    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(8),
        color: Colors.black12,
      ),
      padding: const EdgeInsets.all(4),
      child: AnimatedSize(
        duration: const Duration(milliseconds: 150),
        child: Row(
            mainAxisSize: MainAxisSize.min,
            children: items
                .map((item) => builder(item, dockBlock.calculateItemSize()))
                .toList()),
      ),
    );
  }
}
