import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

import '../model/solicitud_asistencia.dart';
import '../utils/api_backend.dart';

class SolicitudAsistenciaProvider {
  final String _url = apiBackend;
  final String _api = '/assistance-request';

  BuildContext? context;

  Future init(BuildContext context) async {
    this.context = context;
  }

  Future<List<SolicitudAsistencia>?> getAssistanceRequestByCustomerId(
      String id) async {
    try {
      Uri url = Uri.http(_url, '$_api/$id');
      Map<String, String> headers = {
        'Content-type': 'application/json',
        'Accept': 'application/json',
      };
      final res = await http.get(url, headers: headers);
      final data = json.decode(res.body)['data'];

      // ignore: avoid_print
      print('DATA: $data');

      SolicitudAsistencia results = SolicitudAsistencia.fromJsonList(data);
      return results.toList;
    } catch (e) {
      // ignore: avoid_print
      print('Error: $e');
      return null;
    }
  }

  // Future<List<SolicitudAsistencia>?> getPendingAssistanceRequest() async {
  //   try {
  //     Uri url = Uri.http(_url, '$_api/getPending');
  //     Map<String, String> headers = {
  //       'Content-type': 'application/json',
  //       'Accept': 'application/json',
  //     };
  //     final res = await http.get(url, headers: headers);
  //     final data = json.decode(res.body)['data'];

  //     // ignore: avoid_print
  //     print('DATA: $data');

  //     SolicitudAsistencia results = SolicitudAsistencia.fromJsonList(data);
  //     return results.toList;
  //   } catch (e) {
  //     // ignore: avoid_print
  //     print('Error: $e');
  //     return null;
  //   }
  // }

  Future<Stream?> createWithImage(
      SolicitudAsistencia assistanceRequest, File? imagen, File? audio) async {
    try {
      Uri url = Uri.http(_url, '$_api/create');
      final request = http.MultipartRequest('POST', url);

      if (imagen != null) {
        request.files.add(await http.MultipartFile.fromPath(
          'photo',
          imagen.path,
        ));
      }

      if (audio != null) {
        request.files.add(await http.MultipartFile.fromPath(
          'voice_note',
          audio.path,
        ));
      }

      request.fields['descripcion_problema'] =
          assistanceRequest.descripcionProblema;
      request.fields['estado'] = assistanceRequest.estado;
      request.fields['latitud'] = assistanceRequest.latitud;
      request.fields['longitud'] = assistanceRequest.longitud;
      request.fields['vehiculo_id'] = assistanceRequest.vehiculoId;
      request.fields['cliente_id'] = assistanceRequest.clienteId;

      final response = await request.send(); // Se envia peticion a la api
      return response.stream.transform(utf8.decoder);
    } catch (error) {
      // ignore: avoid_print
      print('Error: $error');
      return null;
    }
  }
}
