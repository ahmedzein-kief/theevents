import 'package:flutter/cupertino.dart';

extension ContectExtension on BuildContext {
  double get screenWidth {
    return MediaQuery.of(this).size.width;
  }

  double get screenHeight {
    return MediaQuery.of(this).size.height;
  }

  bool hasFocus() {
    return FocusScope.of(this).hasFocus;
  }

  void unFocus() {
    FocusScope.of(this).unfocus();
  }
}
