import 'package:flutter/material.dart';
import 'package:frontend/services/api_service.dart';

class CrearTareaScreen extends StatefulWidget {
  @override
  _CrearTareaScreenState createState() => _CrearTareaScreenState();
}

class _CrearTareaScreenState extends State<CrearTareaScreen> {
  final ApiService apiService = ApiService();
  final TextEditingController nombreController = TextEditingController();
  final TextEditingController descripcionController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Crear Nueva Tarea'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          child: Column(
            children: <Widget>[
              TextFormField(
                controller: nombreController,
                decoration: InputDecoration(labelText: 'Nombre'),
              ),
              SizedBox(height: 20),
              TextFormField(
                controller: descripcionController,
                decoration: InputDecoration(labelText: 'Descripción'),
              ),
              SizedBox(height: 20),
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: <Widget>[
                  TextButton(
                    child: Text('Cancelar'),
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                  ),
                  ElevatedButton(
                    onPressed: () {
                      String nombre = nombreController.text.trim();
                      String descripcion = descripcionController.text.trim();
                      if (nombre.isEmpty || descripcion.isEmpty) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content:
                                Text('Por favor, complete todos los campos'),
                          ),
                        );
                        return;
                      }
                      apiService.createTask({
                        'nombre': nombre,
                        'descripcion': descripcion,
                      }).then((_) {
                        Navigator.of(context).pop();
                      }).catchError((error) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text('Error al crear la tarea: $error'),
                          ),
                        );
                      });
                    },
                    child: Text('Guardar'),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
