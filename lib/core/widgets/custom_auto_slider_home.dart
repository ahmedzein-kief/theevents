import 'dart:async';

import 'package:flutter/cupertino.dart';

class AutoScrollingSlider extends StatefulWidget {
  const AutoScrollingSlider({
    super.key,
    required this.children,
    this.scrollDuration = const Duration(seconds: 1),
    this.scrollInterval = const Duration(seconds: 3),
    required this.itemWidth,
  });
  final List<Widget> children;
  final Duration scrollDuration;
  final Duration scrollInterval;
  final double itemWidth;

  @override
  _AutoScrollingSliderState createState() => _AutoScrollingSliderState();
}

class _AutoScrollingSliderState extends State<AutoScrollingSlider> {
  late ScrollController _scrollController;
  late Timer _timer;

  @override
  void initState() {
    super.initState();
    _scrollController = ScrollController();
    _startAutoScroll();
  }

  void _startAutoScroll() {
    _timer = Timer.periodic(widget.scrollInterval, (timer) {
      if (_scrollController.hasClients) {
        final maxScrollExtent = _scrollController.position.maxScrollExtent;
        final currentScrollPosition = _scrollController.position.pixels;
        final targetScrollPosition = currentScrollPosition + widget.itemWidth;

        if (targetScrollPosition >= maxScrollExtent) {
          final double offset = targetScrollPosition - maxScrollExtent;
          _scrollController.jumpTo(0);
          _scrollController.animateTo(
            offset,
            duration: widget.scrollDuration,
            curve: Curves.easeInOut,
          );
        } else {
          _scrollController.animateTo(
            targetScrollPosition,
            duration: widget.scrollDuration,
            curve: Curves.easeInOut,
          );
        }
      }
    });
  }

  @override
  void dispose() {
    _timer.cancel();
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) => ListView.builder(
        shrinkWrap: true,
        physics: const AlwaysScrollableScrollPhysics(),
        controller: _scrollController,
        reverse: false,
        scrollDirection: Axis.horizontal,
        itemCount: widget.children.length * 900,
        // itemCount: widget.children.length ,
        itemBuilder: (context, index) {
          return widget
              .children[index % widget.children.length]; // Circular indexing
          // return widget.children[index];
        },
      );
}
