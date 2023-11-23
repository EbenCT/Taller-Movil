import 'package:dio/dio.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../utils/api_backend.dart';

class AuthService {
  final Dio _dio = Dio(); // Instancia de DIO
  String? _token;
  static int? _userId;
  static int? _clienteId;
 // static int? _vehiculoId;

  Future<Map<String, dynamic>> login(String email, String password) async {
    try {
      final response = await _dio.post(
        'http://$apiBackend/login',
        
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
        'http://$apiBackend/clientes/$_userId/datos',
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
      'http://$apiBackend/vehiculos/$_clienteId/autos',
      options: Options(
        headers: {
          'Authorization': 'Bearer $_token',
        },
      ),
    );
print(response.data);
    if (response.statusCode == 200) {
      //_vehiculoId = response.data[0]['id'];
        print(response.data);
      //  print(_vehiculoId);
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
  Future<Map<String, dynamic>> getPagosByClientId() async {
    print('clienteId: $_clienteId');
  try {
    final response = await _dio.get(
      'http://$apiBackend/pagos-cliente/$_clienteId',
      options: Options(
        headers: {
          'Authorization': 'Bearer $_token',
        },
      ),
    );
    print(response.data);
    if (response.statusCode == 200) {
        print(response.data);
      return {
        'status': true,
        'data': response.data,
      };
    } else {
      return {
        'status': false,
        'error': 'Error al obtener pagos',
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
  Future<Map<String, dynamic>> getOrdenesByClientId() async {
    print('clienteId: $_clienteId');
  try {
    final response = await _dio.get(
      'http://$apiBackend/ordenes-cliente/$_clienteId',
      options: Options(
        headers: {
          'Authorization': 'Bearer $_token',
        },
      ),
    );
    print(response.data);
    if (response.statusCode == 200) {
        print(response.data);
      return {
        'status': true,
        'data': response.data,
      };
    } else {
      return {
        'status': false,
        'error': 'Error al obtener ordenes',
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
