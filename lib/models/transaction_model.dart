enum TransactionStatus { pending, completed, rejected }

class TransactionModel {
  const TransactionModel({
    required this.id,
    required this.senderId,
    required this.receiverId,
    required this.amount,
    required this.createdAt,
    required this.status,
    required this.channel,
  });

  final String id;
  final String senderId;
  final String receiverId;
  final int amount;
  final DateTime createdAt;
  final TransactionStatus status;
  final String channel;

  factory TransactionModel.fromMap(Map<String, Object?> map) {
    return TransactionModel(
      id: map['id'] as String,
      senderId: map['sender_id'] as String,
      receiverId: map['receiver_id'] as String,
      amount: map['amount'] as int,
      createdAt: DateTime.parse(map['created_at'] as String),
      status: TransactionStatus.values.firstWhere(
        (item) => item.name == map['status'],
        orElse: () => TransactionStatus.pending,
      ),
      channel: map['channel'] as String,
    );
  }

  Map<String, Object?> toMap() {
    return {
      'id': id,
      'sender_id': senderId,
      'receiver_id': receiverId,
      'amount': amount,
      'created_at': createdAt.toIso8601String(),
      'status': status.name,
      'channel': channel,
    };
  }
}
