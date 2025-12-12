class Report {
  final String? id;
  final String nombre;
  final String ubicacion;
  final String descripcion;
  final String? imagen;
  final DateTime fecha;

  Report({
    this.id,
    required this.nombre,
    required this.ubicacion,
    required this.descripcion,
    this.imagen,
    required this.fecha,
  });

  factory Report.fromJson(Map<String, dynamic> json) {
    return Report(
      id: json['id'],
      nombre: json['nombre'],
      ubicacion: json['ubicacion'],
      descripcion: json['descripcion'],
      imagen: json['imagen'],
      fecha: DateTime.parse(json['fecha']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'nombre': nombre,
      'ubicacion': ubicacion,
      'descripcion': descripcion,
      'imagen': imagen,
      'fecha': fecha.toIso8601String(),
    };
  }
}
