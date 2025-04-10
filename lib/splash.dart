import 'dart:async';
import 'package:flutter/material.dart';
import 'package:mi_app/Login/login_screen.dart';
import 'OnboardingScreen/Onboarding_Screen.dart';
import 'package:shared_preferences/shared_preferences.dart';
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
    _checkOnboardingStatus();
  }

  Future<void> _checkOnboardingStatus() async {
    // Obtén una instancia de SharedPreferences
    final prefs = await SharedPreferences.getInstance();

    // Verifica si el usuario ya ha visto el onboarding
    final bool hasSeenOnboarding = prefs.getBool('hasSeenOnboarding') ?? false;

    // Redirige según el estado
    Timer(const Duration(seconds: 3), () {
      if (hasSeenOnboarding) {
        // Si ya vio el onboarding, redirige a Login
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => LoginScreen()),
        );
      } else {
        // Si no lo ha visto, redirige a Onboarding
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => OnboardingScreen()),
        );
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [
              Color.fromARGB(255, 70, 0, 86), // Morado
              Color(0xFFFF0080), // Rosa fuerte
            ],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        child: Center(
          child: Image.asset(
            'assets/ByKon Logo.png',
            width: 200,
          ),
        ),
      ),
    );
  }
}