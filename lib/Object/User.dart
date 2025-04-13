// ignore: file_names
class User {
  // Constructor privado para evitar la instanciación externa
  User._();

  // Instancia única y estática de la clase (inicialmente nula)
  static User? _instancia;

  // Propiedades para almacenar los datos
  String? areaName;
  String? email;
  String? fullName;
  String? jobPosition;
  bool? rememberChangePassword;
  String? admissionDate;
  String? areaLead;
  String? accessToken;
  String? refreshToken;

  // Getter estático para acceder a la instancia única, permitiendo la inicialización
  static User? get instancia {
  return _instancia;
}
bool isUserNull() {
  return User._instancia == null;
}
  // Método estático para inicializar la instancia con los parámetros
  static void initialize(String areaName, String email, String fullName, String jobPosition,
      bool rememberChangePassword, String admissionDate, String areaLead, String accessToken, String refreshToken) {
    if (_instancia == null) {
      _instancia = User._();
      _instancia!.areaName = areaName;
      _instancia!.email = email;
      _instancia!.fullName = fullName;
      _instancia!.jobPosition = jobPosition;
      _instancia!.rememberChangePassword = rememberChangePassword;
      _instancia!.admissionDate = admissionDate;
      _instancia!.areaLead = areaLead;
      _instancia!.accessToken = accessToken;
      _instancia!.refreshToken = refreshToken;
      
    } else {
      // Si ya está inicializada, puedes optar por lanzar una excepción o simplemente no hacer nada
      throw Exception('La instancia de User ya ha sido inicializada.');
    }
  }

}