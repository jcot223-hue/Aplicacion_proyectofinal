import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:geolocator/geolocator.dart';

class Reporte {
  Uint8List imagen;
  String descripcion;
  String ubicacion;

  Reporte({
    required this.imagen,
    required this.descripcion,
    required this.ubicacion,
  });
}

class FeedScreen extends StatefulWidget {
  @override
  _FeedScreenState createState() => _FeedScreenState();
}

class _FeedScreenState extends State<FeedScreen> {
  Uint8List? nuevaImagen;
  final TextEditingController descripcionCtrl = TextEditingController();

  List<Reporte> reportes = [];

  Future<void> pickImage() async {
    final picker = ImagePicker();
    final XFile? picked = await picker.pickImage(source: ImageSource.gallery);

    if (picked != null) {
      nuevaImagen = await picked.readAsBytes();
      setState(() {});
    }
  }
  Future<String> obtenerUbicacion() async {
    bool servicio = await Geolocator.isLocationServiceEnabled();
    if (!servicio) return "Ubicación no disponible";

    LocationPermission permiso = await Geolocator.checkPermission();
    if (permiso == LocationPermission.denied) {
      permiso = await Geolocator.requestPermission();
    }

    if (permiso == LocationPermission.denied ||
        permiso == LocationPermission.deniedForever) {
      return "Permiso denegado";
    }

    Position pos = await Geolocator.getCurrentPosition();
    return "Lat: ${pos.latitude}, Lon: ${pos.longitude}";
  }
  Future<void> agregarReporte() async {
    if (nuevaImagen == null) {
      ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("Selecciona una imagen")));
      return;
    }

    if (descripcionCtrl.text.trim().isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("Escribe una descripción")));
      return;
    }

    String ubic = await obtenerUbicacion();

    Reporte nuevo = Reporte(
      imagen: nuevaImagen!,
      descripcion: descripcionCtrl.text.trim(),
      ubicacion: ubic,
    );

    setState(() {
      reportes.add(nuevo);
      nuevaImagen = null;
      descripcionCtrl.clear();
    });

    Navigator.pop(context); 
  }
  void mostrarModalCrear() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (_) {
        return Padding(
          padding: EdgeInsets.only(
            bottom: MediaQuery.of(context).viewInsets.bottom + 20,
            left: 20,
            right: 20,
            top: 20,
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text("Nuevo Reporte",
                  style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold)),

              SizedBox(height: 20),

              nuevaImagen != null
                  ? Image.memory(nuevaImagen!, height: 150)
                  : Container(
                      height: 150,
                      color: Colors.grey.shade300,
                      child: Center(child: Text("No hay imagen")),
                    ),

              SizedBox(height: 10),

              ElevatedButton(
                onPressed: pickImage,
                child: Text("Seleccionar Imagen"),
              ),

              SizedBox(height: 10),

              TextField(
                controller: descripcionCtrl,
                decoration: InputDecoration(
                    labelText: "Descripción",
                    border: OutlineInputBorder()
                ),
              ),

              SizedBox(height: 20),

              ElevatedButton(
                onPressed: agregarReporte,
                child: Text("Guardar Reporte"),
              ),
            ],
          ),
        );
      },
    );
  }

  void eliminarReporte(int index) {
    setState(() {
      reportes.removeAt(index);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Reportes"),
        actions: [
          IconButton(
            icon: Icon(Icons.add),
            onPressed: mostrarModalCrear,
          ),
        ],
      ),

      body: reportes.isEmpty
          ? Center(child: Text("No hay reportes aún"))
          : ListView.builder(
              itemCount: reportes.length,
              itemBuilder: (context, index) {
                final rep = reportes[index];
                return Card(
                  margin: EdgeInsets.all(15),
                  child: Padding(
                    padding: EdgeInsets.all(15),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Image.memory(rep.imagen, height: 200, fit: BoxFit.cover),
                        SizedBox(height: 10),

                        Text(rep.descripcion,
                            style: TextStyle(
                                fontSize: 16, fontWeight: FontWeight.bold)),
                        SizedBox(height: 5),

                        Text(rep.ubicacion,
                            style: TextStyle(color: Colors.grey)),

                        SizedBox(height: 10),

                        Align(
                          alignment: Alignment.centerRight,
                          child: TextButton(
                            onPressed: () => eliminarReporte(index),
                            child: Text("Eliminar", style: TextStyle(color: Colors.red)),
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
    );
  }
}

