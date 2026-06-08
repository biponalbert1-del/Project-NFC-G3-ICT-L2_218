import 'package:flutter/material.dart';

import '../models/user_model.dart';
import '../services/database_service.dart';
import '../utils/constants.dart';
import '../widgets/custom_button.dart';
import '../widgets/token_card.dart';
import 'terminals_list_screen.dart';
import 'transactions_history.dart';
import 'transfer_screen.dart';
import 'wallet_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key, required this.user});

  final UserModel user;

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  late UserModel _user = widget.user;

  Future<void> _refresh() async {
    final user = await DatabaseService.instance.getCurrentUser();
    if (mounted) setState(() => _user = user);
  }

  Future<void> _open(Widget screen) async {
    await Navigator.of(context).push(MaterialPageRoute(builder: (_) => screen));
    await _refresh();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: const Icon(Icons.menu_rounded),
        title: const Text(AppConstants.appName),
        actions: const [
          Padding(
            padding: EdgeInsets.only(right: 16),
            child: Icon(Icons.notifications_none_rounded),
          ),
        ],
      ),
      body: RefreshIndicator(
        color: AppColors.gold,
        onRefresh: _refresh,
        child: ListView(
          padding: const EdgeInsets.all(16),
          children: [
            TokenCard(user: _user),
            const SizedBox(height: 18),
            Row(
              children: [
                Expanded(
                  child: CustomButton(
                    label: 'Envoyer',
                    icon: Icons.near_me_rounded,
                    onPressed: () => _open(const TransferScreen()),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: CustomButton(
                    label: 'Recevoir',
                    icon: Icons.call_received_rounded,
                    isSecondary: true,
                    onPressed: () => _open(WalletScreen(user: _user)),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 18),
            _HomeTile(
              icon: Icons.history_rounded,
              title: 'Historique des transactions',
              subtitle: 'Voir les transferts valides et recus',
              onTap: () => _open(const TransactionsHistory()),
            ),
            _HomeTile(
              icon: Icons.verified_user_rounded,
              title: 'Terminaux autorises',
              subtitle: 'Controler les points de paiement acceptes',
              onTap: () => _open(const TerminalsListScreen()),
            ),
            _HomeTile(
              icon: Icons.tap_and_play_rounded,
              title: 'Tap to Pay NFC',
              subtitle: 'Paiement instantane vers terminal valide',
              onTap: () => _open(WalletScreen(user: _user)),
            ),
          ],
        ),
      ),
    );
  }
}

class _HomeTile extends StatelessWidget {
  const _HomeTile({
    required this.icon,
    required this.title,
    required this.subtitle,
    required this.onTap,
  });

  final IconData icon;
  final String title;
  final String subtitle;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: AppColors.surfaceSoft),
      ),
      child: ListTile(
        leading: Icon(icon, color: AppColors.gold),
        title: Text(title, style: const TextStyle(fontWeight: FontWeight.w700)),
        subtitle: Text(subtitle),
        trailing: const Icon(Icons.chevron_right_rounded),
        onTap: onTap,
      ),
    );
  }
}
