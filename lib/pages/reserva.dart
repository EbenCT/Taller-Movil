import 'package:flutter/material.dart';
import 'package:table_calendar/table_calendar.dart';

class ReservationScreen extends StatefulWidget {
  @override
  _ReservationScreenState createState() => _ReservationScreenState();
}

class _ReservationScreenState extends State<ReservationScreen> {
  DateTime _selectedDay = DateTime.now();
  TimeOfDay _selectedTime = TimeOfDay.now();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Reserva en taller mecánico'),
      ),
      body: Padding(
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
            ElevatedButton(
              onPressed: () {
                // Aquí puedes manejar la lógica de la reserva con la fecha y hora seleccionadas
                print('Día seleccionado: $_selectedDay');
                print('Hora seleccionada: $_selectedTime');
                // Agrega aquí tu lógica para realizar la reserva en el taller
              },
              child: Text('Reservar'),
            ),
          ],
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
      setState(() {
        _selectedDay = selectedDay;
      });
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
        setState(() {
          _selectedTime = picked;
        });
      }
    },
    child: Text('Seleccionar hora: ${_selectedTime.format(context)}'),
  );
}

}
