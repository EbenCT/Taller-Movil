import 'package:flutter/material.dart';
import 'package:proy1/controller/AuthController.dart';
import 'package:proy1/pages/pagina02.dart';
import 'package:proy1/pages/register.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
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
  final controllerUsuario = TextEditingController();
  final controllerContrasena = TextEditingController();
  final authController = AuthController();

  return Container(
    color: Colors.black,
    child: Center(
        child: Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        nombre(),
        campoUsuario(controllerUsuario),
        campocontrasena(controllerContrasena),
        SizedBox(height: 10),
        // botonEntrar(context),
        TextButton(
          style: const ButtonStyle(
            backgroundColor: MaterialStatePropertyAll(Colors.blueAccent),
            padding: MaterialStatePropertyAll<EdgeInsets>(
                EdgeInsets.symmetric(horizontal: 100, vertical: 10)),
          ),
          onPressed: () async {
            final email = controllerUsuario.text;
            final password = controllerContrasena.text;

            final response = await authController.login(email, password);

            print(response['status']);

            if (response['status']) {
              // Inicio de sesión exitoso, puedes hacer lo que necesites con la respuesta del servidor
              print('Inicio de sesión exitoso');
              print('Token: ${response['token']}');
              // Realiza la navegación a la siguiente pantalla aquí.
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => Pagina02(),
                ),
              );
            } else {
              // Inicio de sesión fallido, muestra un mensaje de error al usuario
              showDialog(
                context: context,
                builder: (context) {
                  return AlertDialog(
                    title: Text('Error de inicio de sesión'),
                    content: Text(response['error']),
                    actions: [
                      TextButton(
                        onPressed: () {
                          Navigator.pop(context); // Cierra el cuadro de diálogo
                        },
                        child: Text('OK'),
                      ),
                    ],
                  );
                },
              );
            }
          },
          child: const Text(
            "Entrar",
            style: TextStyle(color: Colors.white, fontSize: 15),
          ),
        ),
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

Widget campoUsuario(TextEditingController controller) {
  return Container(
    padding: EdgeInsets.symmetric(horizontal: 20.0, vertical: 5.0),
    child: TextField(
      controller: controller,
      decoration: InputDecoration(
        hintText: "Usuario",
        fillColor: Colors.white,
        filled: true,
      ),
    ),
  );
}

Widget campocontrasena(TextEditingController controller) {
  return Container(
    padding: EdgeInsets.symmetric(horizontal: 20.0, vertical: 5.0),
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
