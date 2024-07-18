import 'package:flutter/material.dart';
import 'package:frontend/screens/grafico_screen.dart';
import 'package:frontend/screens/tarea_screen.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'To-Do Project',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: TareaScreen(),
    );
  }
}
