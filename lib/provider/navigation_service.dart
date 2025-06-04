import 'package:flutter/material.dart';

class NavigationService {
  factory NavigationService() => _instance;

  NavigationService._internal();
  static final NavigationService _instance = NavigationService._internal();

  late BuildContext _rootContext;

  void setContext(BuildContext context) {
    _rootContext = context;
  }

  BuildContext get rootContext => _rootContext;
}
