import 'package:flutter/material.dart';
import 'package:proy1/Service/AuthService.dart';

var bandera = true;

class PaginaUsers extends StatefulWidget {
  const PaginaUsers({Key? key}) : super(key: key);

  @override
  State<PaginaUsers> createState() => _PaginaUsersState();
}

class _PaginaUsersState extends State<PaginaUsers> {
  final AuthService _authService = AuthService();
  Map<String, dynamic>? _userData;

  @override
  void initState() {
    super.initState();
    _loadUserData();
  }

  Future<void> _loadUserData() async {
    final userData = await _authService.getClientById();
    setState(() {
      _userData = userData['data'];
      print(_userData);
    });
  }

  @override
  Widget build(BuildContext context) {
    return ListView(
      children: [
        Container(
          padding: EdgeInsets.symmetric(horizontal: 50),
          child: Center(
            child: Text(
              "Datos usuario",
              style: TextStyle(fontSize: 20),
            ),
          ),
        ),
        if (_userData != null) ...[
          nombreUsers('Nombre: ${_userData!['nombre']} ${_userData!['apellido']}'), // Accede a 'nombre' y 'apellido' dentro de '_userData'
          userDataField('ID', _userData!['id'].toString()), // Accede a 'id' dentro de '_userData'
          userDataField('Teléfono', _userData!['telefono']), // Accede a 'telefono' dentro de '_userData'
          userDataField('Dirección', _userData!['direccion']), // Accede a 'direccion' dentro de '_userData'
          userDataField('Género', _userData!['genero']), // Accede a 'genero' dentro de '_userData'
          SizedBox(height: 20),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              BotEditar(),
              SizedBox(width: 30),
              BotGuardar(),
            ],
          ),
        ],
      ],
    );
  }

  Widget nombreUsers(String nombre) {
    return Center(
      child: Container(
        child: Text(nombre, style: TextStyle(fontSize: 20)),
      ),
    );
  }

  Widget userDataField(String label, String value) {
    return Center(
      child: Container(
        width: 300,
        child: Text("$label: $value", style: TextStyle(fontSize: 20)),
      ),
    );
  }

  Widget BotEditar() {
    return TextButton(
      style: ButtonStyle(
        backgroundColor: MaterialStatePropertyAll(Colors.blueAccent),
      ),
      onPressed: () {
        setState(() {
          // Habilitar edición
        });
      },
      child: Text(
        "Editar",
        style: TextStyle(color: Colors.white, fontSize: 20),
      ),
    );
  }

  Widget BotGuardar() {
    return TextButton(
      style: ButtonStyle(
        backgroundColor: MaterialStatePropertyAll(Colors.blueAccent),
      ),
      onPressed: () {
        setState(() {
          // Guardar cambios
        });
      },
      child: Text(
        "Guardar",
        style: TextStyle(color: Colors.white, fontSize: 20),
      ),
    );
  }
}

