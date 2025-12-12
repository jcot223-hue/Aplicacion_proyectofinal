import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class RegisterScreen extends StatefulWidget {
  @override
  _RegisterScreenState createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final TextEditingController nombreCtrl = TextEditingController();
  final TextEditingController correoCtrl = TextEditingController();
  final TextEditingController passCtrl = TextEditingController();

  bool isLoading = false;

  bool isValidEmail(String email) {
    return RegExp(r'^[^@]+@[^@]+\.[^@]+$').hasMatch(email);
  }

  Future<void> registrarUsuario(BuildContext context) async {
    if (nombreCtrl.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Escribe tu nombre')));
      return;
    }
    if (!isValidEmail(correoCtrl.text)) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Correo inválido')));
      return;
    }
    if (passCtrl.text.length < 6) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('La contraseña debe tener mínimo 6 caracteres')));
      return;
    }

    setState(() => isLoading = true);

    try {
      var response = await http.post(
        Uri.parse('http://localhost:8080/users/register'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
          'nombre': nombreCtrl.text,
          'correo': correoCtrl.text,
          'pass': passCtrl.text,
        }),
      );

      if (response.statusCode == 200) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Registro exitoso. Inicia sesión.')),
        );

        Navigator.pop(context); 
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('No se pudo registrar.')),
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error de conexión: $e')),
      );
    }

    setState(() => isLoading = false);
  }

  @override
  Widget build(BuildContext context) {
    final double width = MediaQuery.of(context).size.width * 0.6;

    return Scaffold(
      appBar: AppBar(title: Text("Crear Cuenta")),
      body: Center(
        child: SingleChildScrollView(
          padding: EdgeInsets.all(25),
          child: Column(
            children: [
              Text("Registro", style: TextStyle(fontSize: 30, fontWeight: FontWeight.bold)),
              SizedBox(height: 30),

              SizedBox(
                width: width,
                child: TextField(
                  controller: nombreCtrl,
                  decoration: InputDecoration(
                    labelText: "Nombre",
                    border: OutlineInputBorder(borderRadius: BorderRadius.circular(14)),
                  ),
                ),
              ),

              SizedBox(height: 20),

              SizedBox(
                width: width,
                child: TextField(
                  controller: correoCtrl,
                  decoration: InputDecoration(
                    labelText: "Correo",
                    border: OutlineInputBorder(borderRadius: BorderRadius.circular(14)),
                  ),
                ),
              ),

              SizedBox(height: 20),

              SizedBox(
                width: width,
                child: TextField(
                  controller: passCtrl,
                  obscureText: true,
                  decoration: InputDecoration(
                    labelText: "Contraseña",
                    border: OutlineInputBorder(borderRadius: BorderRadius.circular(14)),
                  ),
                ),
              ),

              SizedBox(height: 30),

              ElevatedButton(
                onPressed: isLoading ? null : () => registrarUsuario(context),
                child: isLoading
                    ? CircularProgressIndicator(color: Colors.white, strokeWidth: 2)
                    : Text("Registrar"),
              ),

              TextButton(
                onPressed: () => Navigator.pop(context),
                child: Text("¿Ya tienes cuenta? Inicia sesión"),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
