import 'package:flutter/material.dart';

import '../utils/constants.dart';
import '../widgets/custom_button.dart';
import 'splash_screen.dart';

class LoginScreen extends StatelessWidget {
  const LoginScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const Icon(Icons.account_balance_wallet_rounded, color: AppColors.gold, size: 86),
              const SizedBox(height: 18),
              const Text(
                'Portefeuille evenementiel',
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 28, fontWeight: FontWeight.w900),
              ),
              const SizedBox(height: 10),
              const Text(
                'Recharge, paiement NFC, recompenses et transferts proches.',
                textAlign: TextAlign.center,
                style: TextStyle(color: AppColors.muted, fontSize: 16),
              ),
              const SizedBox(height: 34),
              CustomButton(
                label: 'Entrer avec le compte demo',
                icon: Icons.login_rounded,
                onPressed: () => openDemoSession(context),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
