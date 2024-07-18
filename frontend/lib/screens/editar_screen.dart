import 'package:flutter/material.dart';
import 'package:frontend/models/tarea.dart';
import 'package:frontend/services/api_service.dart';

class EditarTareaScreen extends StatefulWidget {
  final Tarea tarea;

  EditarTareaScreen({required this.tarea});

  @override
  _EditarTareaScreenState createState() => _EditarTareaScreenState();
}

class _EditarTareaScreenState extends State<EditarTareaScreen> {
  final ApiService apiService = ApiService();
  late TextEditingController nombreController;
  late TextEditingController descripcionController;

  @override
  void initState() {
    super.initState();
    nombreController = TextEditingController(text: widget.tarea.nombre);
    descripcionController = TextEditingController(text: widget.tarea.descripcion);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Editar Tarea'),
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
                        print('Por favor, complete todos los campos');
                        return;
                      }
                      widget.tarea.nombre = nombre;
                      widget.tarea.descripcion = descripcion;
                      apiService.editarTarea(widget.tarea).then((_) {
                        Navigator.of(context).pop();
                      }).catchError((error) {
                        print('Error al editar la tarea: $error');
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
