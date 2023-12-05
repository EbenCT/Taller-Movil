import 'package:flutter/material.dart';
import 'package:table_calendar/table_calendar.dart';
import 'package:proy1/Service/AuthService.dart';
import 'package:http/http.dart' as http;
import '../utils/api_backend.dart';

class ReservationScreen extends StatefulWidget {
  @override
  _ReservationScreenState createState() => _ReservationScreenState();
}

class _ReservationScreenState extends State<ReservationScreen> {
  DateTime _selectedDay = DateTime.now();
  TimeOfDay _selectedTime = TimeOfDay.now();
  TimeOfDay _selectedTime2 = TimeOfDay.now();
  AuthService authService = AuthService();
  int? userId;
  int? clientId;
  int? _selectedService;
  List<dynamic> _services = []; // Lista de servicios obtenidos de la API

  @override
  void initState() {
    super.initState();
    // Llamar al método login para establecer userId y clientId
    _fetchUserAndClientId();
    // Obtener los servicios disponibles desde la API
    _fetchServices();
  }

  void _fetchUserAndClientId() async {
    userId = authService.getUserId();
    clientId = authService.getClientId();

    print('UserID: $userId, ClientID: $clientId');
  }

  void _fetchServices() async {
    Map<String, dynamic> servicesMap = await authService.getServices();
    print(servicesMap);
    // Transformar el Map a una lista de valores (dynamic)
    List<dynamic> services = servicesMap['data'];

    setState(() {
      _services = services;
      print(_services);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Reserva en taller mecánico'),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Text(
                'Selecciona un día:',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 10),
              _buildCalendar(),
              SizedBox(height: 20),
              Text(
                'Selecciona una hora:',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 10),
              _buildTimePicker(),
              SizedBox(height: 20),
              Text(
                'Escoja el servicio:',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 10),
              _buildServiceDropdown(),
              SizedBox(height: 20),
              ElevatedButton(
                onPressed: () {
                  createReserva();
                },
                child: Text('Reservar'),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildCalendar() {
    return TableCalendar(
      locale: 'es_ES', // Configura el idioma local del calendario
      firstDay: DateTime.now(),
      lastDay: DateTime.now().add(Duration(days: 365)),
      focusedDay: _selectedDay,
      calendarFormat: CalendarFormat.month,
      onDaySelected: (selectedDay, focusedDay) {
        // Validar que el día seleccionado sea de lunes a viernes
        if (selectedDay.weekday >= DateTime.monday &&
            selectedDay.weekday <= DateTime.friday) {
          setState(() {
            _selectedDay = selectedDay;
          });
        } else {
          // Mensaje de error si se selecciona un día fuera del rango
          showDialog(
            context: context,
            builder: (BuildContext context) {
              return AlertDialog(
                title: Text('Error'),
                content: Text('El taller solo opera de lunes a viernes.'),
                actions: <Widget>[
                  TextButton(
                    onPressed: () {
                      Navigator.pop(context);
                    },
                    child: Text('Aceptar'),
                  ),
                ],
              );
            },
          );
        }
      },
      onFormatChanged: (format) {},
      onPageChanged: (focusedDay) {
        _selectedDay = focusedDay;
      },
      selectedDayPredicate: (day) {
        return isSameDay(_selectedDay, day);
      },
    );
  }

  Widget _buildServiceDropdown() {
    return DropdownButtonFormField(
      decoration: InputDecoration(
        labelText: 'Selecciona un servicio',
        border: OutlineInputBorder(),
      ),
      value: _selectedService,
      items: _services.map<DropdownMenuItem<dynamic>>((dynamic service) {
        return DropdownMenuItem<dynamic>(
          value: service['id'],
          child: Container(
            width: MediaQuery.of(context).size.width *
                0.7, // Ajusta el ancho según sea necesario
            child: Text(service['nombre']),
          ),
        );
      }).toList(),
      onChanged: (newValue) {
        setState(() {
          _selectedService = newValue;
        });
      },
    );
  }

  Widget _buildTimePicker() {
    return ElevatedButton(
      onPressed: () async {
        final TimeOfDay? picked = await showTimePicker(
          context: context,
          initialTime: _selectedTime,
          // Configura el idioma local del picker de hora
          builder: (BuildContext context, Widget? child) {
            return Localizations.override(
              context: context,
              locale: Locale('es', 'ES'), // Español
              child: child!,
            );
          },
        );
        if (picked != null) {
          // Validar que la hora seleccionada esté entre las 8 am y las 6 pm
          if (picked.hour >= 8 && picked.hour <= 18) {
            // Cálculo para establecer _selectedTime2
            final DateTime selectedDateTime = DateTime(
              DateTime.now().year,
              DateTime.now().month,
              DateTime.now().day,
              picked.hour,
              picked.minute,
            );

            final DateTime selectedDateTime2 = selectedDateTime
                .add(Duration(hours: 1))
                .subtract(Duration(seconds: 1));
            final TimeOfDay selectedTime2 =
                TimeOfDay.fromDateTime(selectedDateTime2);

            setState(() {
              _selectedTime = picked;
              _selectedTime2 = selectedTime2;
            });
          } else {
            // Mensaje de error si se selecciona una hora fuera del rango
            showDialog(
              context: context,
              builder: (BuildContext context) {
                return AlertDialog(
                  title: Text('Error'),
                  content: Text('El taller opera de 8 am a 6 pm.'),
                  actions: <Widget>[
                    TextButton(
                      onPressed: () {
                        Navigator.pop(context);
                      },
                      child: Text('Aceptar'),
                    ),
                  ],
                );
              },
            );
          }
        }
      },
      child: Text('Seleccionar hora: ${_selectedTime.format(context)}'),
    );
  }

  Future<void> createReserva() async {
    // Ejemplo de conversión de la fecha a formato 'YYYY-MM-DD'
    DateTime selectedDate =
        _selectedDay; // Suponiendo que _selectedDay es un objeto DateTime
    String formattedDate =
        '${selectedDate.year}-${selectedDate.month.toString().padLeft(2, '0')}-${selectedDate.day.toString().padLeft(2, '0')}';
// formattedDate contendrá la fecha en formato 'YYYY-MM-DD'
// Ejemplo de conversión de TimeOfDay a formato 'HH:mm:ss'
    TimeOfDay selectedTime =
        _selectedTime; // Suponiendo que _selectedTime es un objeto TimeOfDay
    String formattedTime1 =
        '${selectedTime.hour.toString().padLeft(2, '0')}:${selectedTime.minute.toString().padLeft(2, '0')}:00';
    TimeOfDay selectedTime2 =
        _selectedTime2; // Suponiendo que _selectedTime es un objeto TimeOfDay
    String formattedTime2 =
        '${selectedTime2.hour.toString().padLeft(2, '0')}:${selectedTime2.minute.toString().padLeft(2, '0')}:00';

// formattedTime contendrá la hora en formato 'HH:mm:ss'

    var url = Uri.parse('http://$apiBackend/reservas');

    // Datos para la reserva (simulado, reemplázalos con los datos que necesites)
    var data = {
      'hora_inicio': formattedTime1,
      'hora_fin': formattedTime2,
      'fecha': formattedDate,
      'estado': "falta aprobacion",
      'servicio_id': _selectedService.toString(),
      'cliente_id': clientId.toString(),
      // Agrega más datos según los campos necesarios en tu API
    };
    print(data);
    try {
      var response = await http.post(
        url,
        body: data,
      );

      if (response.statusCode == 201) {
        // La reserva se creó exitosamente
        print('Reserva creada correctamente');
       // Mostrar el mensaje de reserva registrada con los detalles
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text('Reserva registrada'),
            content: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Text('Fecha: $formattedDate'),
                Text('Hora inicio: $formattedTime1'),
                Text('Hora fin: $formattedTime2'),
                Text('Estado: falta aprobación'),
                Text('Servicio: ${_services.firstWhere((service) => service['id'] == _selectedService)['nombre']}'),
                // Agrega más detalles si es necesario
              ],
            ),
            actions: <Widget>[
              TextButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                child: Text('Aceptar'),
              ),
            ],
          );
        },
      );
    } else {
      // Error al crear la reserva
      print('Error al crear la reserva - Código: ${response.statusCode}');

      // Mostrar el mensaje de horario ocupado
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text('Error'),
            content: Text('Horario ocupado por otro cliente, escoja otra fecha u hora'),
            actions: <Widget>[
              TextButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                child: Text('Aceptar'),
              ),
            ],
          );
        },
      );
    }
  } catch (e) {
    // Error de conexión u otro error
    print('Error: $e');

    // Mostrar un mensaje genérico de error
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Error'),
          content: Text('Ocurrió un error al procesar la reserva. Inténtalo de nuevo.'),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: Text('Aceptar'),
            ),
          ],
        );
      },
    );
  }
  }
}
