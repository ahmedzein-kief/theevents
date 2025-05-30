import 'package:flutter/cupertino.dart';

class ScrollableWidget extends StatelessWidget {
  final Widget child;

  const ScrollableWidget({super.key, required this.child});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      physics: BouncingScrollPhysics(),
      scrollDirection: Axis.horizontal,
      child: SingleChildScrollView(
        physics: BouncingScrollPhysics(),
        scrollDirection: Axis.vertical,
        child: child,
      ),
    );
  }
}
