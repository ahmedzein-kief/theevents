import 'package:event_app/utils/mixins_and_constants/media_query_mixin.dart';
import 'package:flutter/cupertino.dart';

class ResponsiveCenterWrapper extends StatefulWidget {
  final Widget child;

  const ResponsiveCenterWrapper({super.key, required this.child});

  @override
  State<ResponsiveCenterWrapper> createState() => _ResponsiveCenterWrapperState();
}

class _ResponsiveCenterWrapperState extends State<ResponsiveCenterWrapper> with MediaQueryMixin {
  @override
  Widget build(BuildContext context) {
    return Center(
      child: SizedBox(
        width: screenWidth / 5,
        child: widget.child,
      ),
    );
  }
}

class GestureResponsiveCenterWrapper extends StatefulWidget {
  final Widget child;
  final VoidCallback? onTap; // Callback function for the gesture

  const GestureResponsiveCenterWrapper({
    super.key,
    required this.child,
    this.onTap,
  });

  @override
  State<GestureResponsiveCenterWrapper> createState() => _GestureResponsiveCenterWrapperState();
}

class _GestureResponsiveCenterWrapperState extends State<GestureResponsiveCenterWrapper> with MediaQueryMixin {
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: widget.onTap, // Executes the onTap function if provided
      child: Center(
        child: SizedBox(
          width: screenWidth / 5,
          child: widget.child,
        ),
      ),
    );
  }
}
