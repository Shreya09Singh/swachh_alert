import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:swachh_alert/model/sessionModel.dart';

class APIService {
  final String baseUrl = "https://bci-backend-qzzf.onrender.com/api";
  final String addUserUrl = "https://bci-backend-qzzf.onrender.com/users";
  static const String _baseUrl = "https://bci-backend-qzzf.onrender.com";
  static const String baseUrlll =
      "https://bci-backend-qzzf.onrender.com/session";

  String? _currentPlayingSessionId;
  String? _currentPlayingSessionName;

  Future<void> generateOtp(String phoneNumber) async {
    final Uri url = Uri.parse("$baseUrl/generate-otp");

    try {
      final response = await http.post(
        url,
        headers: {"Content-Type": "application/json"},
        body: jsonEncode({"phoneNumber": phoneNumber}),
      );

      if (response.statusCode == 200) {
        print("OTP sent successfully: ${response.body}");
      } else {
        print("Failed to generate OTP: ${response.body}");
      }
    } catch (e) {
      print("Error generating OTP: $e");
    }
  }

  Future<void> saveUserId(String userId) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setString('user_id', userId);
    print("User ID saved: $userId");
  }

  // Updated OTP Verification Function
  Future<bool> verifyOtp(String phoneNumber, String otp) async {
    final Uri url = Uri.parse("$baseUrl/verify-otp");

    try {
      final response = await http.post(
        url,
        headers: {"Content-Type": "application/json"},
        body: jsonEncode({"phoneNumber": phoneNumber, "otp": otp}),
      );

      if (response.statusCode == 200) {
        final responseData = jsonDecode(response.body);

        // Extract user ID from response
        if (responseData.containsKey('_id')) {
          String userId = responseData['_id'];

          // Save the user ID locally
          await saveUserId(userId);
        } else {
          print("User ID not found in response.");
        }

        print("OTP verification successful: ${response.body}");
        return true;
      } else {
        print("OTP verification failed: ${response.body}");
        return false;
      }
    } catch (e) {
      print("Error verifying OTP: $e");
      return false;
    }
  }

  Future<bool> addUser({
    required String name,
    required int age,
    required String gender,
    required String phoneNumber,
    required String dob,
    String email = "default@example.com", // Default email
  }) async {
    final Uri url = Uri.parse("$addUserUrl/addUser");

    try {
      final response = await http.post(
        url,
        headers: {"Content-Type": "application/json"},
        body: jsonEncode({
          "name": name,
          "age": age,
          "gender": gender,
          "brainAge": age + 2, // Example logic
          "score": 1400,
          "phoneNumber": phoneNumber,
          "email": email, // Add email, even if backend ignores it
          "dob": dob,
        }),
      );

      print("Response Code: ${response.statusCode}");
      print("Response Body: ${response.body}");

      if (response.statusCode == 200 || response.statusCode == 201) {
        return true;
      } else {
        return false;
      }
    } catch (e) {
      print("Error adding user: $e");
      return false;
    }
  }

  Future<bool> addUserSession({
    required String userId,
    required String sessionId,
    required String sessionName,
    required int actualDuration,
    required int selectedDuration,
    required double selectedThreshold,
    required List<int> focusvalue,
  }) async {
    final url = Uri.parse("$_baseUrl/userSession/addSession");

    // Define your request payload
    final Map<String, dynamic> requestData = {
      "userId": userId,
      "sessionId": sessionId,
      "sessionName": sessionName,
      "actualDuration": actualDuration,
      "listenDuration": selectedDuration,
      "selectedThreshold": selectedThreshold,
      "focusValues": focusvalue,
    };

    try {
      final response = await http.post(
        url,
        headers: {"Content-Type": "application/json"},
        body: jsonEncode(requestData),
      );

      if (response.statusCode == 200) {
        print("Session added successfully: ${response.body}");
        return true;
      } else {
        print("Failed to add session: ${response.statusCode} ${response.body}");
        return false;
      }
    } catch (e) {
      print("Error: $e");
      return false;
    }
  }

  Future<List<SessionModel>> fetchSessions() async {
    final response = await http.get(Uri.parse("$_baseUrl/session/getSessions"));

    if (response.statusCode == 200) {
      List<dynamic> data = json.decode(response.body);
      return data.map((json) => SessionModel.fromJson(json)).toList();
    } else {
      throw Exception("Failed to load sessions");
    }
  }

  void setCurrentPlayingSession(String sessionId, String sessionName) {
    _currentPlayingSessionId = sessionId;
    _currentPlayingSessionName = sessionName;
    print("Currently playing session ID: $_currentPlayingSessionId");
  }

  Future<List<SessionModel>> searchSessions(String query) async {
    try {
      final response = await http.get(Uri.parse("$baseUrlll/getByName/$query"));

      if (response.statusCode == 200) {
        List<dynamic> data = jsonDecode(response.body);
        return data.map((json) => SessionModel.fromJson(json)).toList();
      } else {
        throw Exception("Failed to load sessions");
      }
    } catch (e) {
      print("Error fetching sessions: $e");
      return [];
    }
  }
}
