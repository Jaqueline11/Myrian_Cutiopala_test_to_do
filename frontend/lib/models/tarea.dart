class Tarea{
  final int id;
  String nombre;
  String descripcion;
  bool estadoCompletado;
  bool estado;


  //Constructor
  Tarea({
    required this.id,
    required this.nombre,
    required this.descripcion,
    required this.estadoCompletado,
    required this.estado,
  });

  //Metodo de fabrica, crea una instancia de tarea
  factory Tarea.fromJson(Map<String, dynamic> json) {
    return Tarea(
      id: json['id'],
      nombre: json['nombre'],
      descripcion: json['descripcion'],
      estadoCompletado: json['estadoCompletado'],
      estado: json['estado'],
    );
  }
  
  //Serializacion a JSON
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'nombre': nombre,
      'descripcion': descripcion,
      'estadoCompletado': estadoCompletado,
      'estado': estado,
    };
  }
}