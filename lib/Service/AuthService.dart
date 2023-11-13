import 'package:dio/dio.dart';
import 'package:shared_preferences/shared_preferences.dart';
class AuthService {
  final Dio _dio = Dio(); // Instancia de DIO

  Future<Map<String, dynamic>> login(String email, String password) async {
    try {
      final response = await _dio.post(
        'http://18.216.45.210/api/login', // Reemplaza con la URL de tu API
        data: {
          'email': email,
          'password': password,
        },
      );

      if (response.statusCode == 200) {
        print(response);
        return response.data;
      } else {
        print(response);

        // Maneja errores de inicio de sesión aquí
        return {
          'status': false,
          'error': 'Inicio de sesión fallido',
        };
      }
    } catch (e) {
      // Maneja errores de red o excepciones aquí
      print('Error: $e');
      return {
        'status': false,
        'error': 'Error de red',
      };
    }
  }
  Future<bool> isLoggedIn() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.containsKey('token'); // Verifica si hay un token almacenado
  }

  Future<void> logout() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.remove('token'); // Elimina el token al cerrar sesión
  }
}
