import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import '../models/report.dart';

class AddReportScreen extends StatefulWidget {
  @override
  State<AddReportScreen> createState() => _AddReportScreenState();
}

class _AddReportScreenState extends State<AddReportScreen> {
  final descCtrl = TextEditingController();
  final ubicCtrl = TextEditingController();
  File? imagenFile;

  Future<void> pickImage() async {
    final picker = ImagePicker();
    final XFile? file = await picker.pickImage(source: ImageSource.gallery);

    if (file != null) {
      setState(() {
        imagenFile = File(file.path);
      });
    }
  }

  Future<void> submitReport() async {
    if (descCtrl.text.isEmpty || ubicCtrl.text.isEmpty) {
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text("Llena todos los campos")));
      return;
    }

    final nuevo = Report(
      nombre: "Usuario",
      ubicacion: ubicCtrl.text,
      descripcion: descCtrl.text,
      imagen: null, 
      fecha: DateTime.now(),
    );

    final response = await http.post(
      Uri.parse("http://localhost:8080/reports"),
      headers: {"Content-Type": "application/json"},
      body: jsonEncode(nuevo.toJson()),
    );

    if (response.statusCode == 200) {
      Navigator.pop(context);
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text("Reporte guardado")));
    } else {
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text("Error al guardar")));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Nuevo Reporte")),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            TextField(
              controller: ubicCtrl,
              decoration: InputDecoration(
                  labelText: "Ubicación", border: OutlineInputBorder()),
            ),
            SizedBox(height: 20),
            TextField(
              controller: descCtrl,
              maxLines: 3,
              decoration: InputDecoration(
                labelText: "Descripción",
                border: OutlineInputBorder(),
              ),
            ),
            SizedBox(height: 20),

            imagenFile == null
                ? Text("No se agregó foto", style: TextStyle(color: Colors.grey))
                : Image.file(imagenFile!, height: 150),

            TextButton.icon(
              onPressed: pickImage,
              icon: Icon(Icons.photo),
              label: Text("Subir foto (no funcional con esta API)"),
            ),

            Spacer(),
            ElevatedButton(
              onPressed: submitReport,
              child: Text("Guardar Reporte"),
            )
          ],
        ),
      ),
    );
  }
}
