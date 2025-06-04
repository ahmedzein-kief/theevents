import 'package:event_app/core/helper/mixins/media_query_mixin.dart';
import 'package:flutter/cupertino.dart';

class ResponsiveCenterWrapper extends StatefulWidget {
  const ResponsiveCenterWrapper({super.key, required this.child});
  final Widget child;

  @override
  State<ResponsiveCenterWrapper> createState() =>
      _ResponsiveCenterWrapperState();
}

class _ResponsiveCenterWrapperState extends State<ResponsiveCenterWrapper>
    with MediaQueryMixin {
  @override
  Widget build(BuildContext context) => Center(
        child: SizedBox(
          width: screenWidth / 5,
          child: widget.child,
        ),
      );
}

class GestureResponsiveCenterWrapper extends StatefulWidget {
  // Callback function for the gesture

  const GestureResponsiveCenterWrapper({
    super.key,
    required this.child,
    this.onTap,
  });
  final Widget child;
  final VoidCallback? onTap;

  @override
  State<GestureResponsiveCenterWrapper> createState() =>
      _GestureResponsiveCenterWrapperState();
}

class _GestureResponsiveCenterWrapperState
    extends State<GestureResponsiveCenterWrapper> with MediaQueryMixin {
  @override
  Widget build(BuildContext context) => GestureDetector(
        onTap: widget.onTap, // Executes the onTap function if provided
        child: Center(
          child: SizedBox(
            width: screenWidth / 5,
            child: widget.child,
          ),
        ),
      );
}
