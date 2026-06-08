import 'package:flutter/material.dart';

import '../models/user_model.dart';
import '../utils/constants.dart';
import '../utils/helpers.dart';

class TokenCard extends StatelessWidget {
  const TokenCard({super.key, required this.user});

  final UserModel user;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(22),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(8),
        gradient: const LinearGradient(
          colors: [Color(0xFFE9D7AF), Color(0xFF9C8B72)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
      ),
      child: Column(
        children: [
          const Text('Main balance', style: TextStyle(color: Colors.black87)),
          Text(
            '${formatTokens(user.balance)} ${AppConstants.tokenSymbol}',
            style: const TextStyle(
              color: Colors.black,
              fontSize: 30,
              fontWeight: FontWeight.w900,
            ),
          ),
          const SizedBox(height: 18),
          Container(
            width: 104,
            height: 104,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: AppColors.gold,
              boxShadow: [
                BoxShadow(
                  color: AppColors.gold.withValues(alpha: 0.45),
                  blurRadius: 32,
                  spreadRadius: 3,
                ),
              ],
              border: Border.all(color: AppColors.cream, width: 3),
            ),
            child: const Icon(Icons.token_rounded, color: AppColors.goldDeep, size: 56),
          ),
          const SizedBox(height: 12),
          Text(
            user.walletAddress,
            style: const TextStyle(color: Colors.black87, fontWeight: FontWeight.w600),
          ),
        ],
      ),
    );
  }
}
