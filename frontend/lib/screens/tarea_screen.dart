import 'package:flutter/material.dart';
import 'package:frontend/models/tarea.dart';
import 'package:frontend/screens/crear_Screen.dart';
import 'package:frontend/screens/editar_screen.dart';
import 'package:frontend/screens/grafico_screen.dart';
import 'package:frontend/services/api_service.dart';

class TareaScreen extends StatefulWidget {
  @override
  TareaScreenState createState() => TareaScreenState();
}

class TareaScreenState extends State<TareaScreen> {
  late Future<List<Tarea>> tareas;
  final ApiService apiService = ApiService();

  @override
  void initState() {
    super.initState();
    tareas = ApiService().listarTreas();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('To Do Project'),
        elevation: 0,
        actions: [
          IconButton(
            icon: const Icon(Icons.add),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => CrearTareaScreen()),
              ).then((value) {
                setState(() {
                  tareas = apiService.listarTreas();
                });
              });
            },
          ),
          IconButton(
            icon: const Icon(Icons.pie_chart),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => GraficoScreen()),
              );
            },
          ),
        ],
      ),
      body: FutureBuilder<List<Tarea>>(
        future: tareas,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else if (snapshot.hasData) {
            List<Tarea> tareas = snapshot.data!;
            return ListView.separated(
              itemCount: tareas.length,
              itemBuilder: (context, index) {
                var tarea = tareas[index];
                return ListTile(
                  title: Text(tarea.nombre),
                  subtitle: Text(tarea.descripcion),
                  trailing: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Tooltip(
                        message: 'Editar tarea',
                        child: GestureDetector(
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) =>
                                    EditarTareaScreen(tarea: tarea),
                              ),
                            ).then((value) {
                              setState(() {
                              //tareas = apiService.listarTreas();
                              });
                            });
                          },
                          child: Icon(Icons.edit),
                        ),
                      ),
                      Tooltip(
                        message: 'Eliminar tarea',
                        child: IconButton(
                          icon: const Icon(Icons.delete),
                          onPressed: () {
                            eliminarTarea(tarea);
                          },
                        ),
                      ),
                      Tooltip(
                        message: 'Completar la tarea',
                        child: Checkbox(
                          value: tarea.estadoCompletado,
                          onChanged: (bool? value) {
                            _toggleCompleto(tareas, index);
                          },
                        ),
                      ),
                    ],
                  ),
                  onTap: () {
                    print(tarea.nombre);
                  },
                );
              },
              separatorBuilder: (context, index) => const Divider(),
            );
          } else {
            return Center(child: Text('No hay datos disponibles'));
          }
        },
      ),
    );
  }

  Future<void> _toggleCompleto(List<Tarea> tareas, int index) async {
    setState(() {
      tareas[index].estadoCompletado = !tareas[index].estadoCompletado;
    });
    try {
      await apiService.actualizarEstadoCompletado(tareas[index]);
    } catch (error) {
      setState(() {
        tareas[index].estadoCompletado = !tareas[index].estadoCompletado;
      });
      print('Error al actualizar el estado: $error');
    }
  }

  Future<void> eliminarTarea(Tarea tarea) async {
    bool? confirmar = await showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Confirmar eliminación'),
          content: Text('¿Estás seguro de que deseas eliminar esta tarea?'),
          actions: <Widget>[
            TextButton(
              child: Text('Cancelar'),
              onPressed: () {
                Navigator.of(context).pop(false);
              },
            ),
            TextButton(
              child: Text('Eliminar'),
              onPressed: () {
                Navigator.of(context).pop(true);
              },
            ),
          ],
        );
      },
    );

    if (confirmar == true) {
      setState(() {
        tarea.estado = false;
      });
      try {
        await apiService.actualizarEstado(tarea);
        setState(() {
          tareas = apiService.listarTreas();
        });
      } catch (error) {
        setState(() {
          tarea.estado = !tarea.estado;
        });
        print('Error al actualizar el estado: $error');
      }
    }
  }
}
