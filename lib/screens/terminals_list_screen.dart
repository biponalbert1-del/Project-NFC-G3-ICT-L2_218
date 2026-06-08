import 'package:flutter/material.dart';

import '../models/terminal_model.dart';
import '../services/database_service.dart';
import '../utils/constants.dart';

class TerminalsListScreen extends StatefulWidget {
  const TerminalsListScreen({super.key});

  @override
  State<TerminalsListScreen> createState() => _TerminalsListScreenState();
}

class _TerminalsListScreenState extends State<TerminalsListScreen> {
  late Future<List<TerminalModel>> _terminals;

  @override
  void initState() {
    super.initState();
    _terminals = DatabaseService.instance.getTerminals();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Terminaux')),
      body: FutureBuilder<List<TerminalModel>>(
        future: _terminals,
        builder: (context, snapshot) {
          if (snapshot.connectionState != ConnectionState.done) {
            return const Center(child: CircularProgressIndicator(color: AppColors.gold));
          }
          final terminals = snapshot.data ?? [];
          return ListView.builder(
            padding: const EdgeInsets.all(16),
            itemCount: terminals.length,
            itemBuilder: (_, index) {
              final terminal = terminals[index];
              return Container(
                margin: const EdgeInsets.only(bottom: 12),
                decoration: BoxDecoration(
                  color: AppColors.surface,
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(
                    color: terminal.isAuthorized ? AppColors.success : AppColors.danger,
                  ),
                ),
                child: ListTile(
                  leading: Icon(
                    terminal.isAuthorized
                        ? Icons.verified_rounded
                        : Icons.report_gmailerrorred_rounded,
                    color: terminal.isAuthorized ? AppColors.success : AppColors.danger,
                  ),
                  title: Text(terminal.name),
                  subtitle: Text('${terminal.service}\n${terminal.walletAddress}'),
                  isThreeLine: true,
                  trailing: Text(
                    terminal.isAuthorized ? 'Autorise' : 'Bloque',
                    style: TextStyle(
                      color: terminal.isAuthorized ? AppColors.success : AppColors.danger,
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }
}
