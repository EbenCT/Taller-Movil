import 'dart:async';

import 'package:flutter/material.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:permission_handler/permission_handler.dart';

class SolicitudAsistenciaMapController {
  BuildContext? context;
  late Function refresh;
  Position? _position;

  String? addressName;
  LatLng? addressLatLng;

  CameraPosition? initialPosition = const CameraPosition(
    target: LatLng(-17.8203273, -63.1469759),
    zoom: 14,
  );

  final Completer<GoogleMapController?> _mapController = Completer();

  Future init(BuildContext context, Function refresh) async {
    this.context = context;
    this.refresh = refresh;
    checkGPS();
  }
  
  void selectAddress() {
    Map<String, dynamic> data = {
      'address': addressName,
      'latitude': addressLatLng?.latitude,
      'longitude': addressLatLng?.longitude
    };
    Navigator.pop(context!, data);
  }

  Future<void> setLocationDraggableInfo() async {
    if (initialPosition != null) {
      double latitude = initialPosition!.target.latitude;
      double longitude = initialPosition!.target.longitude;

      List<Placemark> address =
          await placemarkFromCoordinates(latitude, longitude);

      if (address.isNotEmpty) {
        String direction = address[0].thoroughfare.toString();
        String street = address[0].subThoroughfare.toString();
        String city = address[0].locality.toString();
        // String departament = address[0].administrativeArea.toString();
        String country = address[0].country.toString();

        addressName = '$direction #$street, $city, $country';
        addressLatLng = LatLng(latitude, longitude);
        // ignore: avoid_print
        print('Latitud: ${addressLatLng?.latitude} - Longitud: ${addressLatLng?.longitude}');

        refresh();
      }
    }
  }

  void onMapCreated(GoogleMapController controller) {
    _mapController.complete(controller);
  }

  void updateLocation() async {
    try {
      await _determinePosition(); // OBTENER POSICION ACTUAL Y SOLICITAR PERMISOS
      _position = (await Geolocator
          .getLastKnownPosition()); // OBTENER LATITUD Y LONGITUD
      animatedCameraToPosition(_position!.latitude, _position!.longitude);
    } catch (error) {
      // ignore: avoid_print
      print('Error: $error');
    }
  }

  Future<void> askGpsAccess() async {
    final status = await Permission.location.request();
    if (status == PermissionStatus.granted) {
      updateLocation();
    } else {
      openAppSettings();
    }
  }

  void checkGPS() async {
    bool isLocationEnabled = await Geolocator.isLocationServiceEnabled();
    if (isLocationEnabled) {
      updateLocation();
    } else {
      final status = await Permission.locationWhenInUse.status;
      if (status.isGranted) {
        updateLocation();
      } else {
        // Solicitar permiso
        final result = await Permission.locationWhenInUse.request();
        if (result.isGranted) {
          updateLocation();
        } else {
          openAppSettings();
        }
      }
    }
  }

  Future animatedCameraToPosition(double latitude, double longitude) async {
    final GoogleMapController? controller = await _mapController.future;
    if (controller != null) {
      controller.animateCamera(
        CameraUpdate.newCameraPosition(
          CameraPosition(
            target: LatLng(latitude, longitude),
            zoom: 14,
            bearing: 0,
          ),
        ),
      );
    }
  }

  Future<Position> _determinePosition() async {
    bool serviceEnabled;
    LocationPermission permission;

    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      return Future.error('Location services are disabled.');
    }

    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        return Future.error('Location permissions are denied');
      }
    }

    if (permission == LocationPermission.deniedForever) {
      return Future.error(
          'Location permissions are permanently denied, we cannot request permissions.');
    }

    return await Geolocator.getCurrentPosition();
  }
}
