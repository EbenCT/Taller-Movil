import 'dart:convert';

SolicitudAsistencia assistanceRequestFromJson(String str) =>
    SolicitudAsistencia.fromJson(json.decode(str));

String assistanceRequestToJson(SolicitudAsistencia data) =>
    json.encode(data.toJson());

class SolicitudAsistencia {
  late String? id;
  late String descripcionProblema;
  late String estado;
  late String latitud;
  late String longitud;
  late String? notaVoz;
  late String? imagen;
  late String clienteId;
  late String vehiculoId;
  late List<SolicitudAsistencia> toList = [];

  SolicitudAsistencia({
    this.id,
    required this.descripcionProblema,
    required this.estado,
    required this.latitud,
    required this.longitud,
    this.notaVoz,
    this.imagen,
    required this.clienteId,
    required this.vehiculoId,
  });

  factory SolicitudAsistencia.fromJson(Map<String, dynamic> json) =>
      SolicitudAsistencia(
        id: json["id"] is int ? json["id"].toString() : json["id"],
        descripcionProblema: json["descripcion_problema"],
        estado: json["estado"],
        latitud: json["latitud"],
        longitud: json["longitud"],
        notaVoz: json["nota_voz"],
        imagen: json["imagen"],
        clienteId: json["cliente_id"] is int ? json["cliente_id"].toString() : json["cliente_id"],
        vehiculoId: json["vehiculo_id"] is int ? json["vehiculo_id"].toString() : json["vehiculo_id"]
      );
      
  SolicitudAsistencia.fromJsonList(List<dynamic>? jsonList) {
    if (jsonList == null) return;
    for (var item in jsonList) {
      SolicitudAsistencia assistanceRequest = SolicitudAsistencia.fromJson(item);
      toList.add(assistanceRequest);
    }
  }

  Map<String, dynamic> toJson() => {
        "id": id,
        "descripcion_problema": descripcionProblema,
        "estado": estado,
        "latitud": latitud,
        "longitud": longitud,
        "nota_voz": notaVoz,
        "imagen": imagen,
        "cliente_id": clienteId,
        "vehiculo_id": vehiculoId,
      };
}
