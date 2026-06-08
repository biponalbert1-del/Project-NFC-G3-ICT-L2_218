import 'dart:async';

import 'package:flutter/material.dart';
import 'package:uuid/uuid.dart';

import '../models/transaction_model.dart';
import '../models/user_model.dart';
import '../services/blockchain_service.dart';
import '../services/database_service.dart';
import '../services/wifi_p2p_service.dart';
import '../utils/constants.dart';
import '../widgets/custom_button.dart';

class TransferScreen extends StatefulWidget {
  const TransferScreen({super.key});

  @override
  State<TransferScreen> createState() => _TransferScreenState();
}

class _TransferScreenState extends State<TransferScreen> {
  final _discovery = WifiP2pService();
  final _amountController = TextEditingController();
  final _blockchain = BlockchainService();
  StreamSubscription<List<UserModel>>? _subscription;
  List<UserModel> _nearbyUsers = [];
  UserModel? _selected;
  bool _isSending = false;

  @override
  void initState() {
    super.initState();
    _subscription = _discovery.nearbyUsers.listen((users) {
      if (mounted) {
        setState(() {
          _nearbyUsers = users;
          _selected ??= users.isNotEmpty ? users.first : null;
        });
      }
    });
    _discovery.startDiscovery();
  }

  @override
  void dispose() {
    _subscription?.cancel();
    _discovery.dispose();
    _amountController.dispose();
    super.dispose();
  }

  Future<void> _send() async {
    final receiver = _selected;
    final amount = int.tryParse(_amountController.text.trim());
    if (receiver == null || amount == null || amount <= 0) {
      _show('Selectionnez un utilisateur et un montant valide.');
      return;
    }

    setState(() => _isSending = true);
    try {
      final sender = await DatabaseService.instance.getCurrentUser();
      final receipt = await _blockchain.submitUserOperation(
        fromWallet: sender.walletAddress,
        toWallet: receiver.walletAddress,
        amount: amount,
      );
      if (!receipt.isAccepted) {
        throw Exception('Operation ERC-4337 refusee.');
      }

      await DatabaseService.instance.transferTokens(
        senderId: sender.id,
        receiverId: receiver.id,
        amount: amount,
      );
      await DatabaseService.instance.saveTransaction(
        TransactionModel(
          id: const Uuid().v4(),
          senderId: sender.id,
          receiverId: receiver.id,
          amount: amount,
          createdAt: DateTime.now(),
          status: TransactionStatus.completed,
          channel: 'BLE/WIFI + ERC-4337',
        ),
      );
      _amountController.clear();
      _show('Transfert confirme: ${receipt.operationHash}');
    } catch (error) {
      _show(error.toString().replaceFirst('Exception: ', ''));
    } finally {
      if (mounted) setState(() => _isSending = false);
    }
  }

  void _show(String message) {
    if (!mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(message)));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Transfert proche')),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          const _RadarPanel(),
          const SizedBox(height: 18),
          const Text(
            'Utilisateurs proches',
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.w800),
          ),
          const SizedBox(height: 10),
          ..._nearbyUsers.map(
            (user) => _NearbyUserTile(
              user: user,
              selected: user.id == _selected?.id,
              onTap: () => setState(() => _selected = user),
            ),
          ),
          const SizedBox(height: 18),
          TextField(
            controller: _amountController,
            keyboardType: TextInputType.number,
            style: const TextStyle(fontSize: 28, color: AppColors.gold),
            decoration: const InputDecoration(
              labelText: 'Nombre de jetons a envoyer',
              prefixIcon: Icon(Icons.token_rounded),
            ),
          ),
          const SizedBox(height: 16),
          CustomButton(
            label: _isSending ? 'Transfert en cours...' : 'Confirmer le transfert',
            icon: Icons.check_circle_rounded,
            onPressed: _isSending ? null : _send,
          ),
        ],
      ),
    );
  }
}

class _RadarPanel extends StatelessWidget {
  const _RadarPanel();

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: AppColors.goldDeep),
      ),
      child: Column(
        children: [
          const Text(
            'DETECTION EN COURS...',
            style: TextStyle(color: AppColors.gold, fontWeight: FontWeight.w900),
          ),
          const SizedBox(height: 8),
          const Text('Maintenez a moins de 4cm'),
          const SizedBox(height: 22),
          SizedBox(
            width: 180,
            height: 180,
            child: Stack(
              fit: StackFit.expand,
              children: [
                for (final size in [180.0, 136.0, 92.0])
                  Center(
                    child: Container(
                      width: size,
                      height: size,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        border: Border.all(color: AppColors.gold.withValues(alpha: 0.35)),
                      ),
                    ),
                  ),
                const Center(
                  child: CircleAvatar(
                    radius: 42,
                    backgroundColor: AppColors.background,
                    child: Icon(Icons.bluetooth_connected_rounded, color: AppColors.gold, size: 38),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _NearbyUserTile extends StatelessWidget {
  const _NearbyUserTile({
    required this.user,
    required this.selected,
    required this.onTap,
  });

  final UserModel user;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      decoration: BoxDecoration(
        color: selected ? AppColors.gold.withValues(alpha: 0.16) : AppColors.surface,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: selected ? AppColors.gold : AppColors.surfaceSoft),
      ),
      child: ListTile(
        leading: CircleAvatar(
          backgroundColor: AppColors.goldDeep,
          child: Text(user.name.substring(0, 1), style: const TextStyle(color: Colors.white)),
        ),
        title: Text(user.name),
        subtitle: const Text('BLE/Wi-Fi - connexion detectee'),
        trailing: Icon(
          selected ? Icons.radio_button_checked : Icons.radio_button_unchecked,
          color: AppColors.gold,
        ),
        onTap: onTap,
      ),
    );
  }
}
