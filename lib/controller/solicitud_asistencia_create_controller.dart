import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

import '../Service/solicitud_asistencia_service.dart';
import '../model/solicitud_asistencia.dart';
import '../model/vehicle.dart';
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

  // final VehicleProvider _vehicleProvider = VehicleProvider();

  List<Vehicle>? vehicles = [];
  Vehicle? selectedVehicle;

  TextEditingController descriptionController = TextEditingController();
  TextEditingController addressController = TextEditingController();
  Map<String, dynamic>? address;

  Future init(BuildContext context, Function refresh) async {
    this.context = context;
    this.refresh = refresh;

    assistanceRequestProvider.init(context);

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

    print('LONGITUD: $longitude');
    print('LATITUD: $latitude');
    print('DIRECCION: $direccion');
    print('DESCRIPCION: $description');

    if (imageFile == null) {
      MySnackbar.show(context, 'Debe seleccionar una imagen');
      return;
    }

    SolicitudAsistencia assistanceRequest = SolicitudAsistencia(
      descripcionProblema: description,
      estado: 'Pendiente',
      longitud: longitude,
      latitud: latitude,
      clienteId: "1",
      vehiculoId: selectedVehicle!.id!,
      // photo: '',
    );

    Stream? stream = await assistanceRequestProvider.createWithImage(
        assistanceRequest, imageFile, audioFile);
    stream!.listen((response) {
      // ResponseApi responseApi = ResponseApi?.fromJson(json.decode(response));

      // ignore: avoid_print
      // print('REPUESTA: ${responseApi.toJson()}');

      // if (responseApi.success!) {
      //   // MySnackbar.show(context, 'Solicitud registrado correctamente');
      //   Future.delayed(const Duration(seconds: 1), () {
      //     Navigator.pushReplacementNamed(context!, 'customer/home/request');
      //   });
      // } else {
      //   // isEnable = true;
      //   refresh();
      // }
    });
  }

  Future<List<Vehicle>?> getVehicles(String id) async {
    final List<Vehicle>? results =
        // await _vehicleProvider.getVehiclesByCustomerId(id);
        refresh();
    return results;
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

  goToAssistancePage() {
    // Navigator.pushNamed(context!, 'customer/home/request');
  }
}
