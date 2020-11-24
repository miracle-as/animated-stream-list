import 'package:animated_stream_list/src/animated_stream_list_item_builder.dart';
import 'package:flutter/material.dart';


class SliverListController<E> {
  final GlobalKey<SliverAnimatedListState> key;
  final List<E> items;
  final Duration duration;
  final AnimatedStreamListItemBuilder<E> itemRemovedBuilder;

  SliverListController({
    @required this.key,
    @required this.items,
    @required this.itemRemovedBuilder,
    @required this.duration,
  })  : assert(key != null),
        assert(itemRemovedBuilder != null),
        assert(items != null);

  SliverAnimatedListState get _list => key.currentState;

  void insert(int index, E item) {
    items.insert(index, item);

    _list.insertItem(index, duration: duration);
  }

  void removeItemAt(int index) {
    E item = items.removeAt(index);
    _list.removeItem(
      index,
      (context, animation) =>
          itemRemovedBuilder(item, index, context, animation),
      duration: duration,
    );
  }

  void listChanged(int startIndex, List<E> itemsChanged) {
    int i = 0;
    for (E item in itemsChanged) {
      items[startIndex + i] = item;
      i++;
    }

    // ignore: invalid_use_of_protected_member
    _list.setState(() {});
  }

  int get length => items.length;

  E operator [](int index) => items[index];

  int indexOf(E item) => items.indexOf(item);
}
