import 'package:dio/dio.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AuthService {
  final Dio _dio = Dio(); // Instancia de DIO
  String? _token;
  int? _userId;

  Future<Map<String, dynamic>> login(String email, String password) async {
    try {
      final response = await _dio.post(
        'http://18.216.45.210/api/login',
        data: {
          'email': email,
          'password': password,
        },
      );

      if (response.statusCode == 200) {
        _token = response.data['token'];
        _userId = response.data['usuario']['id'];
        
        print(response);
        return response.data;
      } else {
        print(response);
        return {
          'status': false,
          'error': 'Inicio de sesión fallido',
        };
      }
    } catch (e) {
      print('Error: $e');
      return {
        'status': false,
        'error': 'Error de red',
      };
    }
  }

  Future<bool> isLoggedIn() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.containsKey('token');
  }

  Future<void> logout() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.remove('token');
  }

  Future<Map<String, dynamic>> getMyClient() async {
    try {
      final response = await _dio.get(
        'http://18.216.45.210/api/clientes',
        options: Options(
          headers: {
            'Authorization': 'Bearer $_token',
          },
        ),
      );

      if (response.statusCode == 200) {
        List<dynamic> clients = response.data['data'];
        Map<String, dynamic>? client = clients.firstWhere(
          (c) => c['usuario_id'] == _userId,
          orElse: () => null,
        );

        if (client != null) {
          return {
            'status': true,
            'data': client,
          };
        } else {
          return {
            'status': false,
            'error': 'Cliente no encontrado para el usuario',
          };
        }
      } else {
        return {
          'status': false,
          'error': 'Error al obtener información del cliente',
        };
      }
    } catch (e) {
      print('Error: $e');
      return {
        'status': false,
        'error': 'Error de red',
      };
    }
  }
  Future<Map<String, dynamic>> getVehicleByClientId(int clientId) async {
  try {
    final response = await _dio.get(
      'http://18.216.45.210/api/vehiculos', // Reemplaza con la URL de tu API
      options: Options(
        headers: {
          'Authorization': 'Bearer $_token',
        },
      ),
    );

    if (response.statusCode == 200) {
      // Busca el vehículo correspondiente al cliente
      List<dynamic> vehicles = response.data['data'];
      Map<String, dynamic>? vehicle = vehicles.firstWhere(
        (v) => v['cliente_id'] == clientId,
        orElse: () => null,
      );

      if (vehicle != null) {
        return {
          'status': true,
          'data': vehicle,
        };
      } else {
        return {
          'status': false,
          'error': 'Vehículo no encontrado para el cliente',
        };
      }
    } else {
      // Maneja errores de obtención del vehículo aquí
      return {
        'status': false,
        'error': 'Error al obtener información del vehículo',
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
}
