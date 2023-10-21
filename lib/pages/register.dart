import 'package:flutter/material.dart';

void main() {
  runApp(const register());
}

class register extends StatelessWidget {
  const register({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Flutter Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: const MyHomePage(title: 'TALLER MECÁNICO'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});
  final String title;
  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        color: Colors.black,
        child: Center(
          child: ListView(
            children: <Widget>[
              SizedBox(
                height: 100,
              ),
              Registro(),
              RegNombre(),
              RegApellido(),
              RegCi(),
              RegContrasena(),
              RegTelf(),
              RegDir(),
              RegCorreo(),
              botonReg(context),
            ],
          ),
        ),
      ),
    );
  }
}

Widget Registro() {
  return Center(
    child: Text(
      "Registro",
      style: TextStyle(color: Colors.white, fontSize: 30),
    ),
  );
}

Widget RegNombre() {
  return Container(
    padding: EdgeInsets.symmetric(horizontal: 30, vertical: 5),
    child: TextField(
      decoration: InputDecoration(
        hintText: "Nombre",
        fillColor: Colors.white,
        filled: true,
      ),
    ),
  );
}

Widget RegApellido() {
  return Container(
    padding: EdgeInsets.symmetric(horizontal: 30, vertical: 5),
    child: TextField(
      decoration: InputDecoration(
        hintText: "Apellido",
        fillColor: Colors.white,
        filled: true,
      ),
    ),
  );
}

Widget RegCi() {
  return Container(
    padding: EdgeInsets.symmetric(horizontal: 30, vertical: 5),
    child: TextField(
      decoration: InputDecoration(
        hintText: "C.I.",
        fillColor: Colors.white,
        filled: true,
      ),
    ),
  );
}

Widget RegTelf() {
  return Container(
    padding: EdgeInsets.symmetric(horizontal: 30, vertical: 5),
    child: TextField(
      decoration: InputDecoration(
        hintText: "Telefóno",
        fillColor: Colors.white,
        filled: true,
      ),
    ),
  );
}

Widget RegCorreo() {
  return Container(
    padding: EdgeInsets.symmetric(horizontal: 30, vertical: 5),
    child: TextField(
      decoration: InputDecoration(
        hintText: "correo electrónico",
        fillColor: Colors.white,
        filled: true,
      ),
    ),
  );
}

Widget RegDir() {
  return Container(
    padding: EdgeInsets.symmetric(horizontal: 30, vertical: 5),
    child: TextField(
      obscureText: true,
      decoration: InputDecoration(
        hintText: "dirección",
        fillColor: Colors.white,
        filled: true,
      ),
    ),
  );
}

Widget RegContrasena() {
  return Container(
    padding: EdgeInsets.symmetric(horizontal: 30, vertical: 5),
    child: TextField(
      obscureText: true,
      decoration: InputDecoration(
        hintText: "contraseña",
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
          padding:
              MaterialStatePropertyAll(EdgeInsets.symmetric(horizontal: 50))),
      onPressed: () {},
      child:
          Text("Aceptar", style: TextStyle(color: Colors.white, fontSize: 15)),
    ),
  );
}
