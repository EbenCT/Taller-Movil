import 'package:flutter/material.dart';
import 'package:proy1/Service/AuthService.dart';

import '../model/solicitud_asistencia.dart';
import '../pages/pagHome.dart';

class SolicitudAsistenciaController {
  BuildContext? context;
  final AuthService authService = AuthService();

  late Function refresh;

  List<SolicitudAsistencia>? assistanceRequest = [];
  List<dynamic>? solicitudes = [];

  Future init(BuildContext context, Function refresh) async {
    this.context = context;
    this.refresh = refresh;

    await _getAssistanceRequest();

    print('SOLICITUDES: $solicitudes');

    refresh();
  }

  Future<void> _getAssistanceRequest() async {
    Map<String, dynamic> servicesMap = await authService.getAssistanceRequestByClientId();
    // ignore: avoid_print
    print(servicesMap);

    solicitudes = servicesMap['data'];
  }
  
  Future<void> actualizarSolicitudes() async {
    await Future.delayed(const Duration(seconds: 2));
    await _getAssistanceRequest();
    refresh();
  }
  
  void goToHomePage() {
    Navigator.push(context!, MaterialPageRoute(builder: (context) => const PaginaHome()));
  }
  
}
