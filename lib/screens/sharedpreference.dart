import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

Future<void> fetchAndStoreUserData(String phoneNumber) async {
  final String url =
      "https://bci-backend-qzzf.onrender.com/users/getUserByNumber/${Uri.encodeComponent(phoneNumber)}";

  print("Fetching data from: $url"); // Debugging

  try {
    final response = await http.get(Uri.parse(url));

    print("Response Status Code: ${response.statusCode}");
    print("Response Body: ${response.body}"); // Debugging

    if (response.statusCode == 200) {
      final Map<String, dynamic> data = jsonDecode(response.body);

      if (data.containsKey("id") && data.containsKey("phoneNumber")) {
        String userId = data["id"];
        String userPhone = data["phoneNumber"];

        // Save to SharedPreferences
        await saveUserData(userId, userPhone);

        print(
            "User ID: $userId and Phone Number: $userPhone saved successfully!");
      } else {
        print("Invalid response format: ${response.body}");
      }
    } else {
      print(
          "Failed to fetch user data: ${response.statusCode} - ${response.body}");
    }
  } catch (e) {
    print("Error fetching user data: $e");
  }
}

Future<void> saveUserData(String userId, String phoneNumber) async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  await prefs.setString('user_id', userId);
  await prefs.setString('phone_number', phoneNumber);
  print("User ID and Phone Number saved successfully!");

  // Debugging: Retrieve and print saved data
  checkSavedData();
}

Future<void> checkSavedData() async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  String? savedUserId = prefs.getString('user_id');
  String? savedPhoneNumber = prefs.getString('phone_number');

  print("Saved User ID: $savedUserId");
  print("Saved Phone Number: $savedPhoneNumber");
}
