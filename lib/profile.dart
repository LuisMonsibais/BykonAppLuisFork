import 'package:flutter/material.dart';
import 'package:mi_app/Object/User.dart';
import 'Common/commonFunctions.dart';
import 'configuration.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    String me="Libertad Rivera";
    return DefaultTabController(
      length: 2, // "Mis cursos" y "Mis proyectos"
      child: Scaffold(
        // Ponemos el fondo transparente para que el Container con gradient
        // sea el que se vea detrás, incluso debajo del AppBar redondeado
        backgroundColor: Colors.transparent,
        extendBodyBehindAppBar: true, // Permite que el body se extienda detrás del AppBar
        // -------------------------
        // AppBar redondeado abajo
        // -------------------------
        appBar: PreferredSize(
          preferredSize: const Size.fromHeight(kToolbarHeight),
          child: ClipRRect(
            borderRadius: const BorderRadius.only(
              bottomLeft: Radius.circular(20),
              bottomRight: Radius.circular(20),
            ),
            child: AppBar(
              backgroundColor: Colors.black,
              elevation: 0,
              title: const Align(
                alignment: Alignment.centerLeft,
                child: Padding(
                  padding: EdgeInsets.only(left: 16),
                  child: Text(
                    'Mi perfil',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
              leading: IconButton(
                icon: const Icon(Icons.arrow_back, color: Colors.white),
                onPressed: () => Navigator.pop(context),
              ),
              actions: [
                IconButton(
                  icon: const Icon(Icons.settings, color: Colors.white),
                  onPressed: () {
                    // Navegar a ConfigurationScreen
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const ConfigurationScreen(),
                      ),
                    );
                  },
                ),
                const SizedBox(width: 16),
              ],
            ),
          ),
        ),
        // -------------------------
        // Body con el gradiente a pantalla completa
        // -------------------------
        body: Container(
          width: double.infinity,
          height: double.infinity,
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              colors: [
                Color.fromARGB(255, 51, 0, 76), 
                Color(0xFFFF2D6A),
              ],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
          ),
          child: Column(
            children: [
              const SizedBox(height: kToolbarHeight + 100), 
              // +20 para separar un poco el card del AppBar
              // Card con info de usuario
              Padding(
                padding: const EdgeInsets.only(left: 16, right: 16),
                child: Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: const Color(0xFF333333),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Row(
                    children: [
                      CircleAvatar(
                        backgroundColor: Colors.grey,
                        radius: 30,
                        child: const Icon(Icons.person, color: Colors.white),
                      ),
                      const SizedBox(width: 16),

                      
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            '¡Hola ${CommonFunctions.truncateToTwoTokens(User.instancia?.fullName ?? 'Usuario')}!',
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          Text(
                            User.instancia?.jobPosition ?? 'job',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          Text(
                            User.instancia?.email ?? '' ,// 'email'
                            style: TextStyle(
                              color: Colors.grey,
                              fontSize: 14,
                            ),
                          ),
                          Text(
                            'Área: ${User.instancia?.areaName ?? ''}',// 'areaName'
                            style: TextStyle(
                              color: Colors.grey,
                              fontSize: 14,
                            ),
                          ),
                          Text(
                            'Fecha de ingreso: ${User.instancia?.admissionDate ?? ''}',// 'admissionDate'
                            style: TextStyle(
                              color: Colors.grey,
                              fontSize: 14,
                            ),
                          ),
                          Text(
                            'Líder: ${User.instancia?.areaLead ?? ''}',
                            style: TextStyle(
                              color: Colors.grey,
                              fontSize: 14,
                            ),
                          ),
                        ],
                      ),
                      const Spacer(),
                      const Icon(Icons.edit, color: Colors.white),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 32),
              // Tabs
              Container(
                decoration: const BoxDecoration(
                  color: Colors.black,
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(16),
                    topRight: Radius.circular(16),
                  ),
                ),
                child: const TabBar(
                  indicatorColor: Colors.white,
                  labelColor: Colors.white,
                  unselectedLabelColor: Colors.white,
                  labelStyle: TextStyle(
                    fontSize: 18, 
                    fontWeight: FontWeight.bold,
                  ),
                  tabs: [
                    Tab(text: 'Mis cursos'),
                    Tab(text: 'Mis proyectos'),
                  ],
                ),
              ),
              // Contenido de los tabs
              Expanded(
                child: Container(
                  color: Colors.black,
                  child: TabBarView(
                    children: [
                      // 1) Tab "Mis cursos"
                      SingleChildScrollView(
                        child: Column(
                          children: [
                            _buildCourseItem(
                              'Figma UI UX Design Advanced', 
                              'En curso', 
                              'Curso de Agosto'
                            ),
                            _buildCourseItem(
                              'Design Thinking: The Fundamentals', 
                              'Completado', 
                              'Curso de Julio'
                            ),
                            _buildCourseItem(
                              'UX Strategy fundamentals', 
                              'Completado', 
                              'Curso de Junio'
                            ),
                          ],
                        ),
                      ),
                      // 2) Tab "Mis proyectos" (Empty State con lupa)
                      Center(
                        child: Padding(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 16, vertical: 40),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: const [
                              Icon(
                                Icons.search,
                                size: 100,
                                color: Colors.grey,
                              ),
                              SizedBox(height: 24),
                              Text(
                                'Aún no tienes proyectos',
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 20,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              SizedBox(height: 8),
                              Text(
                                'Aquí verás los proyectos en los que participes',
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                  color: Colors.grey,
                                  fontSize: 16,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // Método para armar cada ítem de curso
  Widget _buildCourseItem(String title, String status, String date) {
    Color statusColor;
    Color textColor;
    double borderRadius = 99.0;

    if (status == 'Completado') {
      // Fondo verde
      statusColor = const Color.fromARGB(255, 206, 255, 207);
      textColor = const Color.fromARGB(255, 0, 31, 15);
    } else {
      // Fondo naranja
      statusColor = const Color.fromARGB(255, 255, 223, 175);
      textColor = const Color.fromARGB(255, 69, 50, 0);
    }

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      child: Container(
        padding: const EdgeInsets.all(16),
        height: 100,
        decoration: BoxDecoration(
          color: const Color.fromARGB(255, 67, 67, 67),
          borderRadius: BorderRadius.circular(12),
        ),
        child: Row(
          children: [
            // Info del curso
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 16, 
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Text(
                    date,
                    style: const TextStyle(
                      color: Colors.grey,
                      fontSize: 14,
                    ),
                  ),
                ],
              ),
            ),
            // Etiqueta de estado
            Chip(
              label: Text(
                status,
                style: TextStyle(
                  color: textColor,
                  fontSize: 14,
                ),
              ),
              backgroundColor: statusColor,
              padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(borderRadius),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
