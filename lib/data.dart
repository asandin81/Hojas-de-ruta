import 'dart:async';
import 'package:http/http.dart' as http;
import 'dart:convert' as convert;

class BackendService {
  static Future<List<Map<String, String>>> getSuggestions(String query) async {
    if (query.isEmpty && query.length < 3) {
      print('Query needs to be at least 3 chars');
      return Future.value([]);
    }
    // URL LOCAL DESARROLLO
    // final url = Uri.http('127.0.0.1:3000',
    //     '/api/clientes/search_cliente_hojaruta/', {'term': query});

    // URL PRODUCCION
    final url = Uri.https('groc-i-negre.herokuapp.com',
        '/api/clientes/search_cliente_hojaruta/', {'term': query});

    var response = await http.get(url);
    // print(response.body);
    List<Cliente> clientes = [];
    if (response.statusCode == 200) {
      Iterable json = convert.jsonDecode(response.body);
      clientes =
          List<Cliente>.from(json.map((model) => Cliente.fromJson(model)));

      print(clientes);
      print('Number of suggestion: ${clientes.length}.');
    } else {
      print('Request failed with status: ${response.statusCode}.');
    }

    return Future.value(clientes
        .map(
            (e) => {'nombre': e.nombre, 'cif': e.cif, 'direccion': e.direccion})
        .toList());
  }
}

class Cliente {
  final String nombre;
  final String cif;
  final String direccion;

  Cliente({required this.nombre, required this.cif, required this.direccion});

  factory Cliente.fromJson(Map<String, dynamic> json) {
    return Cliente(
        nombre: json['nombre'], cif: json['cif'], direccion: json['direccion']);
  }
}
