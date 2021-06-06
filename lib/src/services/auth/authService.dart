import 'package:perrow_api/packages/perrow_api.dart';
import 'package:perrow_api/src/errors/accountExceptions.dart';
import 'package:supabase/supabase.dart';

class AuthServiceV2 {
  Future<Session?> register({
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
        return session;
      }
    } catch (e) {
      rethrow;
    }
  }

  Future<Session?> login({
    required String email,
    required String password,
  }) async {
    try {
      final response = await DatabaseService.sbClient.auth.signIn(
        email: email,
        password: password,
      );

      if (response.error != null) {
        print('Error: ${response.error?.message}');
        throw InvalidInputException(response.error!.message);
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
