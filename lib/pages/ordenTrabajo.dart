import 'package:flutter/material.dart';
import 'package:proy1/Service/AuthService.dart';

class OrdenesTrabajoPage extends StatefulWidget {
  @override
  State<OrdenesTrabajoPage> createState() => _OrdenesTrabajoPageState();
}

class _OrdenesTrabajoPageState extends State<OrdenesTrabajoPage> {
  final AuthService _authService = AuthService();
  Map<String, dynamic>? _ordenes; // Utilizar un mapa para almacenar los datos de las órdenes

  @override
  void initState() {
    super.initState();
    _obtenerOrdenes();
  }

  Future<void> _obtenerOrdenes() async {
    final ordenesData = await _authService.getOrdenesByClientId();
    print(ordenesData);
    setState(() {
      _ordenes = ordenesData != null
          ? Map.fromIterable(
              ordenesData['data']['ordenes'],
              key: (orden) => ordenesData['data']['ordenes'].indexOf(orden).toString(),
              value: (orden) => orden,
            )
          : null;

      print(_ordenes); // Asignar el mapa directamente a _ordenes
    });
  }

Widget _buildDetailRow(
  String title1,
  String value1,
  String title2,
  String value2,
) {
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
        title: Text('Órdenes de Trabajo'),
      ),
      body: _ordenes != null
          ? ListView.builder(
              itemCount: _ordenes!.length,
              itemBuilder: (context, index) {
                final orden = _ordenes!['$index'];

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
                        'ID:',
                        orden['id'].toString(),
                        'Fecha de Creación:',
                        orden['fecha_creacion'],
                      ),
                      _buildDetailRow(
                        'Fecha de Inicio:',
                        orden['fecha_inicio'],
                        'Fecha de Fin:',
                        orden['fecha_fin'],
                      ),
                      _buildDetailRow(
                        'Estado:',
                        orden['estado'],
                        'Mecánico Asignado:',
                        orden['empleado']['nombre'],
                      ),
                      _buildDetailRow(
                        'Pago:',
                        orden['pago_id'] == null ? 'PENDIENTE' : 'PAGADO',
                        'Observaciones:',
                        orden['descripcion'],
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
