import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import '../Login/login_screen.dart';

class CommonFunctions {
  // Función para truncar a dos tokens
  static String truncateToTwoTokens(String input) {
    List<String> tokens = input.split(' ');
    if (tokens.length > 2) {
      return '${tokens[0]} ${tokens[1]}';
    }
    return input;
  }

  // Función para reemplazar espacios por saltos de línea
  static String replaceSpacesWithNewline(String input) {
    return input.replaceAll(' ', '\n');
  }

  // Función para validar URLs
  static String validateUrl(String endpoint) {
    if (dotenv.env.isEmpty) {
      throw Exception(
          'Las variables de entorno no se han cargado. Asegúrate de llamar a dotenv.load() antes de usar CommonFunctions.');
    }

    final baseUrl = dotenv.env['BASE_URL'];
    if (baseUrl == null) {
      throw Exception('BASE_URL no está definido en el archivo .env');
    }

    return '$baseUrl$endpoint';
  }

  // Función para validar correos electrónicos
  static bool isValidEmail(String email) {
    final RegExp emailRegex = RegExp(
      r'^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$',
    );
    return emailRegex.hasMatch(email);
  }

  static bool isEmailNotEmpty(String text) {
    return text.isNotEmpty;
  }

  // Función para ofuscar correos electrónicos
  static String obfuscateEmail(String email) {
    if (email.isEmpty) {
      return '';
    }

    List<String> partes = email.split('@');
    if (partes.length != 2) {
      return email;
    }

    String usuario = partes[0];
    String dominio = partes[1];

    List<String> nameSecondname = usuario.split('.');
    if (nameSecondname.length != 2) {
      return email;
    }
    String name = nameSecondname[0];
    String secondName = nameSecondname[1];

    String usuarioOfuscado = '${name.replaceAll(RegExp(r'.'), '*')}.$secondName';
    return '$usuarioOfuscado@$dominio';
  }

  // Validación de código de usuario
  static bool isValidUserCode(String code) {
    final RegExp codeRegex = RegExp(r'^\d{6}$');
    return codeRegex.hasMatch(code);
  }

  // Validación de contraseñas
  static bool isValidPassword(String password) {
    final RegExp passwordRegExp = RegExp(
      r'^(?=.*[A-Z])(?=.*\d)(?=.*[!?¿¡"@_#$%&/()=])[A-Za-z\d!?¿¡"@_#$%&/()=]{8,}$',
    );
    return passwordRegExp.hasMatch(password);
  }

  // Comparación de contraseñas
  static bool arePasswordsEqual(String password1, String password2) {
    return password1 == password2;
  }

  // Nueva función: Manejo del cierre de sesión
  static Future<void> handleLogout(BuildContext context) async {
    try {
      // Elimina los tokens almacenados de forma segura
      const storage = FlutterSecureStorage();
      await storage.delete(key: 'access_token');
      await storage.delete(key: 'refresh_token');

      // Redirige al usuario al LoginScreen
      Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(builder: (context) => const LoginScreen()),
        (route) => false,
      );
    } catch (e) {
      // Manejo de errores
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Error al cerrar sesión: $e'),
        ),
      );
    }
  }
}
