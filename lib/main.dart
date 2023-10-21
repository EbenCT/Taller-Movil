import 'package:flutter/material.dart';
import 'package:proy1/pages/pagina02.dart';
import 'package:proy1/pages/register.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

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
      body: cuerpo(context),
    );
  }
}

Widget cuerpo(BuildContext context) {
  return Container(
    color: Colors.black,
    child: Center(
        child: Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        nombre(),
        campoUsuario(),
        campocontrasena(),
        SizedBox(height: 10),
        botonEntrar(context),
        SizedBox(
          height: 10,
        ),
        registrar(context),
      ],
    )),
  );
}

Widget nombre() {
  return Text(
    "Iniciar Sesión",
    style: TextStyle(
        color: Colors.white, fontSize: 35.0, fontWeight: FontWeight.bold),
  );
}

Widget campoUsuario() {
  return Container(
    padding: EdgeInsets.symmetric(horizontal: 20.0, vertical: 5.0),
    child: TextField(
      decoration: InputDecoration(
        hintText: "Usuario",
        fillColor: Colors.white,
        filled: true,
      ),
    ),
  );
}

Widget campocontrasena() {
  return Container(
    padding: EdgeInsets.symmetric(horizontal: 20.0, vertical: 5.0),
    child: TextField(
      obscureText: true,
      decoration: InputDecoration(
        hintText: "Contraseña",
        fillColor: Colors.white,
        filled: true,
      ),
    ),
  );
}

Widget botonEntrar(BuildContext context) {
  return TextButton(
    style: ButtonStyle(
      backgroundColor: MaterialStatePropertyAll(Colors.blueAccent),
      padding: MaterialStatePropertyAll<EdgeInsets>(
          EdgeInsets.symmetric(horizontal: 100, vertical: 10)),
    ),
    onPressed: () {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => Pagina02(),
        ),
      );
    },
    child: Text(
      "Entrar",
      style: TextStyle(color: Colors.white, fontSize: 15),
    ),
  );
}

Widget registrar(BuildContext context) {
  return TextButton(
    style: ButtonStyle(
        backgroundColor: MaterialStatePropertyAll(Colors.blueAccent),
        padding: MaterialStatePropertyAll(
            EdgeInsets.symmetric(horizontal: 77, vertical: 10))),
    onPressed: () {
      Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => register(),
          ));
    },
    child: Text("Registrarse",
        style: TextStyle(color: Colors.white, fontSize: 15)),
  );
}
