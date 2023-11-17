import 'package:flutter/material.dart';
import 'package:http/http.dart' as http; // Importa el paquete http

enum Genero { masculino, femenino }

class RegisterPage extends StatefulWidget {
  const RegisterPage({Key? key}) : super(key: key);

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  final TextEditingController _nombreController = TextEditingController();
  final TextEditingController _apellidoController = TextEditingController();
  final TextEditingController _ciController = TextEditingController();
  final TextEditingController _telefonoController = TextEditingController();
  final TextEditingController _direccionController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  Genero _generoSeleccionado = Genero.masculino; // Valor por defecto

  Future<void> _registrarCliente() async {
    final Uri uri = Uri.parse('http://18.216.45.210/api/clientes');
    final response = await http.post(
      uri,
      body: {
        'nombre': _nombreController.text,
        'apellido': _apellidoController.text,
        'ci': _ciController.text,
        'telefono': _telefonoController.text,
        'direccion': _direccionController.text,
        'email': _emailController.text,
        'password': _passwordController.text,
        'genero': _generoSeleccionado == Genero.masculino ? 'M' : 'F',
      },
    );

    if (response.statusCode == 200) {
      print('Cliente registrado exitosamente');
    } else {
      print('Error al registrar el cliente: ${response.statusCode}');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
    /*  appBar: AppBar(
        title: Text('Registro'),
      ),*/
      body: Container(
        color: Colors.black,
        child: Center(
          child: ListView(
            children: <Widget>[
              SizedBox(height: 100),
              Registro(),
              RegNombre(controller: _nombreController),
              RegApellido(controller: _apellidoController),
              RegCi(controller: _ciController),
              RegContrasena(controller: _passwordController),
              RegTelf(controller: _telefonoController),
              RegDir(controller: _direccionController),
              RegCorreo(controller: _emailController),
              generoSelector(),
              botonReg(context),
            ],
          ),
        ),
      ),
    );
  }

  Widget generoSelector() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 30),
          child: Text(
            'Género',
            style: TextStyle(color: Colors.white),
          ),
        ),
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 30),
          child: Row(
            children: <Widget>[
              Radio<Genero>(
                value: Genero.masculino,
                groupValue: _generoSeleccionado,
                onChanged: (Genero? value) {
                  setState(() {
                    _generoSeleccionado = value!;
                  });
                },
              ),
              Text(
                'Masculino',
                style: TextStyle(color: Colors.white),
              ),
              Radio<Genero>(
                value: Genero.femenino,
                groupValue: _generoSeleccionado,
                onChanged: (Genero? value) {
                  setState(() {
                    _generoSeleccionado = value!;
                  });
                },
              ),
              Text(
                'Femenino',
                style: TextStyle(color: Colors.white),
              ),
            ],
          ),
        ),
      ],
    );
  }
  Widget Registro() {
    return Center(
      child: Text(
        "Registro",
        style: TextStyle(color: Colors.white, fontSize: 30),
      ),
    );
  }

  Widget RegNombre({required TextEditingController controller}) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 30, vertical: 5),
      child: TextField(
        controller: controller,
        decoration: InputDecoration(
          hintText: "Nombre",
          fillColor: Colors.white,
          filled: true,
        ),
      ),
    );
  }

  Widget RegApellido({required TextEditingController controller}) {
  return Container(
    padding: EdgeInsets.symmetric(horizontal: 30, vertical: 5),
    child: TextField(
      controller: controller,
      decoration: InputDecoration(
        hintText: "Apellido",
        fillColor: Colors.white,
        filled: true,
      ),
    ),
  );
}

Widget RegCi({required TextEditingController controller}) {
  return Container(
    padding: EdgeInsets.symmetric(horizontal: 30, vertical: 5),
    child: TextField(
      controller: controller,
      decoration: InputDecoration(
        hintText: "C.I.",
        fillColor: Colors.white,
        filled: true,
      ),
    ),
  );
}

Widget RegContrasena({required TextEditingController controller}) {
  return Container(
    padding: EdgeInsets.symmetric(horizontal: 30, vertical: 5),
    child: TextField(
      controller: controller,
      obscureText: true,
      decoration: InputDecoration(
        hintText: "Contraseña",
        fillColor: Colors.white,
        filled: true,
      ),
    ),
  );
}

Widget RegTelf({required TextEditingController controller}) {
  return Container(
    padding: EdgeInsets.symmetric(horizontal: 30, vertical: 5),
    child: TextField(
      controller: controller,
      decoration: InputDecoration(
        hintText: "Teléfono",
        fillColor: Colors.white,
        filled: true,
      ),
    ),
  );
}

Widget RegDir({required TextEditingController controller}) {
  return Container(
    padding: EdgeInsets.symmetric(horizontal: 30, vertical: 5),
    child: TextField(
      controller: controller,
      decoration: InputDecoration(
        hintText: "Dirección",
        fillColor: Colors.white,
        filled: true,
      ),
    ),
  );
}

Widget RegCorreo({required TextEditingController controller}) {
  return Container(
    padding: EdgeInsets.symmetric(horizontal: 30, vertical: 5),
    child: TextField(
      controller: controller,
      decoration: InputDecoration(
        hintText: "Correo Electrónico",
        fillColor: Colors.white,
        filled: true,
      ),
    ),
  );
}


  Widget botonReg(BuildContext context) {
    return Center(
      child: TextButton(
        style: ButtonStyle(
          backgroundColor: MaterialStatePropertyAll(Colors.blueAccent),
          padding: MaterialStatePropertyAll(
            EdgeInsets.symmetric(horizontal: 50),
          ),
        ),
        onPressed: () {
          _registrarCliente(); // Llama a la función para registrar el cliente
        },
        child: Text(
          "Aceptar",
          style: TextStyle(color: Colors.white, fontSize: 15),
        ),
      ),
    );
  }
}
