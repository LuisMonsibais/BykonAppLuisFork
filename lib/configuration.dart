import 'package:flutter/material.dart';
import '../APIService/api_service.dart';
import 'changepassword.dart'; // Ajusta la ruta según tu estructura de archivos

class ConfigurationScreen extends StatefulWidget {
  const ConfigurationScreen({super.key});

  @override
  State<ConfigurationScreen> createState() => _ConfigurationScreenState();
}

class _ConfigurationScreenState extends State<ConfigurationScreen> {
  // Variables para los Switch
  bool isBiometricEnabled = true;
  bool isNotificationsEnabled = true;

  // Instancia del servicio API
  final ApiService _apiService = ApiService();

  @override
  Widget build(BuildContext context) {
    // ------------------- PARÁMETROS DE ESTILO -------------------
    final LinearGradient backgroundGradient = const LinearGradient(
      colors: [
        Color(0xFF33004C), // Morado oscuro
        Color(0xFFFF2D6A), // Rosa fuerte
      ],
      begin: Alignment.topLeft,
      end: Alignment.bottomRight,
    );

    final Color appBarColor = Colors.black;
    final Color appBarIconColor = Colors.white;
    final double appBarBottomRadius = 10.0;
    final String appBarTitle = 'Configuración';
    final double appBarTitleSize = 20.0;
    final Color appBarTitleColor = Colors.white;

    final double spaceBetweenAppBarAndContainer = 80.0;

    final double containerTopRadius = 16.0;
    final Color containerColor = Colors.black;

    final Color cardBackgroundColor = const Color(0xFF1C1C1C);
    final double cardBorderRadius = 8.0;
    final double cardPadding = 16.0;
    final Color iconColor = const Color(0xFFD9B3FF);
    final double iconSize = 32.0;
    final Color textColor = Colors.white;
    final double textSize = 18.0;

    final Color switchActiveColor = Colors.white;
    final Color switchActiveTrackColor = const Color(0xFF9E00FF);
    final Color switchInactiveThumbColor = Colors.white;
    final Color switchInactiveTrackColor = Colors.grey;

    final Color buttonBackgroundColor = Colors.black;
    final Color buttonTextColor = const Color.fromARGB(255, 242, 224, 254);
    final double buttonFontSize = 18.0;
    final Color buttonBorderColor = const Color.fromARGB(255, 242, 224, 254);
    final double buttonBorderWidth = 2.0;
    final double buttonBorderRadius = 30.0;
    final double buttonPadding = 16.0;
    // ------------------------------------------------------------

    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          gradient: backgroundGradient,
        ),
        child: Column(
          children: [
            // AppBar personalizado
            ClipRRect(
              borderRadius: BorderRadius.only(
                bottomLeft: Radius.circular(appBarBottomRadius),
                bottomRight: Radius.circular(appBarBottomRadius),
              ),
              child: Container(
                color: appBarColor,
                child: SafeArea(
                  bottom: false,
                  child: SizedBox(
                    height: kToolbarHeight,
                    child: Row(
                      children: [
                        IconButton(
                          icon: Icon(Icons.arrow_back, color: appBarIconColor),
                          onPressed: () => Navigator.pop(context),
                        ),
                        const SizedBox(width: 8),
                        Text(
                          appBarTitle,
                          style: TextStyle(
                            color: appBarTitleColor,
                            fontSize: appBarTitleSize,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),

            SizedBox(height: spaceBetweenAppBarAndContainer),

            // Contenedor negro con bordes redondeados arriba
            Expanded(
              child: Container(
                decoration: BoxDecoration(
                  color: containerColor,
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(containerTopRadius),
                    topRight: Radius.circular(containerTopRadius),
                  ),
                ),
                child: Column(
                  children: [
                    Expanded(
                      child: SingleChildScrollView(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 16.0,
                          vertical: 24.0,
                        ),
                        child: Column(
                          children: [
                            // Tarjeta 1: "Cambiar contraseña"
                            GestureDetector(
                              onTap: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) =>
                                        const ChangePasswordScreen(),
                                  ),
                                );
                              },
                              child: Container(
                                height: 80.0,
                                margin: const EdgeInsets.only(bottom: 24.0),
                                padding: EdgeInsets.all(cardPadding),
                                decoration: BoxDecoration(
                                  color: cardBackgroundColor,
                                  borderRadius:
                                      BorderRadius.circular(cardBorderRadius),
                                ),
                                child: Row(
                                  children: [
                                    Icon(Icons.lock,
                                        color: iconColor, size: iconSize),
                                    const SizedBox(width: 16),
                                    Text(
                                      'Cambiar contraseña',
                                      style: TextStyle(
                                        color: textColor,
                                        fontSize: textSize,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),

                            // Tarjeta 2: "Ingresar con huella o rostro"
                            Container(
                              margin: const EdgeInsets.only(bottom: 24.0),
                              padding: EdgeInsets.all(cardPadding),
                              decoration: BoxDecoration(
                                color: cardBackgroundColor,
                                borderRadius:
                                    BorderRadius.circular(cardBorderRadius),
                              ),
                              child: Row(
                                children: [
                                  Icon(Icons.fingerprint,
                                      color: iconColor, size: iconSize),
                                  const SizedBox(width: 16),
                                  Expanded(
                                    child: Text(
                                      'Ingresar con huella o rostro',
                                      style: TextStyle(
                                        color: textColor,
                                        fontSize: textSize,
                                      ),
                                    ),
                                  ),
                                  Switch(
                                    value: isBiometricEnabled,
                                    onChanged: (bool value) {
                                      setState(() {
                                        isBiometricEnabled = value;
                                      });
                                    },
                                    activeColor: switchActiveColor,
                                    activeTrackColor: switchActiveTrackColor,
                                    inactiveThumbColor:
                                        switchInactiveThumbColor,
                                    inactiveTrackColor:
                                        switchInactiveTrackColor,
                                  ),
                                ],
                              ),
                            ),

                            // Tarjeta 3: "Notificaciones"
                            Container(
                              margin: const EdgeInsets.only(bottom: 16.0),
                              padding: EdgeInsets.all(cardPadding),
                              decoration: BoxDecoration(
                                color: cardBackgroundColor,
                                borderRadius:
                                    BorderRadius.circular(cardBorderRadius),
                              ),
                              child: Row(
                                children: [
                                  Icon(Icons.notifications,
                                      color: iconColor, size: iconSize),
                                  const SizedBox(width: 16),
                                  Expanded(
                                    child: Text(
                                      'Notificaciones',
                                      style: TextStyle(
                                        color: textColor,
                                        fontSize: textSize,
                                      ),
                                    ),
                                  ),
                                  Switch(
                                    value: isNotificationsEnabled,
                                    onChanged: (bool value) {
                                      setState(() {
                                        isNotificationsEnabled = value;
                                      });
                                    },
                                    activeColor: switchActiveColor,
                                    activeTrackColor: switchActiveTrackColor,
                                    inactiveThumbColor:
                                        switchInactiveThumbColor,
                                    inactiveTrackColor:
                                        switchInactiveTrackColor,
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),

                    // Botón "Cerrar sesión"
                    Padding(
                      padding: const EdgeInsets.all(32.0),
                      child: SizedBox(
                        width: double.infinity,
                        child: ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: buttonBackgroundColor,
                            side: BorderSide(
                              color: buttonBorderColor,
                              width: buttonBorderWidth,
                            ),
                            shape: RoundedRectangleBorder(
                              borderRadius:
                                  BorderRadius.circular(buttonBorderRadius),
                            ),
                            padding: EdgeInsets.all(buttonPadding),
                          ),
                          onPressed: () {
                            showDialog(
                              context: context,
                              builder: (BuildContext context) {
                                return AlertDialog(
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(16.0),
                                  ),
                                  backgroundColor: containerColor,
                                  title: Row(
                                    children: [
                                      Icon(Icons.info, color: iconColor),
                                      const SizedBox(width: 8),
                                      Text(
                                        'Cerrar sesión',
                                        style: TextStyle(color: textColor),
                                      ),
                                    ],
                                  ),
                                  content: Text(
                                    '¿Quieres cerrar tu sesión en este dispositivo?',
                                    style: TextStyle(color: textColor),
                                  ),
                                  actions: [
                                    TextButton(
                                      onPressed: () {
                                        Navigator.of(context).pop();
                                      },
                                      child: Text(
                                        'Cancelar',
                                        style:
                                            TextStyle(color: buttonTextColor),
                                      ),
                                    ),
                                    TextButton(
                                      onPressed: () async {
                                        Navigator.of(context).pop();
                                        final result =
                                            await _apiService.logout();
                                        if (result != null &&
                                            result.containsKey('message')) {
                                          Navigator.of(context)
                                              .pushNamedAndRemoveUntil(
                                                  '/login', (route) => false);
                                        } else {
                                          ScaffoldMessenger.of(context)
                                              .showSnackBar(
                                            const SnackBar(
                                              content: Text(
                                                  'Error al cerrar sesión. Inténtalo de nuevo.'),
                                            ),
                                          );
                                        }
                                      },
                                      child: Text(
                                        'Cerrar sesión',
                                        style:
                                            TextStyle(color: buttonTextColor),
                                      ),
                                    ),
                                  ],
                                );
                              },
                            );
                          },
                          child: Text(
                            'Cerrar sesión',
                            style: TextStyle(
                              color: buttonTextColor,
                              fontSize: buttonFontSize,
                            ),
                          ),
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
    );
  }
}