import 'package:perrow_api/packages/perrow_api.dart';

class AuthServiceV2 {
  Future register({
    required String email,
    required String password,
  }) async {
    try {
      final response =
          await DatabaseService.sbClient.auth.signUp(email, password);

      if (response.error != null) {
        // Error
        print('Error: ${response.error?.message}');
      } else {
        // Success
        final session = response.data;
      }
    } catch (e) {
      rethrow;
    }
  }

  Future login({
    required String email,
    required String password,
  }) async {
    try {
      final response = await DatabaseService.sbClient.auth.signIn(
        email: email,
        password: password,
      );

      if (response.error != null) {
        // Error
        print('Error: ${response.error?.message}');
      } else {
        // Success
        final session = response.data;
        return session;
      }
    } catch (e) {
      rethrow;
    }
  }
}
