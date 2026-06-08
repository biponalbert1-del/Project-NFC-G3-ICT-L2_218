import 'dart:async';

class BlockchainReceipt {
  const BlockchainReceipt({
    required this.operationHash,
    required this.isAccepted,
  });

  final String operationHash;
  final bool isAccepted;
}

class BlockchainService {
  Future<BlockchainReceipt> submitUserOperation({
    required String fromWallet,
    required String toWallet,
    required int amount,
  }) async {
    await Future<void>.delayed(const Duration(milliseconds: 700));
    return BlockchainReceipt(
      operationHash: 'erc4337-${DateTime.now().microsecondsSinceEpoch}',
      isAccepted: amount > 0 && fromWallet != toWallet,
    );
  }
}
