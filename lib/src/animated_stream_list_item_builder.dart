
import 'package:flutter/widgets.dart';

typedef Widget AnimatedStreamListItemBuilder<T>(
  T item,
  int index,
  BuildContext context,
  Animation<double> animation,
);
