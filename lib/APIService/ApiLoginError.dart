// ignore: file_names
sealed class ApiLoginError {
  final dynamic error;
  ApiLoginError(this.error);
}
class UnknownError extends ApiLoginError {
  UnknownError(int statusCode) : super("Error desconocido: $statusCode");
}

class UnauthorizedError extends ApiLoginError {
  UnauthorizedError() : super('Verifica que tu contraseña sea correcta e inténtalo de nuevo.');
}

class NotFoundError extends ApiLoginError {
  NotFoundError() : super('Verifica que tu correo sea correcto e inténtalo de nuevo.');
}

class InternalServerError extends ApiLoginError {
  InternalServerError() : super('Algo salió mal. Inténtalo de nuevo en unos momentos.');
}

class EmailInactiveError extends ApiLoginError {
  EmailInactiveError() : super('Correo inactivo. Escríbenos a contacto@bykon.com.mx y te ayudaremos.');
}

ApiLoginError handleResponseError(int statusCode) {
  switch (statusCode) {
    case 401:
      return UnauthorizedError();
    case 452:
      return NotFoundError();
    case 500:
      return InternalServerError();
    case 550:
      return EmailInactiveError();
    default:
      // Puedes agregar un error por defecto o lanzar una excepción
      return UnknownError(statusCode);
  }
}

String handleLoginError(int responseStatusCode) {
  var errorResult = handleResponseError(responseStatusCode); // Llama a la función que maneja los errores
  String errorMessage;

  if (errorResult is UnauthorizedError) { // 401 Verifica que tu contraseña sea correcta e inténtalo de nuevo.
    errorMessage = errorResult.error.toString();
  } else if (errorResult is NotFoundError) { // 452 Verifica que tu correo sea correcto e inténtalo de nuevo.
    errorMessage = errorResult.error.toString(); 
  } else if (errorResult is InternalServerError) { // 500 Algo salió mal. Inténtalo de nuevo en unos momentos.
    errorMessage = errorResult.error.toString(); 
  } else if (errorResult is EmailInactiveError) { // 550Correo inactivo. Escríbenos a contacto@bykon.com.mx y te ayudaremos.
    errorMessage = errorResult.error.toString(); 
  } else if (errorResult is UnknownError) { // Default
    errorMessage = errorResult.error.toString(); // Salida: {error: Error desconocido}
  } else {
    errorMessage = "Error desconocido. Inténtalo más tarde.";
  }

  return errorMessage;
}