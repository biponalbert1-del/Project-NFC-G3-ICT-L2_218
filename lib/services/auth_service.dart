import '../models/user_model.dart';
import 'database_service.dart';

class AuthService {
  Future<UserModel> loginWithDemoAccount() {
    return DatabaseService.instance.getCurrentUser();
  }
}
