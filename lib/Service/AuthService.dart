import 'package:dio/dio.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AuthService {
  final Dio _dio = Dio(); // Instancia de DIO
  String? _token;
  int? _userId;
  int? _clienteId;
  int? _vehiculoId;

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
        await getClientById();
        print('clienteId: $_clienteId');
        await getVehicleByClientId();
        print(response);
        print(_userId);
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

Future<Map<String, dynamic>> getClientById() async {
    try {
      final response = await _dio.get(
        'http://18.216.45.210/api/clientes/$_userId/datos',
        options: Options(
          headers: {
            'Authorization': 'Bearer $_token',
          },
        ),
      );

      if (response.statusCode == 200) {
        _clienteId = response.data['data']['id'];
        print(response);
        print('clienteId: $_clienteId');
        return {         
          'status': true,
          'data': response.data,
        };
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

  Future<Map<String, dynamic>> getVehicleByClientId() async {
    print('clienteId: $_clienteId');
  try {
    final response = await _dio.get(
      'http://18.216.45.210/api/vehiculos/$_clienteId/autos',
      options: Options(
        headers: {
          'Authorization': 'Bearer $_token',
        },
      ),
    );
print(response.data);
    if (response.statusCode == 200) {
        print(response);
        //print(_clienteId);
      return {
        'status': true,
        'data': response.data,
      };
    } else {
      return {
        'status': false,
        'error': 'Error al obtener información del vehiculo',
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

}
