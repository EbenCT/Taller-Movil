import 'package:proy1/Service/AuthService.dart';

class AuthController {
  final authService = AuthService();
  // Puedes agregar métodos para manejar la lógica de autenticación y las llamadas a la API aquí.

  Future<Map<String, dynamic>> login(String username, String password) async {
    // Realiza la lógica de autenticación y la llamada a la API aquí.
    // Devuelve true si el inicio de sesión es exitoso, o false en caso contrario.
    return await authService.login(
        username, password); // Simulando un inicio de sesión exitoso.
  }
}
