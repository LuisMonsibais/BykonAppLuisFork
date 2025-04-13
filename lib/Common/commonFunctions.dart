import 'package:flutter_dotenv/flutter_dotenv.dart';

class CommonFunctions {

  static String truncateToTwoTokens(String input) {
  // Dividir la cadena en tokens (palabras) usando el espacio como separador
  List<String> tokens = input.split(' ');

  // Si hay más de dos tokens, truncar a los dos primeros
  if (tokens.length > 2) {
    return '${tokens[0]} ${tokens[1]}';
  }

  // Si tiene dos o menos tokens, devolver la cadena original
  return input;
}
  //funcion para reemplazar espacios por saltos de linea
  static  String replaceSpacesWithNewline(String input) {
      return input.replaceAll(' ', '\n');
  }

  static String validateUrl(String endpoint) {
    // Verificar si las variables de entorno se han cargado
    if (dotenv.env.isEmpty) {
      throw Exception('Las variables de entorno no se han cargado. Asegúrate de llamar a dotenv.load() antes de usar CommonFunctions.');
    }

    final baseUrl = dotenv.env['BASE_URL'];
    if (baseUrl == null) {
      throw Exception('BASE_URL no está definido en el archivo .env');
    }

    return '$baseUrl$endpoint'; // Concatenar la URL base con el endpoint
  }
//_isMailWellDone
    static bool isValidEmail(String email) {
    // Expresión regular para validar un correo electrónico
    final RegExp emailRegex = RegExp(
      r'^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$',
    );

    // Verifica si el correo coincide con la expresión regular
    return emailRegex.hasMatch(email);
  }

  static bool isEmailNotEmpty(String text) {
    return text.isNotEmpty;
  }

static String obfuscateEmail(String email) {
        if (email.isEmpty) {
          return '';
        }

        List<String> partes = email.split('@');
        if (partes.length != 2) {
          return email; // No es un correo electrónico válido, devuelve el original
        }

        String usuario = partes[0];
        String dominio = partes[1];

        List<String> nameSecondname = usuario.split('.');
        if (nameSecondname.length != 2) {
          return email; // No es un correo electrónico válido, devuelve el original
        }
        String name = nameSecondname[0];
        String secondName = nameSecondname[1];

        String usuarioOfuscado = '';
//        usuarioOfuscado = name.replaceAll(RegExp(r'.'), '*') + '.'+secondName;
        usuarioOfuscado = '${name.replaceAll(RegExp(r'.'), '*')}.$secondName';


        return '$usuarioOfuscado@$dominio';
    }
    
 static bool isValidUserCode(String code) {
    final RegExp codeRegex = RegExp(r'^\d{6}$');
    return codeRegex.hasMatch(code);
  }

static bool isValidPassword(String password) {
    // Expresión regular para validar la contraseña
    final RegExp passwordRegExp = RegExp(
      // Al menos 8 caracteres, al menos una letra mayúscula, al menos un número y al menos un carácter especial
      r'^(?=.*[A-Z])(?=.*\d)(?=.*[!?¿¡"@_#$%&/()=])[A-Za-z\d!?¿¡"@_#$%&/()=]{8,}$',
    );
    return passwordRegExp.hasMatch(password);
  }

  // Función para comparar dos contraseñas
static bool arePasswordsEqual(String password1, String password2) {
  return password1 == password2;
}
}
