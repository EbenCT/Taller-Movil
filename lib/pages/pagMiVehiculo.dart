import 'package:flutter/material.dart';
import 'package:proy1/Service/AuthService.dart';

class MiVehiculoPage extends StatefulWidget {
  @override
  _MiVehiculoPageState createState() => _MiVehiculoPageState();
}

class _MiVehiculoPageState extends State<MiVehiculoPage> {
  final AuthService _authService = AuthService();
  late Map<String, dynamic> _clienteInfo;
  Map<String, dynamic>? _vehiculoInfo; // Cambio aquí

  @override
  void initState() {
    super.initState();
    _loadClienteInfo();
  }

  Future<void> _loadClienteInfo() async {
    final response = await _authService.getClientById();

    if (response['status']) {
      setState(() {
        _clienteInfo = response;
      });
      _loadVehiculoInfo();
    } else {
      // Maneja el error de obtención del cliente
      showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: Text('Error al obtener información del cliente'),
            content: Text(response['error']),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                child: Text('OK'),
              ),
            ],
          );
        },
      );
    }
  }

  Future<void> _loadVehiculoInfo() async {
    final response = await _authService.getVehicleByClientId(_clienteInfo['id']);

    if (response['status']) {
      setState(() {
        _vehiculoInfo = response;
      });
    } else {
      // Maneja el error de obtención del vehículo
      showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: Text('Error al obtener información del vehículo'),
            content: Text(response['error']),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                child: Text('OK'),
              ),
            ],
          );
        },
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Mi Vehículo'),
      ),
      body: Center(
        child: _vehiculoInfo != null // Cambio aquí
            ? Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text('Placa: ${_vehiculoInfo!['placa']}'),
                  Text('Número de Chasis: ${_vehiculoInfo!['nro_chasis']}'),
                  Text('Color: ${_vehiculoInfo!['color']}'),
                  Text('Año: ${_vehiculoInfo!['año']}'),
                  // Agrega más widgets para mostrar otros detalles del vehículo
                ],
              )
            : CircularProgressIndicator(),
      ),
    );
  }
}
