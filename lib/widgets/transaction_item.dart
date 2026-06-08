import 'package:flutter/material.dart';

import '../models/transaction_model.dart';
import '../utils/constants.dart';
import '../utils/helpers.dart';

class TransactionItem extends StatelessWidget {
  const TransactionItem({super.key, required this.transaction});

  final TransactionModel transaction;

  @override
  Widget build(BuildContext context) {
    return ListTile(
      contentPadding: const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
      leading: CircleAvatar(
        backgroundColor: AppColors.gold.withValues(alpha: 0.18),
        child: const Icon(Icons.swap_horiz_rounded, color: AppColors.gold),
      ),
      title: Text('${formatTokens(transaction.amount)} ${AppConstants.tokenSymbol}'),
      subtitle: Text(formatDate(transaction.createdAt)),
      trailing: Chip(
        label: Text(transaction.status.name),
        side: BorderSide.none,
        backgroundColor: AppColors.success.withValues(alpha: 0.18),
        labelStyle: const TextStyle(color: AppColors.success),
      ),
    );
  }
}
