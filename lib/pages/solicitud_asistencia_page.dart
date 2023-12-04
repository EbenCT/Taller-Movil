import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:proy1/controller/solicitud_asistencia_controller.dart';
import 'package:proy1/pages/solicitud_asistencia_create_page.dart';

import '../utils/api_backend.dart';

class SolicitudAsistenciaPage extends StatefulWidget {
  const SolicitudAsistenciaPage({super.key});

  @override
  State<SolicitudAsistenciaPage> createState() =>
      _SolicitudAsistenciaPageState();
}

class _SolicitudAsistenciaPageState extends State<SolicitudAsistenciaPage> {
  final SolicitudAsistenciaController _con = SolicitudAsistenciaController();
  final String _url = 'http://$apiHost';

  @override
  void initState() {
    super.initState();
    SchedulerBinding.instance.addPostFrameCallback((timeStamp) {
      _con.init(context, refresh);
    });
  }

  @override
  Widget build(BuildContext context) {
    List<dynamic>? solicitudes;

    final Future<List<dynamic>?> requests = Future<List<dynamic>?>.delayed(
      const Duration(seconds: 2),
      () {
        solicitudes = _con.solicitudes;
        return solicitudes;
      },
    );

    return Scaffold(
      appBar: AppBar(
        // leading: IconButton(
        //   onPressed: _con.goToHomePage,
        //   icon: const Icon(Icons.arrow_back_ios),
        // ),
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
      body: RefreshIndicator(
        color: Colors.white,
        backgroundColor: Colors.deepPurple,
        strokeWidth: 4.0,
        onRefresh: _con.actualizarSolicitudes,
        child: FutureBuilder<List<dynamic>?>(
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
      ),
    );
  }

  Widget _card(dynamic request, index) {
    return GestureDetector(
      onTap: () {
        // _con.openBottomSheet(order);
      },
      child: Container(
        height: 250,
        margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 5),
        // alignment: Alignment.center,
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
                  decoration: const BoxDecoration(
                    color: Colors.deepPurple,
                    borderRadius: BorderRadius.only(
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
                height: 250,
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
                          image: NetworkImage('$_url${request['imagen']}'),
                          fadeInDuration: const Duration(milliseconds: 200),
                          fit: BoxFit.cover,
                        ),
                      ),
                    ),
                    Container(
                      margin: const EdgeInsets.only(top: 10, left: 10),
                      width: 200,
                      height: 250,
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
                                  '${request['descripcion_problema']}',
                                  style: const TextStyle(fontSize: 13),
                                  maxLines: 2,
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
                            child: Wrap(
                              children: [
                                const Text(
                                  'Dirección: ',
                                  style: TextStyle(
                                      fontSize: 13,
                                      fontWeight: FontWeight.bold),
                                ),
                                Text(
                                  '${request['direccion']}',
                                  style: const TextStyle(fontSize: 13),
                                  maxLines: 2,
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
                                  'Fecha: ',
                                  style: TextStyle(
                                      fontSize: 13,
                                      fontWeight: FontWeight.bold),
                                ),
                                Text(
                                  '${request['fecha_solicitud']}',
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
                                  'Estado: ',
                                  style: TextStyle(
                                      fontSize: 13,
                                      fontWeight: FontWeight.bold),
                                ),
                                Text(
                                  '${request['estado']}',
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
                                  'Técnico: ',
                                  style: TextStyle(
                                      fontSize: 13,
                                      fontWeight: FontWeight.bold),
                                ),
                                Text(
                                  request['tecnico'] != null
                                      ? '${request['tecnico']['nombre']}'
                                      : 'Sin asignar',
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
