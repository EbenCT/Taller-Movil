import 'package:flutter/material.dart';
import 'package:proy1/Service/AuthService.dart';

class MiVehiculoPage extends StatefulWidget {
  @override
  _MiVehiculoPageState createState() => _MiVehiculoPageState();
}

class _MiVehiculoPageState extends State<MiVehiculoPage> {
  final AuthService _authService = AuthService();
  Map<String, dynamic>? _vehiculoInfo;

  @override
  void initState() {
    super.initState();
    _loadVehiculoInfo();
  }

  Future<void> _loadVehiculoInfo() async {
    final response = await _authService.getVehicleByClientId();

    if (response['status']) {
      setState(() {
        _vehiculoInfo = response;
        print(_vehiculoInfo);
      });
    } else {
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

  Widget _buildDetailRow(String title, String value) {
    return ListTile(
      title: Text(
        title,
        style: TextStyle(
          fontSize: 18,
          fontWeight: FontWeight.bold,
        ),
      ),
      subtitle: Text(value),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Mi Vehículo'),
      ),
      body: _vehiculoInfo != null
          ? ListView.builder(
              itemCount: _vehiculoInfo!['data'].length,
              itemBuilder: (context, index) {
                final vehiculo = _vehiculoInfo!['data'][index];
                Color colorFondo = index.isEven ? Colors.white : const Color.fromARGB(255, 138, 136, 136)!;


                return Container(
                  color: colorFondo,
                  child: Column(
                    children: [
                      _buildDetailRow('Placa', vehiculo['placa']),
                      _buildDetailRow(
                          'Número de Chasis', vehiculo['nro_chasis']),
                      _buildDetailRow('Color', vehiculo['color']),
                      _buildDetailRow('Año', vehiculo['año'].toString()),
                      _buildDetailRow('Marca', vehiculo['marca_nombre']),
                      _buildDetailRow('Modelo', vehiculo['modelo_nombre']),
                      _buildDetailRow(
                          'Tipo', vehiculo['tipoVehiculo_nombre']),
                    ],
                  ),
                );
              },
            )
          : Center(child: CircularProgressIndicator()),
    );
  }
}
