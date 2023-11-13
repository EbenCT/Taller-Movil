import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

// Definición de la clase EstadoVehiculo
class EstadoVehiculo {
  final int id;
  final String estado;
  final String fecha;
  final String descripcion;
  final int vehiculoId;

  EstadoVehiculo({
    required this.id,
    required this.estado,
    required this.fecha,
    required this.descripcion,
    required this.vehiculoId,
  });

  factory EstadoVehiculo.fromJson(Map<String, dynamic> json) {
    return EstadoVehiculo(
      id: json['id'],
      estado: json['estado'],
      fecha: json['fecha'],
      descripcion: json['descripcion'],
      vehiculoId: json['vehiculo_id'],
    );
  }
}

class EstadoVehiculoPage extends StatefulWidget {
  @override
  _EstadoVehiculoPageState createState() => _EstadoVehiculoPageState();
}

class _EstadoVehiculoPageState extends State<EstadoVehiculoPage> {
late List<EstadoVehiculo> estados = [];

  @override
  void initState() {
    super.initState();
    _cargarEstados();
  }

  Future<void> _cargarEstados() async {
    final response = await http.get(Uri.parse('http://18.216.45.210/api/EstadoVehiculo'));

    if (response.statusCode == 200) {
      final List<dynamic> data = json.decode(response.body);
      setState(() {
        estados = data.map((item) => EstadoVehiculo.fromJson(item)).toList();
      });
    } else {
      // Manejar errores de carga de datos
      print('Error al cargar estados del vehículo');
    }
  }

  void _mostrarDetalles(EstadoVehiculo estado) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Detalles del Estado del Vehículo'),
          content: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('ID: ${estado.id}'),
              Text('Estado: ${estado.estado}'),
              Text('Fecha: ${estado.fecha}'),
              Text('Descripción: ${estado.descripcion}'),
              Text('ID del Vehículo: ${estado.vehiculoId}'),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text('Cerrar'),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Estado del Vehículo'),
      ),
      body: estados != null
          ? ListView.builder(
              itemCount: estados.length,
              itemBuilder: (context, index) {
                return ListTile(
                  title: Text(estados[index].estado),
                  subtitle: Text(estados[index].fecha),
                  onTap: () {
                    _mostrarDetalles(estados[index]);
                  },
                );
              },
            )
          : Center(
              child: CircularProgressIndicator(),
            ),
    );
  }
}
