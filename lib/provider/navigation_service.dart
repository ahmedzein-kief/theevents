import 'package:flutter/material.dart';

class NavigationService {
  static final NavigationService _instance = NavigationService._internal();

  factory NavigationService() => _instance;

  NavigationService._internal();

  late BuildContext _rootContext;

  void setContext(BuildContext context) {
    _rootContext = context;
  }

  BuildContext get rootContext => _rootContext;
}
