import 'package:flutter/material.dart';

var bandera = true;

class PaginaUsers extends StatefulWidget {
  const PaginaUsers({super.key});

  @override
  State<PaginaUsers> createState() => _PaginaUsersState();
}

class _PaginaUsersState extends State<PaginaUsers> {
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
        Container(
          child: Image.network(
              height: 120,
              "https://i.pinimg.com/originals/6f/57/76/6f57760966a796644b8cfb0fbc449843.png"),
        ),
        nombreUsers(),
        CiUs(),
        CiUSers(),
        TelfUs(),
        TelfUsers(),
        CorreoUs(),
        CorreoUsers(),
        DirUs(),
        DirUSers(),
        SizedBox(
          height: 20,
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            BotEditar(context),
            SizedBox(
              width: 30,
            ),
            BotGuardar(context)
          ],
        )
      ],
    );
  }

  Widget nombreUsers() {
    return Center(
      child: Container(
        child: Text("Juan pablo", style: TextStyle(fontSize: 20)),
      ),
    );
  }

  Widget CiUs() {
    return Center(
      child: Container(
        width: 300,
        child: Text("CI:", style: TextStyle(fontSize: 20)),
      ),
    );
  }

  Widget CiUSers() {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 30, vertical: 5),
      child: TextField(
        readOnly: bandera,
        decoration: InputDecoration(
          hintText: "8125398",
          fillColor: Colors.white,
          filled: true,
        ),
      ),
    );
  }

  Widget TelfUs() {
    return Center(
      child: Container(
        width: 300,
        child: Text("Teléfono:", style: TextStyle(fontSize: 20)),
      ),
    );
  }

  Widget TelfUsers() {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 30, vertical: 5),
      child: TextField(
        readOnly: bandera,
        decoration: InputDecoration(
          hintText: "73625259",
          fillColor: Colors.white,
          filled: true,
        ),
      ),
    );
  }

  Widget CorreoUs() {
    return Center(
      child: Container(
        width: 300,
        child: Text("Correo:", style: TextStyle(fontSize: 20)),
      ),
    );
  }

  Widget CorreoUsers() {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 30, vertical: 5),
      child: TextField(
        readOnly: bandera,
        decoration: InputDecoration(
          hintText: "juanpa@gmial.com",
          fillColor: Colors.white,
          filled: true,
        ),
      ),
    );
  }

  Widget DirUs() {
    return Center(
      child: Container(
        width: 300,
        child: Text("Dirección:", style: TextStyle(fontSize: 20)),
      ),
    );
  }

  Widget DirUSers() {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 30, vertical: 5),
      child: TextField(
        readOnly: bandera,
        decoration: InputDecoration(
          hintText: "Av. Alemana 5to anillo",
          fillColor: Colors.white,
          filled: true,
        ),
      ),
    );
  }

  Widget BotEditar(BuildContext context) {
    return TextButton(
        style: ButtonStyle(
            backgroundColor: MaterialStatePropertyAll(Colors.blueAccent)),
        onPressed: () {
          setState(() {
            bandera = false;
          });
        },
        child: Text(
          "Editar",
          style: TextStyle(color: Colors.white, fontSize: 20),
        ));
  }

  Widget BotGuardar(BuildContext context) {
    return TextButton(
        style: ButtonStyle(
            backgroundColor: MaterialStatePropertyAll(Colors.blueAccent)),
        onPressed: () {
          setState(() {
            bandera = true;
          });
        },
        child: Text(
          "Guardar",
          style: TextStyle(color: Colors.white, fontSize: 20),
        ));
  }
}
