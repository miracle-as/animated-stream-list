import 'dart:async';

import 'package:animated_stream_list/src/animated_stream_list_item_builder.dart';
import 'package:animated_stream_list/src/myers_diff.dart';
import 'package:animated_stream_list/src/sliver_list_controller.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:animated_stream_list/src/diff_applier.dart';

class SliverAnimatedStreamList<E> extends StatefulWidget {
  final Stream<List<E>> streamList;
  final List<E> initialList;
  final AnimatedStreamListItemBuilder<E> itemBuilder;
  final AnimatedStreamListItemBuilder<E> itemRemovedBuilder;
  final Equalizer equals;
  final Duration duration;

  SliverAnimatedStreamList(
      {@required this.streamList,
      this.initialList,
      @required this.itemBuilder,
      @required this.itemRemovedBuilder,
      this.equals,
      this.duration = const Duration(milliseconds: 300)});

  @override
  State<StatefulWidget> createState() => _SliverAnimatedStreamListState<E>();
}

class _SliverAnimatedStreamListState<E> extends State<SliverAnimatedStreamList<E>>
    with WidgetsBindingObserver {
  final GlobalKey<SliverAnimatedListState> _globalKey = GlobalKey();
  SliverListController<E> _listController;
  DiffApplier<E> _diffApplier;
  DiffUtil<E> _diffUtil;
  StreamSubscription _subscription;

  void startListening() {
    _subscription?.cancel();
    _subscription = widget.streamList
      .asyncExpand((list) => _diffUtil
          .calculateDiff(_listController.items, list, equalizer: widget.equals)
          .then(_diffApplier.applyDiffs)
          .asStream())
      .listen((list) { });
  }

  void stopListening() {
    _subscription?.cancel();
    _subscription = null;
  }

  @override
  void initState() {
    super.initState();
    _listController = SliverListController(
        key: _globalKey,
        items: widget.initialList ?? <E>[],
        itemRemovedBuilder: widget.itemRemovedBuilder,
        duration: widget.duration);

    _diffApplier = DiffApplier(_listController);
    _diffUtil = DiffUtil();

    startListening();
  }

  @override
  void dispose() {
    stopListening();
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    switch (state) {
      case AppLifecycleState.resumed:
        startListening();
        break;
      case AppLifecycleState.paused:
        stopListening();
        break;
      default:
        break;
    }
  }

  @override
  Widget build(BuildContext context) {
    return SliverAnimatedList(
      initialItemCount: _listController.items.length,
      key: _globalKey,      
      itemBuilder:
          (BuildContext context, int index, Animation<double> animation) =>
              widget.itemBuilder(
        _listController[index],
        index,
        context,
        animation,
      ),
    );
  }
}
