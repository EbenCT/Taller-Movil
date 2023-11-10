import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class Servicios extends StatelessWidget {
  const Servicios({Key? key});

  @override
  Widget build(BuildContext context) {
    return Inicio();
  }
}

class Inicio extends StatefulWidget {
  const Inicio({Key? key});

  @override
  State<Inicio> createState() => _InicioState();
}

class _InicioState extends State<Inicio> {
  late List<Servicio> servicios = [];

  @override
  void initState() {
    super.initState();
    // Llamada a la función para obtener los servicios
    obtenerServicios();
  }

  Future<void> obtenerServicios() async {
    final response = await http.get(Uri.parse('http://18.216.45.210/api/servicios'));

    if (response.statusCode == 200) {
      // Si la solicitud es exitosa, analiza el JSON
      final List<dynamic> data = json.decode(response.body);
      setState(() {
        servicios = data.map((item) => Servicio.fromJson(item)).toList();
      });
    } else {
      // Si la solicitud no es exitosa, muestra un mensaje de error
      throw Exception('Error al cargar los servicios');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Servicios"),
      ),
      body: servicios != null
          ? ListView(
              padding: EdgeInsets.all(16),
              children: <Widget>[
                for (var servicio in servicios)
                  Column(
                    children: [
                      SizedBox(height: 16),
                      FractionallySizedBox(
                        widthFactor: 0.9,
                        child: ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            primary: Colors.grey[800], // Color gris oscuro
                            onPrimary: Colors.white, // Texto blanco
                            padding: EdgeInsets.all(16),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10),
                            ),
                          ),
                          onPressed: () {
                            // Aquí puedes navegar a la pantalla de detalles del servicio
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) =>
                                    DetallesServicio(servicio),
                              ),
                            );
                          },
                          child: Column(
                            children: <Widget>[
                              Icon(
                                Icons.build_rounded,
                                size: 40,
                              ),
                              Text(
                                servicio.nombre,
                                overflow: TextOverflow.ellipsis,
                                maxLines: 2,
                                textAlign: TextAlign.center,
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
              ],
            )
          : Center(
              child: CircularProgressIndicator(),
            ),
    );
  }
}

class DetallesServicio extends StatelessWidget {
  final Servicio servicio;

  DetallesServicio(this.servicio);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Detalles del servicio"),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              alignment: Alignment.center,
              padding: EdgeInsets.all(16),
              color: Colors.blue,
              child: Text(
                servicio.nombre,
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
            ),
            SizedBox(height: 16),
            Text(
              'Descripción:',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            Text(
              servicio.descripcion,
              style: TextStyle(fontSize: 18),
            ),
            SizedBox(height: 16),
            Text(
              'Precio:',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            Text(
              '\$${servicio.precio.toStringAsFixed(2)}',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: Colors.green,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class Servicio {
  final String nombre;
  final String descripcion;
  final double precio;

  Servicio({
    required this.nombre,
    required this.descripcion,
    required this.precio,
  });

  factory Servicio.fromJson(Map<String, dynamic> json) {
    // Intenta convertir el valor de 'precio' a double
    double parsedPrecio = 0.0;

    if (json['precio'] is num) {
      parsedPrecio = json['precio'].toDouble();
    } else if (json['precio'] is String) {
      try {
        parsedPrecio = double.parse(json['precio']);
      } catch (e) {
        // Error al analizar el precio como double, se deja en 0.0
      }
    }

    return Servicio(
      nombre: json['nombre'],
      descripcion: json['descripcion'],
      precio: parsedPrecio,
    );
  }
}
