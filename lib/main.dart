import 'package:flutter/material.dart';
import 'package:proy1/controller/AuthController.dart';
import 'package:proy1/pages/pagina02.dart';
import 'package:proy1/pages/register.dart';
import 'package:flutter_localizations/flutter_localizations.dart'; // Importa las localizaciones
void main() {
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  final AuthController _authController = AuthController();
  @override
  void initState() {
    super.initState();
    _authController.checkSession();
  }

  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Flutter Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
            // Configura el idioma local de la aplicación
      localizationsDelegates: [
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      supportedLocales: [
        const Locale('es', 'ES'), // Español
      ],
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
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final TextEditingController _controllerUsuario = TextEditingController();
  final TextEditingController _controllerContrasena = TextEditingController();
  final AuthController _authController = AuthController();

 @override
  void initState() {
    super.initState();
    _authController.checkSession();
  }

  Future<bool> _onWillPop() async {
    return (await showDialog(
          context: context,
          builder: (context) => AlertDialog(
            title: const Text('¿Salir de la aplicación?'),
            content: const Text('¿Estás seguro de que quieres salir?'),
            actions: <Widget>[
              TextButton(
                onPressed: () => Navigator.of(context).pop(false),
                child: const Text('No'),
              ),
              TextButton(
                onPressed: () => Navigator.of(context).pop(true),
                child: const Text('Sí'),
              ),
            ],
          ),
        )) ??
        false;
  }
@override 
 Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: _onWillPop,
      child: Scaffold(
        body: FutureBuilder<void>(
          future: _authController.checkSession(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.done) {
              if (_authController.isLoggedIn) {
                return Pagina02();
              } else {
                return cuerpo(context);
              }
            } else {
              return const CircularProgressIndicator();
            }
          },
        ),
      ),
    );
  }

 Widget cuerpo(BuildContext context) {
  return Container(
    color: Colors.white,
    child: Center(
      child: SingleChildScrollView(
        child: Container(
          width: 300,
          padding: const EdgeInsets.all(20),
          child: Form(
            key: _formKey, // Agregar el formulario y la clave global
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Container(
                  padding: const EdgeInsets.all(20),
                 // child: Image.network("http://3.148.113.33/assets/images/logo-login.png"),
                ),
                Container(
                  padding: const EdgeInsets.all(20),
                  child: RichText(
                    text: TextSpan(
                      children: [
                        TextSpan(
                          text: "TALLER ",
                          style: TextStyle(
                            color: Color(0xFF780001), // Color hexadecimal para #780001
                            fontSize: 25,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        TextSpan(
                          text: "BALJEET",
                          style: TextStyle(
                            color: Colors.black, // Puedes ajustar el color según tus preferencias
                            fontSize: 25,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                Container(
                  padding: const EdgeInsets.all(10),
                  child: Text(
                    "Iniciar Sesión",
                    style: const TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                campoUsuario(_controllerUsuario),
                campoContrasena(_controllerContrasena),
                const SizedBox(height: 10),
                TextButton(
                  style: ButtonStyle(
                    backgroundColor: MaterialStateProperty.all(Colors.blueAccent),
                    padding: MaterialStateProperty.all(
                      const EdgeInsets.symmetric(horizontal: 100, vertical: 10),
                    ),
                  ),
                  onPressed: () async {
                    if (_formKey.currentState!.validate()) {
                      final email = _controllerUsuario.text;
                      final password = _controllerContrasena.text;

                      final response = await _authController.login(email, password);

                      print(response['status']);

                      if (response['status']) {
                        print('Inicio de sesión exitoso');
                        print('Token: ${response['token']}');
                        Navigator.pushReplacement(
                          context,
                          MaterialPageRoute(
                            builder: (context) => Pagina02(),
                          ),
                        );
                      } else {
                        showDialog(
                          context: context,
                          builder: (context) {
                            return AlertDialog(
                              title: const Text('Error de inicio de sesión'),
                              content: Text(response['error']),
                              actions: [
                                TextButton(
                                  onPressed: () {
                                    Navigator.pop(context);
                                  },
                                  child: const Text('OK'),
                                ),
                              ],
                            );
                          },
                        );
                      }
                    }
                  },
                  child: const Text(
                    "Entrar",
                    style: TextStyle(color: Colors.white, fontSize: 15),
                  ),
                ),
                const SizedBox(
                  height: 10,
                ),
                registrar(context),
              ],
            ),
          ),
        ),
      ),
    ),
  );
}


  Widget campoUsuario(TextEditingController controller) {
  return Container(
    padding: const EdgeInsets.all(10),
    child: TextFormField(
      controller: controller,
      decoration: const InputDecoration(
        hintText: "Correo Electrónico",
        fillColor: Colors.white,
        filled: true,
      ),
      validator: (value) {
        if (value?.isEmpty ?? true) { // Verifica si el valor es nulo o está vacío
          return 'Por favor, ingrese su correo electrónico';
        }
        return null;
      },
    ),
  );
}

Widget campoContrasena(TextEditingController controller) {
  return Container(
    padding: const EdgeInsets.all(10),
    child: TextFormField(
      controller: controller,
      obscureText: true,
      decoration: const InputDecoration(
        hintText: "Contraseña",
        fillColor: Colors.white,
        filled: true,
      ),
      validator: (value) {
        if (value?.isEmpty ?? true) { // Verifica si el valor es nulo o está vacío
          return 'Por favor, ingrese una contraseña';
        }
        return null;
      },
    ),
  );
}

  Widget registrar(BuildContext context) {
    return TextButton(
      style: ButtonStyle(
        backgroundColor: MaterialStateProperty.all(Colors.blueAccent),
        padding: MaterialStateProperty.all(
          const EdgeInsets.symmetric(horizontal: 77, vertical: 10),
        ),
      ),
      onPressed: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => RegisterPage(),
          ),
        );
      },
      child: const Text("Registrarse", style: TextStyle(color: Colors.white, fontSize: 15)),
    );
  }
}
