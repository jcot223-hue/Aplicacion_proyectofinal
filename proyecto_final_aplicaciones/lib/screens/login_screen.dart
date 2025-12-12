import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'register_screen.dart';
import 'feed_screen.dart';

class LoginScreen extends StatelessWidget {
  final TextEditingController correoCtrl = TextEditingController();
  final TextEditingController passCtrl = TextEditingController();

  bool isValidEmail(String email) {
    return RegExp(r'^[^@]+@[^@]+\.[^@]+$').hasMatch(email);
  }

  Future<void> login(BuildContext context) async {
    if (!isValidEmail(correoCtrl.text)) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Correo inválido')));
      return;
    }
    if (passCtrl.text.length < 6) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Contraseña mínima 6 caracteres')));
      return;
    }
    try {
      var response = await http.post(
        Uri.parse('http://localhost:8080/users/login'),
        headers: {'Content-Type': 'application/json'},
        body: json.encode({'correo': correoCtrl.text, 'pass': passCtrl.text}),
      );
      if (response.statusCode == 200) {
        Navigator.pushReplacement(context, MaterialPageRoute(builder: (_) => FeedScreen()));
      } else {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Credenciales incorrectas')));
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Error de conexión: $e')));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: SingleChildScrollView(
          padding: EdgeInsets.all(25),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text("Iniciar Sesión", style: TextStyle(fontSize: 30, fontWeight: FontWeight.bold)),
              SizedBox(height: 30),
              SizedBox(
                width: MediaQuery.of(context).size.width * 0.6,
                child: TextField(
                  controller: correoCtrl,
                  decoration: InputDecoration(labelText: "Correo", border: OutlineInputBorder(borderRadius: BorderRadius.circular(14))),
                ),
              ),
              SizedBox(height: 20),
              SizedBox(
                width: MediaQuery.of(context).size.width * 0.6,
                child: TextField(
                  controller: passCtrl,
                  obscureText: true,
                  decoration: InputDecoration(labelText: "Contraseña", border: OutlineInputBorder(borderRadius: BorderRadius.circular(14))),
                ),
              ),
              SizedBox(height: 25),
              ElevatedButton(onPressed: () => login(context), child: Text("Ingresar")),
              TextButton(
                onPressed: () => Navigator.push(context, MaterialPageRoute(builder: (_) => RegisterScreen())),
                child: Text("Crear Cuenta"),
              ),
            ],
          ),
        ),
      ),
    );
  }
}