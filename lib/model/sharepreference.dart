import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:shared_preferences/shared_preferences.dart';

// Future<void> saveReport({
//   required String imagePath,
//   required String location,
//   required String category,
//   required String description,
// }) async {
//   final prefs = await SharedPreferences.getInstance();
//   await prefs.setString('imagePath', imagePath);
//   await prefs.setString('location', location);
//   await prefs.setString('category', category);
//   await prefs.setString('description', description);
// }

import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';

Future<void> saveReport({
  required String imagePath,
  required String location,
  required String category,
  required String description,
}) async {
  final prefs = await SharedPreferences.getInstance();

  // Create report map
  final newReport = {
    'imagePath': imagePath,
    'location': location,
    'category': category,
    'description': description,
  };

  // Get existing list
  final List<String> reports = prefs.getStringList('reports') ?? [];

  // Add new report
  reports.add(jsonEncode(newReport));

  // Save updated list
  await prefs.setStringList('reports', reports);
}
