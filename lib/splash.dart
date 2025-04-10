import 'dart:async';
import 'package:flutter/material.dart';
import 'package:mi_app/Login/login_screen.dart';
import 'OnboardingScreen/Onboarding_Screen.dart';
// Importa tu main.dart para acceder a HomeScreen
// Ajusta la ruta si estás en otra carpeta

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    // Iniciamos el Timer de 3 segundos
    Timer(const Duration(seconds: 3), () {
      // Pasados 3s, navegamos a la pantalla de Home
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (context) => OnboardingScreen(), 
        ),
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // Usamos un Container con el degradado y el logo
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [
              Color.fromARGB(255, 70, 0, 86), // Morado (ajusta tus tonos exactos)
              Color(0xFFFF0080), // Rojizo o rosa fuerte
            ],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        // Logo centrado
        child: Center(
          child: Image.asset(
            'assets/ByKon Logo.png',
            width: 200,   // Ajusta el tamaño del logo a tu gusto
          ),
        ),
      ),
    );
  }
}
