import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:mi_app/Object/User.dart';
import '../Common/commonFunctions.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

Future<void> saveToken(String key, String accessToken) async {
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
    final token = await storage.read(key: key);
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
        return value.toLowerCase() == 'true';
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

  // Servicio 1: Login
  Future<Map<String, dynamic>?> login(String email, String password) async {
    final url = CommonFunctions.validateUrl('/api/auth/v1/login');
    try {
      final response = await http.post(
        Uri.parse(url),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
          "email": email,
          "password": password,
        }),
      );

      if (response.statusCode == 200) {
        final Map<String, dynamic> responseData = jsonDecode(response.body);

        User.initialize(
          responseData['user']['area_name'],
          responseData['user']['email'],
          responseData['user']['full_name'],
          responseData['user']['job_position'],
          responseData['user']['remember_change_password'],
          responseData['user']['admission_date'],
          responseData['user']['area_lead'],
          responseData['access_token'],
          responseData['refresh_token'],
        );

        await saveBoolean(
            'remember_change_password', responseData['user']['remember_change_password']);
        await saveToken('access_token', responseData['access_token']);
        await saveToken('refresh_token', responseData['refresh_token']);

        return responseData;
      } else {
        return {"error": response.statusCode};
      }
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
        return {"error": response.statusCode};
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
        Uri.parse(url),
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
        return {"error": response.statusCode};
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
          'Authorization': 'Bearer $accessToken',
          'Content-Type': 'application/json',
        },
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        return data;
      } else {
        return {"error": response.statusCode};
      }
    } catch (e) {
      return {"error": 500};
    }
  }

  // Servicio 5: Validate & Change Password
  Future<Map<String, dynamic>?> validateChangePassword(
      String token, String userCode, String newPassword) async {
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
        return {"error": response.statusCode};
      }
    } catch (e) {
      return {"error": 500};
    }
  }

  // Servicio 6: Get All Incidents By User
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

  // Servicio 7: Get All Incidents
  Future<List<Map<String, dynamic>>?> getAllIncidents() async {
    final url = CommonFunctions.validateUrl('/api/incidents/v1/all');
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

  // Servicio 8: Request Incident
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
    final accessToken = await getToken('access_token');
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

  // Servicio 9: Logout
  Future<Map<String, dynamic>?> logout() async {
    final url = CommonFunctions.validateUrl('/api/auth/v1/logout');
    final accessToken = await getToken('access_token');
    print('Access Token: $accessToken');

    try {
      final response = await http.post(
        Uri.parse(url),
        headers: {
          'Authorization': 'Bearer $accessToken',
          'Content-Type': 'application/json',
        },
      );

      print('Response status: ${response.statusCode}');
      print('Response body: ${response.body}');

      if (response.statusCode == 200) {
        final storage = FlutterSecureStorage();
        await storage.delete(key: 'access_token');
        await storage.delete(key: 'refresh_token');
        return {"message": "Sesión cerrada con éxito"};
      } else {
        return {"error": response.statusCode};
      }
    } catch (e) {
      print('Error en logout: $e');
      return {"error": 400};
    }
  }
}