import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';

import '../controller/solicitud_asistencia_create_controller.dart';

class SolicitudAsistenciaCreatePage extends StatefulWidget {
  const SolicitudAsistenciaCreatePage({super.key});

  @override
  State<SolicitudAsistenciaCreatePage> createState() =>
      _SolicitudAsistenciaCreatePageState();
}

class _SolicitudAsistenciaCreatePageState
    extends State<SolicitudAsistenciaCreatePage> {
  final SolicitudAsistenciaCreateController _con =
      SolicitudAsistenciaCreateController();

  @override
  void initState() {
    super.initState();
    SchedulerBinding.instance.addPostFrameCallback((timeStamp) {
      _con.init(context, refresh);
    });
  }

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      appBar: AppBar(
        // leading: IconButton(
        //   onPressed: _con.goToAssistanceRequestPage,
        //   icon: const Icon(Icons.arrow_back_ios),
        // ),
        title: const Text('Nueva Solicitud'),
      ),
      body: SizedBox(
        width: double.infinity,
        child: SingleChildScrollView(
          child: Container(
            margin: const EdgeInsets.all(20),
            child: Column(
              children: [
                _textFieldDescription(),
                const SizedBox(height: 7),
                _textFieldAddress(),
                const SizedBox(height: 7),
                _dropDownServices(_con.services),
                const SizedBox(height: 7),
                _dropDownVehicles(_con.vehicles),
                const SizedBox(height: 16),
                _addImage(),
                const SizedBox(height: 16),
                // _buttonAudio(),
                // const SizedBox(height: 5),
                _buttonSend()
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buttonAudio() {
    return SizedBox(
      width: double.infinity,
      child: ElevatedButton(
        onPressed: () {},
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.deepPurple[300],
          elevation: 3,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(15),
          ),
          padding: const EdgeInsets.symmetric(vertical: 15),
        ),
        child: const Text(
          'Grabar Audio',
          style: TextStyle(fontSize: 16, color: Colors.white),
        ),
      ),
    );
  }

  Widget _addImage() {
    return GestureDetector(
      onTap: _con.showAlertDialog,
      child: Container(
        width: 250,
        height: 250,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10),
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(10),
          child: _con.imageFile != null
              ? FadeInImage(
                  placeholder:
                      const AssetImage('assets/img/placeholder-image.png'),
                  image: FileImage(_con.imageFile!),
                  fadeInDuration: const Duration(milliseconds: 200),
                  fit: BoxFit.cover,
                )
              : Center(
                  child: Image.asset('assets/img/add_image.png'),
                ),
        ),
      ),
    );
  }

  Widget _dropDownServices(List<dynamic>? services) {
    return Material(
      elevation: 2.0,
      color: Colors.deepPurple[50],
      borderRadius: BorderRadius.circular(15),
      child: Container(
        padding: const EdgeInsets.all(10),
        child: Column(
          children: [
            const Row(
              children: [
                Icon(
                  Icons.search,
                  color: Colors.deepPurple,
                ),
                SizedBox(width: 15),
                Text(
                  'Servicios',
                  style: TextStyle(
                    color: Colors.deepPurple,
                    fontSize: 16,
                  ),
                ),
              ],
            ),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: DropdownButton<dynamic>(
                value: _con.selectedService,
                underline: Container(
                  alignment: Alignment.centerRight,
                  child: const Icon(
                    Icons.arrow_drop_down_circle,
                    color: Colors.deepPurple,
                  ),
                ),
                elevation: 3,
                isExpanded: true,
                hint: const Text(
                  'Seleccionar servicio',
                  style: TextStyle(
                    color: Colors.deepPurple,
                    fontSize: 16,
                  ),
                ),
                items: services?.map((dynamic service) {
                  return DropdownMenuItem<dynamic>(
                    value: service['id'],
                    child: Container(
                      padding: const EdgeInsets.all(10),
                      margin: const EdgeInsets.only(bottom: 5),
                      width: double.infinity,
                      decoration: BoxDecoration(
                        color: Colors.deepPurple[50],
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: SingleChildScrollView(
                        scrollDirection: Axis.horizontal,
                        child: Text(
                          service['nombre'],
                          style: const TextStyle(
                            fontSize: 15,
                          ),
                        ),
                      ),
                    ),
                  );
                }).toList(),
                onChanged: (newValue) {
                  setState(() {
                    _con.selectedService = newValue;
                  });
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _dropDownVehicles(List<dynamic>? vehicles) {
    return Material(
      elevation: 2.0,
      color: Colors.deepPurple[50],
      borderRadius: BorderRadius.circular(15),
      child: Container(
        padding: const EdgeInsets.all(10),
        child: Column(
          children: [
            const Row(
              children: [
                Icon(
                  Icons.search,
                  color: Colors.deepPurple,
                ),
                SizedBox(width: 15),
                Text(
                  'Vehículos',
                  style: TextStyle(
                    color: Colors.deepPurple,
                    fontSize: 16,
                  ),
                ),
              ],
            ),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: DropdownButton<dynamic>(
                value: _con.selectedVehicle,
                underline: Container(
                  alignment: Alignment.centerRight,
                  child: const Icon(
                    Icons.arrow_drop_down_circle,
                    color: Colors.deepPurple,
                  ),
                ),
                elevation: 3,
                isExpanded: true,
                hint: const Text(
                  'Seleccionar vehículo',
                  style: TextStyle(color: Colors.deepPurple, fontSize: 16),
                ),
                items: vehicles?.map((dynamic vehicle) {
                  return DropdownMenuItem<dynamic>(
                    value: vehicle['id'],
                    child: _card(vehicle),
                    // child: Text(''),
                  );
                }).toList(),
                onChanged: (dynamic newValue) {
                  setState(() {
                    _con.selectedVehicle = newValue;
                  });
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _card(dynamic vehicle) {
    return Container(
      margin: const EdgeInsets.only(right: 5),
      child: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: Row(
          children: [
            // Container(
            //   height: 40,
            //   width: 40,
            //   decoration: BoxDecoration(
            //     borderRadius: BorderRadius.circular(8),
            //   ),
            //   child: ClipRRect(
            //     borderRadius: BorderRadius.circular(8),
            //     child: FadeInImage(
            //       placeholder:
            //           const AssetImage('assets/img/placeholder-image.png'),
            //       image: NetworkImage('$_url${vehicle?.photo}'),
            //       fadeInDuration: const Duration(milliseconds: 200),
            //       fit: BoxFit.cover,
            //     ),
            //   ),
            // ),
            // const SizedBox(width: 10),
            const Text(
              'Marca: ',
              style: TextStyle(
                fontSize: 15,
                fontWeight: FontWeight.bold,
              ),
            ),
            Text(
              '${vehicle['marca_nombre']}',
              style: const TextStyle(fontSize: 15),
            ),
            const SizedBox(width: 10),
            const Text(
              'Modelo: ',
              style: TextStyle(
                fontSize: 15,
                fontWeight: FontWeight.bold,
              ),
            ),
            Text(
              '${vehicle['modelo_nombre']}',
              style: const TextStyle(fontSize: 15),
            ),
            const SizedBox(width: 10),
            const Text(
              'Tipo vehículo: ',
              style: TextStyle(
                fontSize: 15,
                fontWeight: FontWeight.bold,
              ),
            ),
            Text(
              '${vehicle['tipoVehiculo_nombre']}',
              style: const TextStyle(fontSize: 15),
            ),
            const SizedBox(width: 10),
            const Text(
              'Placa: ',
              style: TextStyle(
                fontSize: 15,
                fontWeight: FontWeight.bold,
              ),
            ),
            Text(
              '${vehicle['placa']}',
              style: const TextStyle(fontSize: 15),
            ),
            const SizedBox(width: 10),
            const Text(
              'Nro chasis: ',
              style: TextStyle(
                fontSize: 15,
                fontWeight: FontWeight.bold,
              ),
            ),
            Text(
              '${vehicle['nro_chasis']}',
              style: const TextStyle(fontSize: 15),
            ),
            const SizedBox(width: 10),
            const Text(
              'Color: ',
              style: TextStyle(
                fontSize: 15,
                fontWeight: FontWeight.bold,
              ),
            ),
            Text(
              '${vehicle['color']}',
              style: const TextStyle(fontSize: 15),
            ),
            const SizedBox(width: 10),
            const Text(
              'Año: ',
              style: TextStyle(
                fontSize: 15,
                fontWeight: FontWeight.bold,
              ),
            ),
            Text(
              '${vehicle['año']}',
              style: const TextStyle(fontSize: 15),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buttonSend() {
    return SizedBox(
      width: double.infinity,
      child: ElevatedButton(
        onPressed: _con.register,
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.deepPurple[300],
          elevation: 3,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(15),
          ),
          padding: const EdgeInsets.symmetric(vertical: 15),
        ),
        child: const Text(
          'Enviar Solicitud',
          style: TextStyle(fontSize: 16, color: Colors.white),
        ),
      ),
    );
  }

  Widget _textFieldDescription() {
    return Container(
      // margin: const EdgeInsets.symmetric(horizontal: 50, vertical: 5),
      decoration: BoxDecoration(
        color: Colors.deepPurple[50],
        borderRadius: BorderRadius.circular(15),
      ),
      child: TextField(
        controller: _con.descriptionController,
        minLines: null,
        maxLines: null,
        decoration: const InputDecoration(
          labelText: 'Descripción del problema',
          labelStyle: TextStyle(color: Colors.deepPurple),
          hintStyle: TextStyle(color: Colors.deepPurple),
          prefixIcon: Icon(
            Icons.comment,
            color: Colors.deepPurple,
          ),
          border: InputBorder.none,
          contentPadding: EdgeInsets.all(15),
        ),
      ),
    );
  }

  Widget _textFieldAddress() {
    return Container(
      // margin: const EdgeInsets.symmetric(horizontal: 50, vertical: 5),
      decoration: BoxDecoration(
        color: Colors.deepPurple[50],
        borderRadius: BorderRadius.circular(15),
      ),
      child: TextField(
        onTap: _con.openMap,
        autofocus: false,
        focusNode: AlwayDisabledFocusNode(),
        controller: _con.addressController,
        minLines: null,
        maxLines: null,
        decoration: const InputDecoration(
          labelText: 'Dirección',
          labelStyle: TextStyle(color: Colors.deepPurple),
          hintStyle: TextStyle(color: Colors.deepPurple),
          prefixIcon: Icon(
            Icons.location_pin,
            color: Colors.deepPurple,
          ),
          border: InputBorder.none,
          contentPadding: EdgeInsets.all(15),
        ),
      ),
    );
  }

  void refresh() {
    setState(() {});
  }
}

class AlwayDisabledFocusNode extends FocusNode {
  @override
  bool get hasFocus => false;
}
