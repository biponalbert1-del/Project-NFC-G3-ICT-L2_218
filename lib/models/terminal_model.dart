class TerminalModel {
  const TerminalModel({
    required this.id,
    required this.name,
    required this.service,
    required this.walletAddress,
    required this.isAuthorized,
  });

  final String id;
  final String name;
  final String service;
  final String walletAddress;
  final bool isAuthorized;

  factory TerminalModel.fromMap(Map<String, Object?> map) {
    return TerminalModel(
      id: map['id'] as String,
      name: map['name'] as String,
      service: map['service'] as String,
      walletAddress: map['wallet_address'] as String,
      isAuthorized: (map['is_authorized'] as int) == 1,
    );
  }

  Map<String, Object?> toMap() {
    return {
      'id': id,
      'name': name,
      'service': service,
      'wallet_address': walletAddress,
      'is_authorized': isAuthorized ? 1 : 0,
    };
  }
}
