import 'package:flutter/material.dart';
import 'package:proy1/Service/AuthService.dart';
import 'package:proy1/Service/solicitud_asistencia_service.dart';

import '../model/solicitud_asistencia.dart';

class SolicitudAsistenciaController {
  BuildContext? context;
  final AuthService _authService = AuthService();
  late Function refresh;

  final SolicitudAsistenciaProvider _assistanceRequestProvider =
      SolicitudAsistenciaProvider();
  List<SolicitudAsistencia>? assistanceRequest = [];

  Future init(BuildContext context, Function refresh) async {
    this.context = context;
    this.refresh = refresh;

    _assistanceRequestProvider.init(context);
    // ignore: avoid_print
    print('CLIENTE ID: ${_authService.getClienteId()}');
    assistanceRequest =
        await getAssistanceRequests(_authService.getClienteId().toString());
    refresh();
  }

  // Future<List<SolicitudAsistencia>?> loadAssistanceRequests() async {
  //   final List<SolicitudAsistencia>? results = await _assistanceRequestProvider
  //       .getAssistanceRequestByCustomerId(customer!.id!);
  //   refresh();
  //   return results;
  // }

  Future<List<SolicitudAsistencia>?> getAssistanceRequests(String id) async {
    print('CLIENTE ID: $id');
    final List<SolicitudAsistencia>? results =
        await _assistanceRequestProvider.getAssistanceRequestByCustomerId(id);
    refresh();
    return results;
  }

  goToRegisterAssistanceRequestPage() {
    Navigator.pushNamed(context!, 'customer/home/request/create');
  }

  goToHomePage() {
    Navigator.pushNamed(context!, 'customer/home');
  }
}
