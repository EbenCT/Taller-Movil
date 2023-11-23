import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import '../utils/api_backend.dart';
class EstadoVehiculoPage extends StatefulWidget {
  final int vehiculoId;

  EstadoVehiculoPage({required this.vehiculoId});

  @override
  _EstadoVehiculoPageState createState() => _EstadoVehiculoPageState();
}

class _EstadoVehiculoPageState extends State<EstadoVehiculoPage> {
  final Dio _dio = Dio(); // Instancia de Dio para hacer peticiones HTTP
  List<dynamic> _estados = [];

  @override
  void initState() {
    super.initState();
    _fetchEstadoData();
  }

  Future<void> _fetchEstadoData() async {
    try {
      final response = await _dio.get(
        'http://$apiBackend/estado_vehiculo/${widget.vehiculoId}/estados',
      );

      if (response.statusCode == 200) {
        setState(() {
          _estados = response.data;
        });
      } else {
        // Manejar errores si la solicitud no es exitosa (código de estado diferente de 200)
        print('Error al cargar datos');
      }
    } catch (e) {
      // Manejar errores de red
      print('Error de red: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Estado del Vehículo'),
      ),
      body: _estados.isNotEmpty
          ? ListView.builder(
              itemCount: _estados.length,
              itemBuilder: (context, index) {
                final estado = _estados[index];
                return Card(
                  margin: EdgeInsets.all(8.0),
                  child: ListTile(
                    title: Text('Estado: ${estado['estado']}'),
                    subtitle: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('Fecha: ${estado['fecha']}'),
                        Text('Descripción: ${estado['descripcion']}'),
                        Text('ID del vehículo: ${estado['vehiculo_id']}'),
                      ],
                    ),
                  ),
                );
              },
            )
          : Center(
              child: CircularProgressIndicator(),
            ),
    );
  }
}
