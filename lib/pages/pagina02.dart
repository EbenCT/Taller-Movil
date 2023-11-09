import 'package:flutter/material.dart';
import 'package:proy1/pages/pagHome.dart';
import 'package:proy1/pages/pagUsers.dart';
import 'package:proy1/pages/pagServicios.dart';
import 'package:proy1/pages/pagEstado.dart';

void main() {
  runApp(const Pagina02());
}

class Pagina02 extends StatelessWidget {
  const Pagina02({super.key});

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
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  int _paginaActual = 0;
  List<Widget> _paginas = [
    PaginaHome(),
    PaginaUsers(),
    Servicios(),
    EstadoVehiculoPage(),
  ];

  void _cambiarPagina(int index) {
    setState(() {
      _paginaActual = index;
      Navigator.pop(context); // Cierra el menú desplegable
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.blue,
        title: Text(
          "TALLER MECÁNICO",
          style: TextStyle(color: Colors.white, fontSize: 30),
        ),
      ),
      body: _paginas[_paginaActual],
      drawer: Drawer(
        child: ListView(
          children: [
            ListTile(
              leading: Icon(Icons.home),
              title: Text("Inicio"),
              onTap: () {
                _cambiarPagina(0);
              },
            ),
            ListTile(
              leading: Icon(Icons.supervised_user_circle),
              title: Text("Usuario"),
              onTap: () {
                _cambiarPagina(1);
              },
            ),
            ListTile(
              leading: Icon(Icons.directions_car),
              title: Text("Servicios"),
              onTap: () {
                _cambiarPagina(2);
              },
            ),
            ListTile(
              leading: Icon(Icons.car_rental),
              title: Text("Estado del Vehículo"),
              onTap: () {
                _cambiarPagina(3);
              },
            ),
          ],
        ),
      ),
    );
  }
}
