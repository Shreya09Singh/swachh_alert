import 'package:flutter/material.dart';

void showReportSubmittedSnackbar(BuildContext context) {
  ScaffoldMessenger.of(context).showSnackBar(
    SnackBar(
      content: const Text(
        'Report submitted',
        style: TextStyle(color: Colors.white),
      ),
      backgroundColor: Colors.green,

      duration: const Duration(seconds: 3),
      behavior: SnackBarBehavior.floating,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
    ),
  );
}
