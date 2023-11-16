import 'package:flutter/material.dart';
import 'package:proy1/Service/AuthService.dart';
import 'package:proy1/pages/pagEstado.dart';

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

  Widget _buildDetailRow(String title1, String value1, String title2, String value2) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title1,
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
              SizedBox(height: 5),
              Text(
                value1,
                style: TextStyle(
                  fontSize: 14,
                ),
              ),
            ],
          ),
        ),
        SizedBox(width: 20),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title2,
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
              SizedBox(height: 5),
              Text(
                value2,
                style: TextStyle(
                  fontSize: 14,
                ),
              ),
            ],
          ),
        ),
      ],
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

                return Container(
                  padding: EdgeInsets.all(10),
                  margin: EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    border: Border.all(color: Colors.grey),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      _buildDetailRow(
                        'Placa',
                        vehiculo['placa'],
                        'Número de Chasis',
                        vehiculo['nro_chasis'],
                      ),
                      _buildDetailRow(
                        'Color',
                        vehiculo['color'],
                        'Año',
                        vehiculo['año'].toString(),
                      ),
                      _buildDetailRow(
                        'Marca',
                        vehiculo['marca_nombre'],
                        'Modelo',
                        vehiculo['modelo_nombre'],
                      ),
                      _buildDetailRow(
                        'Tipo',
                        vehiculo['tipoVehiculo_nombre'],
                        '',
                        '',
                      ),
                      SizedBox(height: 10),
                      ElevatedButton(
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => EstadoVehiculoPage(vehiculoId: vehiculo['id']),
                            ),
                          );
                        },
                        child: Text('Ver estado'),
                      ),
                    ],
                  ),
                );
              },
            )
          : Center(child: CircularProgressIndicator()),
    );
  }
}
