import 'package:flutter/material.dart';

import '../models/user_model.dart';
import '../services/nfc_service.dart';
import '../utils/constants.dart';
import '../widgets/token_card.dart';

class WalletScreen extends StatefulWidget {
  const WalletScreen({super.key, required this.user});

  final UserModel user;

  @override
  State<WalletScreen> createState() => _WalletScreenState();
}

class _WalletScreenState extends State<WalletScreen> {
  final _nfc = NfcService();
  String _status = 'Pret pour Tap to Pay';

  Future<void> _startNfc() async {
    setState(() => _status = 'Approchez un terminal autorise...');
    await _nfc.startPaymentSession(
      onPayload: (payload) {
        if (mounted) setState(() => _status = payload);
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Wallet NFC')),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          TokenCard(user: widget.user),
          const SizedBox(height: 24),
          Container(
            padding: const EdgeInsets.all(24),
            decoration: BoxDecoration(
              color: AppColors.surface,
              borderRadius: BorderRadius.circular(8),
              border: Border.all(color: AppColors.goldDeep),
            ),
            child: Column(
              children: [
                const Icon(Icons.tap_and_play_rounded, size: 86, color: AppColors.gold),
                const SizedBox(height: 14),
                const Text(
                  'Tap to Pay',
                  style: TextStyle(fontSize: 24, fontWeight: FontWeight.w900),
                ),
                const SizedBox(height: 8),
                Text(
                  _status,
                  textAlign: TextAlign.center,
                  style: const TextStyle(color: AppColors.muted),
                ),
                const SizedBox(height: 18),
                ElevatedButton.icon(
                  onPressed: _startNfc,
                  icon: const Icon(Icons.nfc_rounded),
                  label: const Text('Activer NFC'),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
