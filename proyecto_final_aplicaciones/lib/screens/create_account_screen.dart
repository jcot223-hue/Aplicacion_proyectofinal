import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Nuevo Reporte"),
      ),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            TextField(
              controller: ubicCtrl,
              decoration: InputDecoration(
                labelText: "Ubicación",
                border: OutlineInputBorder(),
              ),
            ),
            SizedBox(height: 20),

            TextField(
              controller: descCtrl,
              maxLines: 3,
              decoration: InputDecoration(
                labelText: "Descripción del problema",
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
              label: Text("Subir foto (opcional)"),
            ),

            Spacer(),

            ElevatedButton(
              onPressed: () {
                final nuevo = Report( 
                  nombre: "Usuario",            
                  ubicacion: ubicCtrl.text,
                  descripcion: descCtrl.text,
                  imagen: imagenFile?.path,
                  fecha: DateTime.now(),
                );

                Navigator.pop(context, nuevo);
              },
              child: Text("Guardar Reporte"),
            ),
          ],
        ),
      ),
    );
  }
}
