import 'package:flutter/material.dart';

class EstadoVehiculoPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    // Aquí debes construir la interfaz para mostrar la lista de estados del vehículo.
    return Scaffold(
      appBar: AppBar(
        title: Text('Estado del Vehículo'),
        //backgroundColor: Colors.lightBlue,
      ),
      body: Center(
        // Agrega aquí la lista de estados del vehículo.
        child: Text('Lista de Estados del Vehículo'),
      ),
    );
  }
}
