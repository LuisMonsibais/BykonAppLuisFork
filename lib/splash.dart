import 'dart:async';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'Login/login_screen.dart';
import 'OnboardingScreen/Onboarding_Screen.dart';
import 'main.dart'; 

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    _checkOnboardingAndAuthentication();
  }

  Future<void> _checkOnboardingAndAuthentication() async {
    // Obtén una instancia de SharedPreferences
    final prefs = await SharedPreferences.getInstance();

    // Verifica si el usuario ya ha visto el onboarding
    final bool hasSeenOnboarding = prefs.getBool('hasSeenOnboarding') ?? false;

    // Verifica si el usuario está autenticado
    final bool isLoggedIn = prefs.containsKey('access_token');

    // Redirige según el estado
    Timer(const Duration(seconds: 3), () {
      if (!hasSeenOnboarding) {
        // Si no ha visto el onboarding, redirige a OnboardingScreen
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => const OnboardingScreen()),
        );
      } else if (isLoggedIn) {
        // Si está autenticado, redirige a HomeScreen
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (context) => const HomeScreen(
              name: 'Usuario', // Puedes reemplazar con datos reales
              jobPosition: 'Puesto',
            ),
          ),
        );
      } else {
        // Si no está autenticado, redirige a LoginScreen
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => const LoginScreen()),
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