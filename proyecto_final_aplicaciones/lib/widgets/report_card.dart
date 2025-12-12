import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import '../models/report.dart';

class ReportCard extends StatelessWidget {
  final Report r;
  final VoidCallback onDelete;

  ReportCard(this.r, {required this.onDelete});

  Future<void> deleteReport(BuildContext context) async {
    try {
      var response = await http.delete(Uri.parse('http://localhost:8080/reports/${r.id}'));
      if (response.statusCode == 200) {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Reporte eliminado')));
        onDelete();
      } else {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Error eliminando')));
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Error de conexión: $e')));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
      margin: EdgeInsets.only(bottom: 20),
      elevation: 3,
      child: Padding(
        padding: const EdgeInsets.all(15),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(r.nombre, style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                Text("${r.fecha.hour}:${r.fecha.minute}", style: TextStyle(color: Colors.grey)),
              ],
            ),
            Text(r.ubicacion, style: TextStyle(color: Colors.grey)),
            SizedBox(height: 15),
            Container(
              width: double.infinity,
              height: 180,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10),
                color: Colors.grey.shade200,
              ),
              child: r.imagen == null
                  ? Center(child: Text("No se agregó foto", style: TextStyle(color: Colors.grey)))
                  : ClipRRect(
                      borderRadius: BorderRadius.circular(10),
                      child: Image.network(r.imagen!, fit: BoxFit.cover),
                    ),
            ),
            SizedBox(height: 10),
            Text(r.descripcion),
            SizedBox(height: 10),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                TextButton.icon(onPressed: () {}, icon: Icon(Icons.thumb_up), label: Text("Me gusta")),
                TextButton.icon(onPressed: () {}, icon: Icon(Icons.comment), label: Text("Comentar")),
                TextButton.icon(onPressed: () {}, icon: Icon(Icons.share), label: Text("Compartir")),
                IconButton(
                  icon: Icon(Icons.delete, color: Colors.red),
                  onPressed: () => deleteReport(context),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}