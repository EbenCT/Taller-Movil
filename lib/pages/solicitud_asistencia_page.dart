import 'package:flutter/material.dart';
import 'package:proy1/controller/solicitud_asistencia_controller.dart';
import 'package:proy1/model/solicitud_asistencia.dart';
import 'package:proy1/pages/solicitud_asistencia_create_page.dart';

class SolicitudAsistenciaPage extends StatefulWidget {
  const SolicitudAsistenciaPage({super.key});

  @override
  State<SolicitudAsistenciaPage> createState() =>
      _SolicitudAsistenciaPageState();
}

class _SolicitudAsistenciaPageState extends State<SolicitudAsistenciaPage> {
  final SolicitudAsistenciaController _con = SolicitudAsistenciaController();

  @override
  Widget build(BuildContext context) {
    List<SolicitudAsistencia>? assistanceRequest;

    final Future<List<SolicitudAsistencia>?> requests =
        Future<List<SolicitudAsistencia>?>.delayed(
      const Duration(seconds: 2),
      () {
        assistanceRequest = _con.assistanceRequest;
        return assistanceRequest;
      },
    );

    return Scaffold(
      appBar: AppBar(
        actions: [
          Padding(
            padding:
                const EdgeInsets.symmetric(vertical: 10.0, horizontal: 10.0),
            child: ElevatedButton(
              style: ButtonStyle(
                shape: MaterialStateProperty.all(
                  RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
              ),
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const SolicitudAsistenciaCreatePage(),
                  ),
                );
              },
              child: const Row(
                children: [
                  Icon(Icons.assignment_add),
                  SizedBox(width: 8.0), // Espacio entre el icono y el texto
                  Text('Crear'),
                ],
              ),
            ),
          ),
        ],
        title: const Text('Mis Solicitudes'),
      ),
      body: FutureBuilder<List<SolicitudAsistencia>?>(
        future: requests,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return const Center(
              child: Text(
                'Error al cargar las solicitudes',
                style: TextStyle(fontSize: 16.0),
              ),
            );
          } else if (snapshot.data == null || snapshot.data!.isEmpty) {
            return const Center(
              child: Text(
                'No hay solicitudes disponibles.',
                style: TextStyle(fontSize: 16.0),
              ),
            );
          } else {
            return ListView.builder(
              itemCount: snapshot.data!.length,
              itemBuilder: (context, index) {
                return _card(snapshot.data![index], index);
              },
            );
          }
        },
      ),
    );
  }

  Widget _card(SolicitudAsistencia? request, index) {
    return GestureDetector(
      onTap: () {
        // _con.openBottomSheet(order);
      },
      child: Container(
        height: 220,
        margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 5),
        child: Card(
          elevation: 3.0,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(15),
          ),
          child: Stack(
            children: [
              Positioned(
                child: Container(
                  height: 30,
                  width: MediaQuery.of(context).size.width * 1,
                  decoration: BoxDecoration(
                    // color: MyColors.primaryColor,
                    borderRadius: const BorderRadius.only(
                      topLeft: Radius.circular(15),
                      topRight: Radius.circular(15),
                    ),
                  ),
                  child: Container(
                    width: double.infinity,
                    alignment: Alignment.center,
                    child: Text(
                      'Solicitud #${index + 1}',
                      style: const TextStyle(
                          fontSize: 15,
                          color: Colors.white,
                          fontFamily: 'NimbusSans'),
                    ),
                  ),
                ),
              ),
              Container(
                alignment: Alignment.center,
                margin: const EdgeInsets.only(top: 10),
                height: 200,
                width: double.infinity,
                child: Row(
                  children: [
                    Container(
                      margin: const EdgeInsets.only(left: 15),
                      height: 100,
                      width: 100,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(15),
                      ),
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(15),
                        child: FadeInImage(
                          placeholder: const AssetImage(
                              'assets/img/placeholder-image.png'),
                          image: AssetImage('assets/img/placeholder-image.png'),
                          // image: NetworkImage('$_url${request?.imagen}'),
                          fadeInDuration: const Duration(milliseconds: 200),
                          fit: BoxFit.cover,
                        ),
                      ),
                    ),
                    Container(
                      margin: const EdgeInsets.only(top: 10, left: 10),
                      width: 200,
                      height: 200,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Container(
                            alignment: Alignment.centerLeft,
                            margin: const EdgeInsets.symmetric(
                                vertical: 3, horizontal: 4),
                            width: double.infinity,
                            child: Wrap(
                              children: [
                                const Text(
                                  'Descripción del problema: ',
                                  style: TextStyle(
                                      fontSize: 13,
                                      fontWeight: FontWeight.bold),
                                ),
                                Text(
                                  '${request?.descripcionProblema}',
                                  style: const TextStyle(fontSize: 13),
                                  maxLines: 3,
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ],
                            ),
                          ),
                          Container(
                            alignment: Alignment.centerLeft,
                            width: double.infinity,
                            margin: const EdgeInsets.symmetric(
                                vertical: 3, horizontal: 4),
                            child: Row(
                              children: [
                                const Text(
                                  'Latitud: ',
                                  style: TextStyle(
                                      fontSize: 13,
                                      fontWeight: FontWeight.bold),
                                ),
                                Text(
                                  '${request?.latitud}',
                                  style: const TextStyle(fontSize: 13),
                                ),
                              ],
                            ),
                          ),
                          Container(
                            alignment: Alignment.centerLeft,
                            width: double.infinity,
                            margin: const EdgeInsets.symmetric(
                                vertical: 3, horizontal: 4),
                            child: Row(
                              children: [
                                const Text(
                                  'Longitud: ',
                                  style: TextStyle(
                                      fontSize: 13,
                                      fontWeight: FontWeight.bold),
                                ),
                                Text(
                                  '${request?.longitud}',
                                  style: const TextStyle(fontSize: 13),
                                ),
                              ],
                            ),
                          ),
                          Container(
                            alignment: Alignment.centerLeft,
                            width: double.infinity,
                            margin: const EdgeInsets.symmetric(
                                vertical: 3, horizontal: 4),
                            child: Row(
                              children: [
                                const Text(
                                  'Cliente: ',
                                  style: TextStyle(
                                      fontSize: 13,
                                      fontWeight: FontWeight.bold),
                                ),
                                Text(
                                  '${request?.clienteId}',
                                  style: const TextStyle(fontSize: 13),
                                ),
                              ],
                            ),
                          ),
                          Container(
                            alignment: Alignment.centerLeft,
                            width: double.infinity,
                            margin: const EdgeInsets.symmetric(
                                vertical: 3, horizontal: 4),
                            child: Row(
                              children: [
                                const Text(
                                  'Vehiculo: ',
                                  style: TextStyle(
                                      fontSize: 13,
                                      fontWeight: FontWeight.bold),
                                ),
                                Text(
                                  '${request?.vehiculoId}',
                                  style: const TextStyle(fontSize: 13),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void refresh() {
    setState(() {});
  }
}
