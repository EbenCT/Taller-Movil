import 'package:proy1/Service/AuthService.dart';

class AuthController {
  final authService = AuthService();
  bool isLoggedIn = false;

  Future<void> checkSession() async {
    isLoggedIn = await authService.isLoggedIn();
    print('isLoggedIn: $isLoggedIn');
  }

  Future<Map<String, dynamic>> login(String username, String password) async {
    final response = await authService.login(username, password);

    if (response['status']) {
      print('Inicio de sesión exitoso'); // Añade este mensaje de impresión
      isLoggedIn = true; // Asegúrate de que se actualice después de un inicio de sesión exitoso
    }

    return response;
  }
    Future<void> logout() async {
    await authService.logout();
    isLoggedIn = false;
  }

}

