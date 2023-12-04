import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:proy1/controller/response_api.dart';
import 'package:proy1/pages/solicitud_asistencia_page.dart';

import '../Service/AuthService.dart';
import '../Service/solicitud_asistencia_service.dart';
import '../model/solicitud_asistencia.dart';
import '../pages/solicitud_asistencia_map_page.dart';
import '../utils/my_snackbar.dart';

class SolicitudAsistenciaCreateController {
  BuildContext? context;
  late Function refresh;

  PickedFile? pickedFile;
  File? imageFile;
  File? audioFile;

  final SolicitudAsistenciaProvider assistanceRequestProvider =
      SolicitudAsistenciaProvider();

  AuthService authService = AuthService();

  int? userId;
  int? clientId;

  List<dynamic>? vehicles = [];
  List<dynamic>? services = [];
  int? selectedVehicle;
  int? selectedService;

  TextEditingController descriptionController = TextEditingController();
  TextEditingController addressController = TextEditingController();
  Map<String, dynamic>? address;

  Future init(BuildContext context, Function refresh) async {
    this.context = context;
    this.refresh = refresh;

    assistanceRequestProvider.init(context);

    userId = authService.getUserId();
    clientId = authService.getClientId();

    await _getServices();
    await _getVehicles();

    // ignore: avoid_print
    print('UserID: $userId, ClientID: $clientId');
    // ignore: avoid_print
    print('SERVICIOS: $services');
    // ignore: avoid_print
    print('VEHICULOS: $vehicles');

    // vehicles = await getVehicles(customer!.id!);
    refresh();
  }

  void register() async {
    String description = descriptionController.text.trim();
    String address = addressController.text.trim();

    if (description.isEmpty || address.isEmpty) {
      MySnackbar.show(context, 'Debe ingresar todos los datos');
      return;
    }

    String longitude = this.address!['longitude'].toString();
    String latitude = this.address!['latitude'].toString();
    String direccion = this.address!['address'].toString();

    print('ID CLIENTE: $clientId');
    print('LONGITUD: $longitude');
    print('LATITUD: $latitude');
    print('DIRECCION: $direccion');
    print('DESCRIPCION: $description');
    print('SERVICIO: $selectedService');
    print('VEHICULO: $selectedVehicle');

    if (imageFile == null) {
      MySnackbar.show(context, 'Debe seleccionar una imagen');
      return;
    }

    SolicitudAsistencia assistanceRequest = SolicitudAsistencia(
      descripcionProblema: description,
      longitud: longitude,
      latitud: latitude,
      clienteId: clientId.toString(),
      vehiculoId: (selectedVehicle != null) ? selectedVehicle.toString() : null,
      servicioId: (selectedService != null) ? selectedService.toString() : null,
      direccion: direccion,
      // photo: '',
    );

    Stream? stream = await assistanceRequestProvider.createWithImage(
        assistanceRequest, imageFile, audioFile);
    stream?.listen((response) {
      ResponseApi responseApi = ResponseApi?.fromJson(json.decode(response));

      // ignore: avoid_print
      print('REPUESTA: ${responseApi.toJson()}');

      if (responseApi.success!) {
        MySnackbar.show(context, 'Solicitud registrado correctamente');
        Future.delayed(const Duration(seconds: 1), () {
          // Navigator.pushReplacementNamed(context!, 'customer/home/request');
          Navigator.push(context!, MaterialPageRoute(builder: (context) => const SolicitudAsistenciaPage()));
        });
      } else {
        // isEnable = true;
        refresh();
      }
    });
  }

  Future<void> _getServices() async {
    Map<String, dynamic> servicesMap = await authService.getServices();
    // ignore: avoid_print
    print(servicesMap);

    services = servicesMap['data'];
  }

  Future<void> _getVehicles() async {
    Map<String, dynamic> vehiclesMap = await authService.getVehicleByClientId();
    // ignore: avoid_print
    print(vehiclesMap);

    vehicles = vehiclesMap['data'];
  }

  void openMap() async {
    address = await showModalBottomSheet(
      isScrollControlled: true,
      isDismissible: false,
      enableDrag: false,
      useSafeArea: true,
      context: context!,
      builder: (context) => const SolicitudAsistenciaMapPage(),
    );

    if (address != null) {
      addressController.text = address!['address'];
      refresh();
    }
  }

  Future selectImage(ImageSource imageSource) async {
    final pickedFile = await ImagePicker().pickImage(
      source: imageSource,
    );

    if (pickedFile != null) {
      imageFile = File(pickedFile.path);
    }

    Navigator.of(context!, rootNavigator: true).pop();
    refresh();
  }

  void showAlertDialog() {
    Widget galleryButton = ElevatedButton(
      child: const Text('Galeria'),
      onPressed: () {
        selectImage(ImageSource.gallery);
      },
    );

    Widget cameraButton = ElevatedButton(
      child: const Text('Camara'),
      onPressed: () {
        selectImage(ImageSource.camera);
      },
    );

    AlertDialog alertDialog = AlertDialog(
      title: const Center(child: Text('Selecciona tu imagen')),
      content: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          galleryButton,
          const SizedBox(width: 10), // Espacio entre los botones
          cameraButton,
        ],
      ),
    );

    showDialog(
      context: context!,
      builder: (BuildContext context) {
        return alertDialog;
      },
    );
  }

  void goToAssistanceRequestPage() {
    Navigator.push(context!, MaterialPageRoute(builder: (context) => const SolicitudAsistenciaPage()));
  }

}
