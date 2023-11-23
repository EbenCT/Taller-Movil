import 'package:flutter/material.dart';
import 'package:proy1/Service/AuthService.dart';

class PagosPage extends StatefulWidget {
  @override
  State<PagosPage> createState() => _PagosPageState();
}

class _PagosPageState extends State<PagosPage> {
  final AuthService _authService = AuthService();
  Map<String, dynamic>? _pagos;

  @override
  void initState() {
    super.initState();
    _obtenerPagos();
  }

  Future<void> _obtenerPagos() async {
    final pagosData = await _authService.getPagosByClientId();
    
    setState(() {
      _pagos = pagosData != null
          ? Map.fromIterable(
              pagosData['data']['pagos'],
              key: (pago) => pagosData['data']['pagos'].indexOf(pago).toString(),
              value: (pago) => pago,
            )
          : null;
    });
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

  Future<void> _mostrarDetallesFactura(dynamic factura) async {
    return showDialog<void>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Detalles de la Factura'),
          content: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              _buildDetailRow('ID:', factura['id'].toString(), 'Fecha de Emisión:', factura['fecha_emision']),
              _buildDetailRow('Detalle:', factura['detalle'], 'Importe:', factura['importe'].toString()),
              _buildDetailRow('Saldo:', factura['saldo'].toString(), 'Monto Total:', factura['monto_total'].toString()),
            ],
          ),
          actions: <Widget>[
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
        title: Text('Pagos'),
      ),
      body: _pagos != null
          ? ListView.builder(
              itemCount: _pagos!.length,
              itemBuilder: (context, index) {
                final pago = _pagos!['$index'];

                return GestureDetector(
                  onTap: () {
                    _mostrarDetallesFactura(pago['factura']);
                  },
                  child: Container(
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
                          pago['id'].toString(),
                          'Fecha:',
                          pago['fecha'],
                        ),
                        _buildDetailRow(
                          'Monto:',
                          pago['monto'].toString(),
                          'Concepto:',
                          pago['concepto'],
                        ),
                        _buildDetailRow(
                          'Factura ID:',
                          pago['factura_id'].toString(),
                          'Estado:',
                          pago['estado']== false ? 'PENDIENTE' : 'PAGADO',
                        ),
                        SizedBox(height: 10),
                        ElevatedButton(
                          onPressed: () {
                            _mostrarDetallesFactura(pago['factura']);
                          },
                          child: Text('Ver Factura'),
                        ),
                      ],
                    ),
                  ),
                );
              },
            )
          : Center(child: CircularProgressIndicator()),
    );
  }
}
