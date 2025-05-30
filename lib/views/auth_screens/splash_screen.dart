import 'package:event_app/utils/storage/shared_preferences_helper.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../navigation/bottom_navigation_bar.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashViewState();
}

class _SplashViewState extends State<SplashScreen> {
  Future<void> _checkLoginStatus() async {
    final prefs = await SharedPreferences.getInstance();
    final bool isFirstTime = prefs.getBool('isFirstTime') ?? true;
    final bool isLoggedIn = prefs.getBool(SharedPreferencesUtil.loggedInKey) ?? false;

    // Hold splash screen for 3 seconds
    await Future.delayed(const Duration(seconds: 3));

    if (isFirstTime) {
      await prefs.setBool('isFirstTime', false);
    } else {
      if (!isLoggedIn) {
        await SharedPreferencesUtil.saveToken("");
      }
    }

    // Navigate to home screen
    if (mounted) {
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(
          builder: (_) => BaseHomeScreen(),
          settings: RouteSettings(name: '/homeScreen'),
        ),
      );
    }
  }

  @override
  void initState() {
    super.initState();
    _checkLoginStatus();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Image(
          height: 100,
          width: 100,
          filterQuality: FilterQuality.low,
          image: AssetImage("assets/logoApp.png"),
        ),
      ),
    );
  }
}
