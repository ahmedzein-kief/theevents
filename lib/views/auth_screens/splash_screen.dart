import 'package:event_app/core/services/shared_preferences_helper.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../core/constants/app_assets.dart';
import '../../core/widgets/bottom_navigation_bar.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashViewState();
}

class _SplashViewState extends State<SplashScreen> {
  Future<void> _checkLoginStatus() async {
    final prefs = await SharedPreferences.getInstance();
    final bool isFirstTime = prefs.getBool('isFirstTime') ?? true;
    final bool isLoggedIn = prefs.getBool(SecurePreferencesUtil.loggedInKey) ?? false;

    // Hold splash screen for 3 seconds
    await Future.delayed(const Duration(seconds: 3));

    if (isFirstTime) {
      await prefs.setBool('isFirstTime', false);
    } else {
      if (!isLoggedIn) {
        await SecurePreferencesUtil.saveToken('');
      }
    }

    // Navigate to home screen
    if (mounted) {
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(
          builder: (_) => const BaseHomeScreen(),
          settings: const RouteSettings(name: '/homeScreen'),
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
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return Scaffold(
      body: Center(
        child: SvgPicture.asset(
          isDark ? AppAssets.eventsDark : AppAssets.events,
          height: 100,
          width: 100,
        ),
      ),
    );
  }
}
