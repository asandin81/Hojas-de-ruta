import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_typeahead/flutter_typeahead.dart';
import 'package:dio/dio.dart';
import 'data.dart';

class MyMaterialApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Hojas de ruta VTC',
      home: MyHomePage(),
      theme: ThemeData(primarySwatch: Colors.brown),
      localizationsDelegates: const [
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
      ],
      supportedLocales: const [
        Locale('es', 'ES'),
      ],
    );
  }
}

class MyHomePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text('Hojas de ruta - VTC'),
          backgroundColor: Colors.brown,
        ),
        body: NavigationExample());
  }
}

class NavigationExample extends StatefulWidget {
  @override
  State<NavigationExample> createState() => _NavigationExampleState();
}

class _NavigationExampleState extends State<NavigationExample> {
  Map<String, String> contratante = {};

  final TextEditingController _nombreController = TextEditingController();

  final TextEditingController _cifController = TextEditingController();

  final TextEditingController _fecaContratoController = TextEditingController();

  final TextEditingController _pasajeroController = TextEditingController();

  final TextEditingController _origenController = TextEditingController();

  final TextEditingController _destinoController = TextEditingController();

  final TextEditingController _fechaController = TextEditingController();

  final TextEditingController _horaController = TextEditingController();

  var _cargando = false;
  var _fechaContrato = null;
  var _fecha = null;
  var _hora = null;
  final url =
      'https://script.google.com/macros/s/AKfycbyubkpvfa3wd8scRiVLOZeSd6lY__WyQb0U6bfox5lK_j1J_sLwRSJwOyJfiOmZqtsloA/exec';
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.all(32.0),
      child: SingleChildScrollView(
          child: (!_cargando)
              ? Column(
                  children: <Widget>[
                    const SizedBox(
                      height: 10.0,
                    ),
                    TypeAheadField(
                      textFieldConfiguration: TextFieldConfiguration(
                        cursorColor: Colors.brown,
                        autofocus: true,
                        style: DefaultTextStyle.of(context)
                            .style
                            .copyWith(fontStyle: FontStyle.italic),
                        decoration: const InputDecoration(
                            labelStyle: TextStyle(color: Colors.brown),
                            focusedBorder: OutlineInputBorder(
                                borderSide: BorderSide(
                                    color: Colors.brown, width: 2.0)),
                            border: OutlineInputBorder(),
                            hintText: 'Buscar cliente',
                            labelText: 'Buscar cliente'),
                      ),
                      suggestionsCallback: (pattern) async {
                        return await BackendService.getSuggestions(pattern);
                      },
                      itemBuilder: (context, Map<String, String> suggestion) {
                        return ListTile(
                          title: Text(suggestion['nombre']!),
                          subtitle: Text('${suggestion['cif']}'),
                        );
                      },
                      onSuggestionSelected: (Map<String, String> suggestion) {
                        // SE EJECUTA AL HACER CLICK EN LA SUGERENCIA DE BUSQUEDA
                        contratante = suggestion;
                        _nombreController.text = suggestion['nombre']!;
                        _cifController.text = suggestion['cif']!;
                        _origenController.text = suggestion['direccion']!;
                        _fecaContratoController.text = DateTime.now()
                            .subtract(Duration(minutes: 5))
                            .toString();
                      },
                    ),
                    const SizedBox(
                      height: 10.0,
                    ),
                    campoNombre(),
                    const SizedBox(
                      height: 10.0,
                    ),
                    campoCIF(),
                    const SizedBox(
                      height: 10.0,
                    ),
                    campoFechaContrato(),
                    const SizedBox(
                      height: 10.0,
                    ),
                    campoPasajero(),
                    const SizedBox(
                      height: 10.0,
                    ),
                    campoOrigen(),
                    const SizedBox(
                      height: 10.0,
                    ),
                    campoDestino(),
                    const SizedBox(
                      height: 10.0,
                    ),
                    campoFecha(),
                    const SizedBox(
                      height: 10.0,
                    ),
                    campoHora(),
                    const SizedBox(
                      height: 20.0,
                    ),
                    botones()
                  ],
                )
              : const Center(
                  child: CircularProgressIndicator(
                  color: Colors.brown,
                ))),
    );
  }

  Widget campoNombre() {
    return TextField(
      controller: _nombreController,
      cursorColor: Colors.brown,
      textCapitalization: TextCapitalization.words,
      decoration: InputDecoration(
          labelStyle: const TextStyle(color: Colors.brown),
          border: const OutlineInputBorder(),
          focusedBorder: const OutlineInputBorder(
              borderSide: BorderSide(color: Colors.brown, width: 2.0)),
          hintText: 'Nombre',
          labelText: 'Nombre',
          suffixIcon: IconButton(
            icon: const Icon(
              Icons.close,
              color: Colors.brown,
            ),
            onPressed: () {
              _nombreController.clear();
            },
          )),
    );
  }

  Widget campoCIF() {
    return TextField(
      controller: _cifController,
      cursorColor: Colors.brown,
      decoration: InputDecoration(
          labelStyle: const TextStyle(color: Colors.brown),
          border: const OutlineInputBorder(),
          focusedBorder: const OutlineInputBorder(
              borderSide: BorderSide(color: Colors.brown, width: 2.0)),
          hintText: 'CIF',
          labelText: 'CIF',
          suffixIcon: IconButton(
            icon: const Icon(
              Icons.close,
              color: Colors.brown,
            ),
            onPressed: () {
              _cifController.clear();
            },
          )),
    );
  }

  Widget campoPasajero() {
    return TextField(
      controller: _pasajeroController,
      cursorColor: Colors.brown,
      textCapitalization: TextCapitalization.words,
      decoration: InputDecoration(
          labelStyle: const TextStyle(color: Colors.brown),
          border: const OutlineInputBorder(),
          focusedBorder: const OutlineInputBorder(
              borderSide: BorderSide(color: Colors.brown, width: 2.0)),
          hintText: 'Ej. Nombre pasajero',
          labelText: 'Observaciones',
          suffixIcon: IconButton(
            icon: const Icon(
              Icons.close,
              color: Colors.brown,
            ),
            onPressed: () {
              _pasajeroController.clear();
            },
          )),
    );
  }

  Widget campoOrigen() {
    return TextField(
      controller: _origenController,
      cursorColor: Colors.brown,
      textCapitalization: TextCapitalization.sentences,
      decoration: InputDecoration(
          labelStyle: const TextStyle(color: Colors.brown),
          border: const OutlineInputBorder(),
          focusedBorder: const OutlineInputBorder(
              borderSide: BorderSide(color: Colors.brown, width: 2.0)),
          hintText: 'Origen',
          labelText: 'Origen',
          suffixIcon: IconButton(
            icon: const Icon(
              Icons.close,
              color: Colors.brown,
            ),
            onPressed: () {
              _origenController.clear();
            },
          )),
    );
  }

  Widget campoDestino() {
    return TextField(
      controller: _destinoController,
      cursorColor: Colors.brown,
      textCapitalization: TextCapitalization.sentences,
      decoration: InputDecoration(
          labelStyle: const TextStyle(color: Colors.brown),
          border: const OutlineInputBorder(),
          focusedBorder: const OutlineInputBorder(
              borderSide: BorderSide(color: Colors.brown, width: 2.0)),
          hintText: 'Destino',
          labelText: 'Destino',
          suffixIcon: IconButton(
            icon: const Icon(
              Icons.close,
              color: Colors.brown,
            ),
            onPressed: () {
              _destinoController.clear();
            },
          )),
    );
  }

  Widget campoFechaContrato() {
    return TextField(
      controller: _fecaContratoController,
      cursorColor: Colors.brown,
      decoration: InputDecoration(
          labelStyle: const TextStyle(color: Colors.brown),
          border: const OutlineInputBorder(),
          focusedBorder: const OutlineInputBorder(
              borderSide: BorderSide(color: Colors.brown, width: 2.0)),
          hintText: 'Fecha Contrato',
          labelText: 'Fecha Contrato',
          suffixIcon: IconButton(
            icon: const Icon(
              Icons.close,
              color: Colors.brown,
            ),
            onPressed: () {
              _fecaContratoController.clear();
            },
          )),
      onTap: () {
        obtenerFecha(context, 'Contrato');
      },
    );
  }

  Widget campoFecha() {
    return TextField(
      controller: _fechaController,
      cursorColor: Colors.brown,
      decoration: InputDecoration(
        labelStyle: const TextStyle(color: Colors.brown),
        border: const OutlineInputBorder(),
        focusedBorder: const OutlineInputBorder(
            borderSide: BorderSide(color: Colors.brown, width: 2.0)),
        hintText: 'Selecciona una fecha',
        labelText: 'Fecha',
        suffixIcon: IconButton(
          icon: const Icon(
            Icons.close,
            color: Colors.brown,
          ),
          onPressed: () {
            _fechaController.clear();
          },
        ),
      ),
      onTap: () {
        obtenerFecha(context, 'Servicio');
      },
    );
  }

  Widget campoHora() {
    return TextField(
      controller: _horaController,
      cursorColor: Colors.brown,
      decoration: InputDecoration(
          labelStyle: const TextStyle(color: Colors.brown),
          border: const OutlineInputBorder(),
          focusedBorder: const OutlineInputBorder(
              borderSide: BorderSide(color: Colors.brown, width: 2.0)),
          hintText: 'Hora',
          labelText: 'Hora',
          suffixIcon: IconButton(
            icon: const Icon(
              Icons.close,
              color: Colors.brown,
            ),
            onPressed: () {
              _horaController.clear();
            },
          )),
      onTap: () {
        obtenerHora(context);
      },
    );
  }

  botones() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Expanded(
          child: Container(
            padding: EdgeInsets.only(right: 5),
            child: ElevatedButton(
              style: ElevatedButton.styleFrom(
                  primary: Colors.grey, padding: EdgeInsets.all(20)),
              onPressed: () {
                limpiarCampos();
              },
              child: Text('Cancelar'),
            ),
          ),
        ),
        Expanded(
          child: Container(
            padding: EdgeInsets.only(left: 5),
            child: ElevatedButton(
              style: ElevatedButton.styleFrom(
                  primary: Colors.brown, padding: EdgeInsets.all(20)),
              onPressed: () async {
                print('Boton enviar pulsado');
                if (verificarCampos(context)) {
                  final FormData data = FormData.fromMap({
                    'nombre': _nombreController.text,
                    'cif': _cifController.text,
                    'fecha_contrato': _fecaContratoController.text,
                    'observaciones': _pasajeroController.text,
                    'origen': _origenController.text,
                    'destino': _destinoController.text,
                    'fecha': _fechaController.text,
                    'hora': _horaController.text,
                    'hora_text': _hora.hour.toString(),
                    'minutos_text': _hora.minute.toString(),
                    'dia': _fecha.day.toString(),
                    'mes': _fecha.month.toString(),
                    'ano': _fecha.year.toString()
                  });

                  _cargando = true;
                  setState(() {});

                  var response = await Dio().post(
                    url,
                    data: data,
                    options: Options(
                        headers: {
                          "Accept": "application/x-www-form-urlencoded"
                        },
                        followRedirects: false,
                        validateStatus: (status) {
                          return status! < 500;
                        }),
                  );

                  // Ser realiza una segunda peticion, porque google no devuelve la respueta directamente.
                  // la respuesta esta en una url a la que redirecciona, por ese motivo se realiza
                  // otra peticion GET a la url que esta en la cabezera.

                  var respRedir =
                      await Dio().get(response.headers['location']!.first);

                  if (respRedir.data['ok']) {
                    _cargando = false;
                    setState(() {});
                    showDialog(
                        context: context,
                        builder: (BuildContext context) {
                          return AlertDialog(
                            title: Text('Hoja de ruta creada'),
                            content: Text(
                                'La Hoja de ruta se a creado correctamente para el cliente ${_nombreController.text} el dia ${_fechaController.text} a las ${_horaController.text}.'),
                            actions: [
                              TextButton(
                                  onPressed: () {
                                    limpiarCampos();
                                    Navigator.of(context).pop();
                                  },
                                  child: Text('Cerrar'))
                            ],
                          );
                        });
                  } else {
                    _cargando = false;
                    setState(() {});
                    showDialog(
                        context: context,
                        builder: (BuildContext context) {
                          return AlertDialog(
                            title: Text('Error'),
                            content: Text(respRedir.data['error']),
                            actions: [
                              TextButton(
                                  onPressed: () {
                                    Navigator.of(context).pop();
                                  },
                                  child: Text('Cerrar'))
                            ],
                          );
                        });
                  }
                }
              },
              child: Text('Nueva Hoja'),
            ),
          ),
        ),
      ],
    );
  }

  Future obtenerFecha(BuildContext context, String campo) async {
    DateTime? _fechaSeleccionada = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(1900),
      lastDate: DateTime(2030),
    );

    if (_fechaSeleccionada != null) {
      setState(() {
        if (campo == 'Contrato') {
          _fechaContrato = _fechaSeleccionada;
          _fecaContratoController.text =
              '${_fechaSeleccionada.day}/${_fechaSeleccionada.month}/${_fechaSeleccionada.year}';
        } else if (campo == 'Servicio') {
          _fecha = _fechaSeleccionada;
          _fechaController.text =
              '${_fechaSeleccionada.day}/${_fechaSeleccionada.month}/${_fechaSeleccionada.year}';
        }
      });
    }
  }

  Future obtenerHora(BuildContext context) async {
    TimeOfDay? _horaSeleccionada =
        await showTimePicker(context: context, initialTime: TimeOfDay.now());
    if (_horaSeleccionada != null) {
      setState(() {
        _hora = _horaSeleccionada;
        _horaController.text = _horaSeleccionada.format(context);
      });
    }
  }

  bool verificarCampos(BuildContext context) {
    bool _flag = true;
    if (_nombreController.text.isEmpty ||
        _cifController.text.isEmpty ||
        _fecaContratoController.text.isEmpty ||
        _origenController.text.isEmpty ||
        _destinoController.text.isEmpty ||
        _fecaContratoController.text.isEmpty ||
        _horaController.text.isEmpty) {
      _flag = false;

      showDialog(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              title: Text('Faltan datos'),
              content: Text(
                  'Debe de rellenar todos los datos excepto las observaciones para crera la hoja de ruta.'),
              actions: [
                TextButton(
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                    child: Text('Cerrar'))
              ],
            );
          });
      return _flag;
    }
    return _flag;
  }

  void limpiarCampos() {
    _nombreController.clear();
    _cifController.clear();
    _fecaContratoController.clear();
    _pasajeroController.clear();
    _origenController.clear();
    _destinoController.clear();
    _fechaController.clear();
    _horaController.clear();
  }
}
