import 'dart:async';

import '../models/user_model.dart';
import 'database_service.dart';

class WifiP2pService {
  final _controller = StreamController<List<UserModel>>.broadcast();
  Timer? _timer;

  Stream<List<UserModel>> get nearbyUsers => _controller.stream;

  Future<void> startDiscovery() async {
    await scanOnce();
    _timer?.cancel();
    _timer = Timer.periodic(const Duration(seconds: 4), (_) => scanOnce());
  }

  Future<void> scanOnce() async {
    final users = await DatabaseService.instance.getNearbyUsers();
    _controller.add(users);
  }

  void dispose() {
    _timer?.cancel();
    _controller.close();
  }
}
