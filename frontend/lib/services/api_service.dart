import 'dart:convert';
import 'package:frontend/models/tarea.dart';
import 'package:http/http.dart' as http;
import 'package:web_socket_channel/web_socket_channel.dart';

class ApiService {
  static const String baseUrl = 'http://localhost:8080/api/tareas';

//192.168.1.4
  Future<List<Tarea>> listarTreas() async {
    final response = await http.get(Uri.parse(baseUrl));
    if (response.statusCode == 200) {
      Iterable list = json.decode(response.body);
      return list.map((model) => Tarea.fromJson(model)).toList(); 
    } else {
      throw Exception('Error al cargar tareas');
    }
  }

  Future<void> createTask(Map<String, dynamic> tarea) async {
    final response = await http.post(
      Uri.parse(baseUrl),
      headers: {"Content-Type": "application/json"},
      body: json.encode(tarea),
      
    );
    if (response.statusCode != 200) {
      throw Exception('Failed to create tarea');
    }
  }

  Future<void> actualizarEstadoCompletado(Tarea tarea) async {
    final url = '$baseUrl/${tarea.id}';
    final response = await http.put(
      Uri.parse(url),
      headers: {'Content-Type': 'application/json'},
      body: json.encode(tarea.toJson()),
    );
    if (response.statusCode != 200) {
      throw Exception('Failed to update tarea');
    }
  }

   Future<void> actualizarEstado(Tarea tarea) async {
    final url = '$baseUrl/${tarea.id}';
    print(tarea.estado);
    final response = await http.put(
      Uri.parse(url),
      headers: {'Content-Type': 'application/json'},
      body: json.encode(tarea.toJson()),
    );
    if (response.statusCode != 200) {
      throw Exception('Failed to update tarea');
    }
  }

  Future<void> editarTarea(Tarea tarea) async {
    final url = '$baseUrl/${tarea.id}';
    final response = await http.put(
      Uri.parse(url),
      headers: {'Content-Type': 'application/json'},
      body: json.encode(tarea.toJson()),
    );
    if (response.statusCode != 200) {
      throw Exception('Failed to update tarea');
    }
  }

  late WebSocketChannel channel;

  // Inicializa la conexión del WebSocket
  void initWebSocket(Function(Map<String, int>) onMessageReceived) {
    channel = WebSocketChannel.connect(Uri.parse('ws://localhost:8080/websocket'));

    channel.stream.listen((message) {
      final Map<String, int> estadisticas = Map<String, int>.from(json.decode(message));
      onMessageReceived(estadisticas);
      print("aquiiiiiiiiiii"+channel.toString());
    });
  }

  // Cierra la conexión del WebSocket
  void closeWebSocket() {
    channel.sink.close();
  }
//Grafico
  Future<Map<String, int>> obtenerEstadisticas() async {
    final response = await http.get(Uri.parse('$baseUrl/estadisticas'));
    if (response.statusCode == 200) {
      return Map<String, int>.from(json.decode(response.body));
    } else {
      throw Exception('Error al cargar estadísticas: ${response.statusCode}');
    }
  }
}