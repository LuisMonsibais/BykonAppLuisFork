import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:mi_app/Object/User.dart';
import '../Common/commonFunctions.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';


Future<void> saveToken(String key,String accessToken) async {
  final storage = FlutterSecureStorage();
  try {
    await storage.write(key: key, value: accessToken);
  } catch (e) {
    return;
  }
}

Future<String?> getToken(String key) async {
  final storage = FlutterSecureStorage();
  try {
    final token = await storage.read(key : key);//'access_token'
    return token;
  } catch (e) {
    return null;
  }
}

Future<void> deleteToken(String key) async {
  final storage = FlutterSecureStorage();
  await storage.delete(key: key);
}



class ApiService {
  Future<void> saveBoolean(String key, bool value) async {
  final storage = FlutterSecureStorage();
  try {
    // Convertir el booleano a String antes de guardarlo
    await storage.write(key: key, value: value.toString());
  } catch (e) {
    return;
  }
}
Future<bool?> getBoolean(String key) async {
  final storage = FlutterSecureStorage();
  try {
    final value = await storage.read(key: key);
    if (value != null) {
      return value.toLowerCase() == 'true'; // Convertir el String a boolean
    } else {
      return null;
    }
  } catch (e) {
    return null;
  }
}
  // Instancia única de la clase (Singleton)
  static final ApiService _instance = ApiService._internal();

  // Constructor privado
  ApiService._internal();

  // Método factory para obtener la instancia única
  factory ApiService() {
    return _instance;
  }

  // URL base de la API

  // Servicio 1: Login
  Future<Map<String, dynamic>?> login(String email, String password) async {
    final url = CommonFunctions.validateUrl('/api/auth/v1/login');
    try {
      final response = await http.post(
        Uri.parse(url),//url as Uri,
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
          "email": email,
          "password": password,
        }),
      );

