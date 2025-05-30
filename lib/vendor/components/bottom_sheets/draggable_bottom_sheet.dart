import 'package:flutter/material.dart';

Future<T?> showDraggableModalBottomSheet<T>({
  required BuildContext context,
  required Widget Function(ScrollController) builder,
  double initialChildSize = 0.5,
  double minChildSize = 0.2,
  double maxChildSize = 1.0,
}) {
  return showModalBottomSheet<T>(
    context: context,
    isDismissible: true,
    enableDrag: true,
    isScrollControlled: true,
    backgroundColor: Colors.transparent,
    builder: (context) {
      return DraggableScrollableSheet(
        initialChildSize: initialChildSize,
        minChildSize: minChildSize,
        maxChildSize: maxChildSize,
        expand: false,
        builder: (context, scrollController) => Container(
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
          ),
          child: builder(scrollController),
        ),
      );
    },
  );
}
