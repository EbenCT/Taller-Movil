import 'package:flutter/material.dart';

class Servicios extends StatelessWidget {
  const Servicios({super.key});

  @override
  Widget build(BuildContext context) {
    return Inicio();
  }
}

class Inicio extends StatefulWidget {
  const Inicio({super.key});

  @override
  State<Inicio> createState() => _InicioState();
}

class _InicioState extends State<Inicio> {
  final List<String> servicios = ["Mantenimiento", "Remolque en Carretera", "Inspeccion Tecnica", "Auxilio", "Motocicleta", "Electronica Motriz"];
  final List<IconData> iconos = [Icons.build_rounded, Icons.add_road_outlined, 
                                 Icons.airport_shuttle_rounded, Icons.car_crash_rounded,
                                 Icons.delivery_dining_rounded ,Icons.electric_car_rounded,]; // Lista de íconos

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Servicios"),
      ),
      body: ListView(
        children: <Widget>[
          for (var i = 0; i < servicios.length; i += 2)
            Column(
              children: <Widget>[
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: <Widget>[
                    for (var j = i; j < i + 2 && j < servicios.length; j++)
                      ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          minimumSize: Size(160, 160), // Tamaño fijo para los botones
                          padding: EdgeInsets.all(10),
                        ),
                        child: Column(
                          children: <Widget>[
                            Icon(iconos[j],size: 40,),
                            Text(
                              servicios[j],
                              overflow: TextOverflow.ellipsis, // Mostrar "..." si el texto es demasiado largo
                              maxLines: 2, // Limitar el número de líneas mostradas
                              textAlign: TextAlign.center, // Centrar el texto
                            ),
                          ],
                        ),
                        onPressed: () {
                          print("Prueba para ${servicios[j]}");
                        },
                      ),
                  ],
                ),
                SizedBox(height: 16), // Agrega espacio vertical entre filas
              ],
            ),
        ],
      ),
    );
  }
}