      if (response.statusCode == 200) {
         final Map<String, dynamic> responseData = jsonDecode(response.body);
         //-------------------------------------------------------------------
          // Guardar los pricipales datos del usuario en la clase User
                User.initialize(
                  responseData['user']['area_name'],
                  email, 
                  responseData['user']['full_name'], 
                  responseData['user']['job_position'],
                  //true,
                  responseData['user']['remember_change_password'], 
                  responseData['user']['admission_date'],
                  responseData['user']['area_lead'], 
                  responseData['access_token'],
                  responseData['refresh_token']);
                 // guardar el accessToken, refreshToken y Login por primera vez
                  await saveBoolean('remember_change_password', responseData['user']['remember_change_password']);                 
                  await saveToken('access_token',responseData['access_token']);
                  await saveToken('refresh_token',responseData['refresh_token']);
         //-------------------------------------------------------------------
        return responseData; //data;
      } else {return {"error":response.statusCode}; } 
  } catch (e) {
    return {"error": 500};
  }
  }

  // Servicio 2: Reset Password
  Future<Map<String, dynamic>?> resetPassword(String email) async {
    final url = CommonFunctions.validateUrl('/api/reset-password/v1/reset-code');
    try {
      final response = await http.post(
        Uri.parse(url),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
          "email": email,
        }),
      );

      if (response.statusCode == 200) {
        final responseData = jsonDecode(response.body);
        return responseData;
      } else {
        return {"error":response.statusCode};
      }
    } catch (e) {
      return {"error": 500};
    }
  }
    // Servicio 3: Create Password From ResetPassword
    Future<Map<String, dynamic>?> passwordChange(String token, String userCode, String newPassword) async {
    final url = CommonFunctions.validateUrl('/api/reset-password/v1/validate-change');

    try {
      final response = await http.post(
         Uri.parse(url),//url as Uri,
        headers: {
          'Content-Type': 'application/json',
        },
        body: jsonEncode({
          "token": token,
          "user_code": userCode,
          "new_password": newPassword,
        }),
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        return data;
      } else {
         return {"error":response.statusCode};
      }
    } catch (e) {
      return {"error": 500};
    }
  }

    // Servicio 4: Generate-code From Cambiar Password

    Future<Map<String, dynamic>?> generateCodeChangePassword() async {
    final url = CommonFunctions.validateUrl('/api/change-password/v1/generate-code');

      final accessToken = await getToken('access_token');

    try {
      final response = await http.get(
        Uri.parse(url),
        headers: {
          'Authorization': 'Bearer $accessToken', //'Authorization': 'Bearer $authBearerToken',getToken(String key)
          'Content-Type': 'application/json',
        },
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        return data;
      } else {
        return {"error":response.statusCode};
      }
    } catch (e) {
      return {"error": 500};
    }
  }
  // Servicio 5: Validate & change From Cambiar Password
      Future<Map<String, dynamic>?> validateChangePassword(
          //required String authToken,
           String token,
           String userCode,
           String newPassword,
        ) async {
          final url = CommonFunctions.validateUrl('/api/change-password/v1/validate-change');
          final accessToken = await getToken('access_token');

          try {
            final response = await http.post(
              Uri.parse(url),
              headers: {
                'Authorization': 'Bearer $accessToken',
                'Content-Type': 'application/json',
              },
              body: jsonEncode({
                "token": token,
                "user_code": userCode,
                "new_password": newPassword,
              }),
            );
      
            if (response.statusCode == 200) {
              final data = jsonDecode(response.body);
              return data;
            } else {
              return {"error":response.statusCode};
            }
          } catch (e) {
            return {"error": 500};
          }
        }
 //Servicio 6 Incidents by user
  Future<List<Map<String, dynamic>>?> getAllIncidentsByUser() async {
    final url = CommonFunctions.validateUrl('/api/incidents/v1/user/allIncidents');
    final accessToken = await getToken('access_token');

    try {
      final response = await http.get(
        Uri.parse(url),
        headers: {
          'Authorization': 'Bearer $accessToken',
          'Content-Type': 'application/json',
        },
      );

      if (response.statusCode == 200) {
        final List<dynamic> data = jsonDecode(response.body);
        return data.cast<Map<String, dynamic>>();
      } else {
        return null;
      }
    } catch (e) {
      return null;
    }
  }   
  // Servicio 7: get all incidents
  Future<List<Map<String, dynamic>>?> getAllIncidents() async {
    final url = CommonFunctions.validateUrl('/api/incidents/v1/all');
    final accessToken = await getToken('access_token'); // Obtener el token almacenado

    try {
      final response = await http.get(
        Uri.parse(url),
        headers: {
          'Authorization': 'Bearer $accessToken',
          'Content-Type': 'application/json',
        },
      );

      if (response.statusCode == 200) {
        final Map<String, dynamic> responseData = jsonDecode(response.body);
        final List<dynamic> incidents = responseData['incidents'];
        return incidents.cast<Map<String, dynamic>>();
      } else {
        return null;
      }
    } catch (e) {
      return null;
    }
  }

// Servicio 8: Servicio request Incident
Future<Map<String, dynamic>?> requestIncident({
    required int incidenceUuid,
    required String startDate,
    required String finalDate,
    required String incidenceMotive,
    required int areaUuid,
    required int projectUuid,
    required String fiscalPeriod,
  }) async {
    final url = CommonFunctions.validateUrl('/api/incidents/v1/user/requestIncident');
       final accessToken = await getToken('access_token'); // Obtener el token almacenado

    try {
      final response = await http.post(
        Uri.parse(url),
        headers: {
          'Authorization': 'Bearer $accessToken',
          'Content-Type': 'application/json',
        },
        body: jsonEncode({
          "incidence_uuid": incidenceUuid,
          "start_date": startDate,
          "final_date": finalDate,
          "incidence_motive": incidenceMotive,
          "area_uuid": areaUuid,
          "project_uuid": projectUuid,
          "fiscal_period": fiscalPeriod,
        }),
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        return data;
      } else {
        return null;
      }
    } catch (e) {
      return null;
    }
  }
 }//class