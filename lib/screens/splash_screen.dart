import 'package:flutter/material.dart';
import 'dart:async';

import '../services/auth_service.dart';
import '../utils/constants.dart';
import 'home_screen.dart';
import 'login_screen.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  Timer? _timer;

  @override
  void initState() {
    super.initState();
    _boot();
  }

  void _boot() {
    _timer = Timer(const Duration(milliseconds: 900), () {
      if (!mounted) return;
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(builder: (_) => const LoginScreen()),
      );
    });
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(Icons.nfc_rounded, size: 74, color: AppColors.gold),
            SizedBox(height: 18),
            Text(
              AppConstants.appName,
              style: TextStyle(
                color: AppColors.cream,
                fontSize: 22,
                fontWeight: FontWeight.w800,
              ),
            ),
            SizedBox(height: 24),
            CircularProgressIndicator(color: AppColors.gold),
          ],
        ),
      ),
    );
  }
}

Future<void> openDemoSession(BuildContext context) async {
  final user = await AuthService().loginWithDemoAccount();
  if (!context.mounted) return;
  Navigator.of(context).pushReplacement(
    MaterialPageRoute(builder: (_) => HomeScreen(user: user)),
  );
}
