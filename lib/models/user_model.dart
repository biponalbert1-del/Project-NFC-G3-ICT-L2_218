class UserModel {
  const UserModel({
    required this.id,
    required this.name,
    required this.phone,
    required this.walletAddress,
    required this.balance,
    required this.isNearby,
  });

  final String id;
  final String name;
  final String phone;
  final String walletAddress;
  final int balance;
  final bool isNearby;

  factory UserModel.fromMap(Map<String, Object?> map) {
    return UserModel(
      id: map['id'] as String,
      name: map['name'] as String,
      phone: map['phone'] as String,
      walletAddress: map['wallet_address'] as String,
      balance: map['balance'] as int,
      isNearby: (map['is_nearby'] as int) == 1,
    );
  }

  Map<String, Object?> toMap() {
    return {
      'id': id,
      'name': name,
      'phone': phone,
      'wallet_address': walletAddress,
      'balance': balance,
      'is_nearby': isNearby ? 1 : 0,
    };
  }

  UserModel copyWith({int? balance, bool? isNearby}) {
    return UserModel(
      id: id,
      name: name,
      phone: phone,
      walletAddress: walletAddress,
      balance: balance ?? this.balance,
      isNearby: isNearby ?? this.isNearby,
    );
  }
}
