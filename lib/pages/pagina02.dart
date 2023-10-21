import 'package:flutter/material.dart';
import 'package:proy1/pages/pagHome.dart';
import 'package:proy1/pages/pagUsers.dart';
import 'package:proy1/pages/pagCar.dart';

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
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  int _paginaActual = 0;
  List<Widget> _paginas = [
    PaginaHome(),
    PaginaUsers(),
    PaginaCarrito(),
  ];
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.blue,
        title: Text(
          "Menu",
          style: TextStyle(color: Colors.white, fontSize: 30),
        ),
      ),
      body: _paginas[_paginaActual],
      bottomNavigationBar: BottomNavigationBar(
        backgroundColor: Colors.lightBlue,
        onTap: (index) {
          setState(() {
            _paginaActual = index;
          });
        },
        currentIndex: _paginaActual,
        items: [
          BottomNavigationBarItem(icon: Icon(Icons.home), label: "Inicio"),
          BottomNavigationBarItem(
              icon: Icon(Icons.supervised_user_circle), label: "Usuario"),
          BottomNavigationBarItem(
              icon: Icon(Icons.shopping_cart), label: "Carrito"),
        ],
      ),
    );
  }
}
