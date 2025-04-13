import 'package:flutter/material.dart';
import 'package:intl/date_symbol_data_local.dart'; // Para initializeDateFormatting
import 'profile.dart';
import 'splash.dart';
import 'vacaciones.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import '../Common/commonFunctions.dart';

/// Conviertes el main en async
/*void*/Future<void>  main() async {
  /// Aseguramos la inicialización de bindings
  WidgetsFlutterBinding.ensureInitialized();

  /// Inicializamos el formateo de fechas para 'es' (o el idioma que necesites)
  await initializeDateFormatting('es', null);

await dotenv.load(fileName: ".env"); // Cargar variables de entorno
  /// Ahora corremos la app
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: const SplashScreen(), // Cambiar a OnboardingScreen() para la pantalla de carga
    );
  }
}


class HomeScreen extends StatelessWidget {

  final String name;
  final String jobPosition;

 const HomeScreen({super.key, required this.name, required this.jobPosition}); 

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // Para que el body se extienda también detrás del bottomNavBar
      extendBody: true,
      extendBodyBehindAppBar: true,
      // El fondo principal
      body: Container(
        // Tu gradiente de fondo
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [
              Color.fromARGB(255, 70, 0, 86),
              Color(0xFFFF0080),
            ],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // AppBar "personalizado"
            PreferredSize(
              preferredSize: const Size.fromHeight(80),
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                margin: const EdgeInsets.only(top: 60),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Image.asset(
                      'assets/ByKon Logo.png',
                      width: 80,
                      height: 80,
                      fit: BoxFit.contain,
                    ),
                    GestureDetector(
                      onTap: () {
                        // Notificaciones
                      },
                      child: const Icon(
                        Icons.notifications, 
                        color: Colors.white,
                      ),
                    ),
                  ],
                ),
              ),
            ),

            // Sección del usuario
            Padding(
              padding: const EdgeInsets.only(left: 16, right: 16, top: 10, bottom: 40),
              child: GestureDetector(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => const ProfileScreen()),
                  );
                },
                child: Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: const Color(0xFF333333),
                    borderRadius: BorderRadius.circular(12),
                    boxShadow: const [
                      BoxShadow(
                        color: Color.fromARGB(75, 0, 0, 0),
                        offset: Offset(0, -2),
                        blurRadius: 15,
                        spreadRadius: 2,
                      ),
                      BoxShadow(
                        color: Color.fromARGB(81, 0, 0, 0),
                        offset: Offset(0, 2),
                        blurRadius: 15,
                        spreadRadius: 2,
                      ),
                    ],
                  ),
                  child: Row(
                    children: [
                      CircleAvatar(
                        backgroundColor: Colors.grey,
                        radius: 30,
                        child: const Icon(Icons.person, color: Colors.white),
                      ),
                      const SizedBox(width: 20),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children:  [
                          Text(
                             '¡Hola ${CommonFunctions.truncateToTwoTokens(name)}!', 
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          Text(
                             jobPosition, 
                            style: TextStyle(
                              color: Colors.grey,
                              fontSize: 14,
                            ),
                          ),
                        ],
                      ),
                      const Spacer(),
                      const Icon(
                        Icons.arrow_forward,
                        color: Colors.white,
                      ),
                    ],
                  ),
                ),
              ),
            ),

            // Contenido principal scrollable (fondo negro con bordes redondeados)
            Expanded(
              child: Container(
                decoration: const BoxDecoration(
                  color: Colors.black,
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(24),
                    topRight: Radius.circular(24),
                  ),
                ),
                child: SingleChildScrollView(
                  // Ponle el padding que gustes
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Título: ¿Qué quieres hacer hoy?
                      const Padding(
                        padding: EdgeInsets.symmetric(horizontal: 16, vertical: 32),
                        child: Text(
                          '¿Qué quieres hacer hoy?',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 28,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                      const SizedBox(height: 16),

               // Fila de íconos
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 16),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                          children: [
                            _buildActionIcon(Icons.receipt_long, 'Recibos\nde nómina'),
                            _buildActionIcon(Icons.volunteer_activism, 'Prestaciones\n y beneficios'),
                            _buildActionIcon(Icons.school, 'Mis\n cursos'),
                            GestureDetector(
                              onTap: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => const IncidenciasVacacionesScreen(),
                                  ),
                                );
                              },
                              child: _buildActionIcon(Icons.calendar_today, 'Agendar\n vacaciones'),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 32),

                      // Título: Próximos eventos
                      const Padding(
                        padding: EdgeInsets.symmetric(horizontal: 16),
                        child: Text(
                          'Próximos Eventos',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                      const SizedBox(height: 18),

                      // Contenedor de eventos
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 16),
                        child: Container(
                          height: 208,
                          decoration: BoxDecoration(
                            gradient: const LinearGradient(
                              colors: [
                                Color.fromARGB(255, 65, 0, 78),
                                Color.fromARGB(255, 120, 0, 66),
                              ],
                            ),
                            borderRadius: BorderRadius.circular(16),
                          ),
                          child: const Center(
                            child: Text(
                              'Thriving in the New, the Now and the Unknown.',
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 28,
                              ),
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(height: 24),

                      // Título: Entérate
                      const Padding(
                        padding: EdgeInsets.symmetric(horizontal: 16),
                        child: Text(
                          'Entérate',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                      const SizedBox(height: 16),

                      // Contenedor "Entérate"
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 16),
                        child: Container(
                          height: 150,
                          decoration: BoxDecoration(
                            color: Colors.grey[800],
                            borderRadius: BorderRadius.circular(16),
                          ),
                          child: const Center(
                            child: Icon(
                              Icons.play_circle_fill,
                              size: 50,
                              color: Colors.white,
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(height: 120),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
      // ------------
      // BottomNav con bordes redondeados
      // ------------
      bottomNavigationBar: ClipRRect(
        borderRadius: const BorderRadius.only(
          topLeft: Radius.circular(24),
          topRight: Radius.circular(24),
        ),
        child: BottomNavigationBar(
          backgroundColor: const Color.fromARGB(255, 52, 0, 54),
          selectedItemColor: const Color.fromARGB(255, 196, 128, 255),
          unselectedItemColor: const Color.fromARGB(255, 255, 255, 255),
          items: const [
            BottomNavigationBarItem(
              icon: Icon(Icons.home),
              label: 'Inicio',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.people),
              label: 'Directorio',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.calendar_today),
              label: 'Calendario',
            ),
          ],
        ),
      ),
    );
  }

  // Widget para la fila de íconos
  static Widget _buildActionIcon(IconData icon, String label) {
    return Column(
      children: [
        CircleAvatar(
          backgroundColor: const Color.fromARGB(255, 80, 80, 80),
          radius: 30,
          child: Icon(icon, color: const Color.fromARGB(255, 255, 255, 255)),
        ),
        const SizedBox(height: 8),
        Text(
          label,
          textAlign: TextAlign.center,
          style: const TextStyle(color: Colors.white, fontSize: 14),
        ),
      ],
    );
  }
}
