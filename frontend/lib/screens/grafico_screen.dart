import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:frontend/services/api_service.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:stomp_dart_client/stomp_dart_client.dart';

class GraficoScreen extends StatefulWidget {
  @override
  GraficoScreenState createState() => GraficoScreenState();
}

class GraficoScreenState extends State<GraficoScreen> {
  int tareasCompletadas = 0;
  int tareasNoCompletadas = 0;
  int tareasEliminadas = 0;
  final ApiService apiService = ApiService();
  late StompClient client;

  @override
  void initState() {
    super.initState();
    _cargarEstadisticas();
    _configurarStompClient();
  }

  void _cargarEstadisticas() async {
    try {
      final estadisticas = await apiService.obtenerEstadisticas();
      setState(() {
        tareasCompletadas = estadisticas['completadas'] ?? 0;
        tareasNoCompletadas = estadisticas['noCompletadas'] ?? 0;
        tareasEliminadas = estadisticas['eliminadas'] ?? 0;
      });
    } catch (error) {
      print('Error al cargar estadísticas: $error');
    }
  }

  void _configurarStompClient() {
    client = StompClient(
      config: StompConfig(
        url: 'ws://localhost:8080/websocket',
        onConnect: (StompFrame frame) {
          print('Conectado al WebSocket');
          client.subscribe(
            destination: '/topic/estadisticas',
            callback: (StompFrame frame) {
              final estadisticas =
                  Map<String, dynamic>.from(json.decode(frame.body ?? '{}'));
              setState(() {
                tareasCompletadas = estadisticas['completadas'] ?? 0;
                tareasNoCompletadas = estadisticas['noCompletadas'] ?? 0;
                tareasEliminadas = estadisticas['eliminadas'] ?? 0;
              });
            },
          );
        },
        onWebSocketError: (dynamic error) {
          print('Error en la conexión WebSocket: $error');
        },
        onWebSocketDone: () {
          print('Conexión WebSocket cerrada');
        },
      ),
    );
    client.activate();
  }

  @override
  void dispose() {
    client.deactivate();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Gráfico de Tareas'),
      ),
      body: Column(
        children: [
          Expanded(
            child: Center(
              child: PieChart(
                PieChartData(
                  sections: mostrarSecciones(),
                  borderData: FlBorderData(
                    show: false,
                  ),
                  sectionsSpace: 2,
                  centerSpaceRadius: 50,
                ),
              ),
            ),
          ),
          SizedBox(height: 20),
          // Leyenda
          buildLegend(),
        ],
      ),
    );
  }

  List<PieChartSectionData> mostrarSecciones() {
    return [
      PieChartSectionData(
        color: Colors.green,
        value: tareasCompletadas.toDouble(),
        radius: 100,
      ),
      PieChartSectionData(
        color: Colors.red,
        value: tareasNoCompletadas.toDouble(),
        radius: 100,
      ),
      PieChartSectionData(
        color: Colors.blue,
        value: tareasEliminadas.toDouble(),
        radius: 100,
      ),
    ];
  }

  Widget buildLegend() {
    return Column(
      children: [
        buildLegendItem(Colors.green, 'Completadas', tareasCompletadas),
        buildLegendItem(Colors.red, 'No Completadas', tareasNoCompletadas),
        buildLegendItem(Colors.blue, 'Eliminadas', tareasEliminadas),
      ],
    );
  }

  Widget buildLegendItem(Color color, String text, int value) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Container(
          width: 16,
          height: 16,
          color: color,
        ),
        SizedBox(width: 8),
        Text(
          '$text: $value',
          style: TextStyle(fontSize: 16),
        ),
      ],
    );
  }
}
