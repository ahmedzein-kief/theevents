import 'dart:async';

import 'package:flutter/cupertino.dart';

class SimpleBazaarAutoSlider extends StatefulWidget {
  const SimpleBazaarAutoSlider({
    super.key,
    required this.items,
    this.scrollDuration = const Duration(milliseconds: 800),
    this.scrollInterval = const Duration(seconds: 3),
    this.itemWidth = 118.0,
    this.snapToItems = false,
  });

  final List<Widget> items;
  final Duration scrollDuration;
  final Duration scrollInterval;
  final double itemWidth;
  final bool snapToItems;

  @override
  _SimpleBazaarAutoSliderState createState() => _SimpleBazaarAutoSliderState();
}

class _SimpleBazaarAutoSliderState extends State<SimpleBazaarAutoSlider> {
  late ScrollController _scrollController;
  Timer? _timer;
  Timer? _snapTimer;
  int _currentIndex = 0;
  bool _isUserScrolling = false;

  @override
  void initState() {
    super.initState();
    _scrollController = ScrollController();

    // Add scroll listener for manual scrolling detection
    if (widget.snapToItems) {
      _scrollController.addListener(_onScroll);
    }

    // Start scrolling after widget is fully built
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Future.delayed(const Duration(seconds: 1), () {
        if (mounted && widget.items.length > 3) {
          _startAutoScroll();
        }
      });
    });
  }

  void _onScroll() {
    if (_scrollController.position.isScrollingNotifier.value) {
      _isUserScrolling = true;
      _timer?.cancel(); // Stop auto scroll when user is scrolling

      // Cancel previous snap timer
      _snapTimer?.cancel();

      // Start new snap timer
      _snapTimer = Timer(const Duration(milliseconds: 150), () {
        if (mounted && _isUserScrolling) {
          _snapToNearestItem();
          _isUserScrolling = false;
          // Restart auto scroll after snapping
          Future.delayed(const Duration(milliseconds: 500), () {
            if (mounted && widget.items.length > 3) {
              _startAutoScroll();
            }
          });
        }
      });
    }
  }

  void _snapToNearestItem() {
    if (!_scrollController.hasClients) return;

    final double currentScroll = _scrollController.position.pixels;
    final double nearestItemPosition = (currentScroll / widget.itemWidth).round() * widget.itemWidth;

    _scrollController.animateTo(
      nearestItemPosition,
      duration: const Duration(milliseconds: 300),
      curve: Curves.easeOut,
    );
  }

  void _startAutoScroll() {
    _timer?.cancel(); // Cancel existing timer
    _timer = Timer.periodic(widget.scrollInterval, (timer) {
      if (!mounted || !_scrollController.hasClients || _isUserScrolling) return;

      final double maxScroll = _scrollController.position.maxScrollExtent;
      final double currentScroll = _scrollController.position.pixels;

      // Calculate next position
      final double nextPosition = currentScroll + widget.itemWidth;

      if (nextPosition >= maxScroll) {
        // Reset to start
        _scrollController.animateTo(
          0,
          duration: widget.scrollDuration,
          curve: Curves.easeOut,
        );
      } else {
        // Scroll to next item
        _scrollController.animateTo(
          nextPosition,
          duration: widget.scrollDuration,
          curve: Curves.easeOut,
        );
      }
    });
  }

  @override
  void dispose() {
    _timer?.cancel();
    _snapTimer?.cancel();
    if (widget.snapToItems) {
      _scrollController.removeListener(_onScroll);
    }
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (widget.items.isEmpty) {
      return const SizedBox.shrink();
    }

    // Create extended list for smooth infinite scrolling
    final List<Widget> extendedItems = [];
    for (int i = 0; i < 5; i++) {
      // Repeat items 5 times
      extendedItems.addAll(widget.items);
    }

    return ListView.builder(
      controller: _scrollController,
      scrollDirection: Axis.horizontal,
      physics: widget.snapToItems
          ? const ClampingScrollPhysics() // Better for snapping
          : const AlwaysScrollableScrollPhysics(),
      itemCount: extendedItems.length,
      itemBuilder: (context, index) {
        return extendedItems[index];
      },
    );
  }
}
