import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ReportSummaryPage extends StatefulWidget {
  const ReportSummaryPage({Key? key}) : super(key: key);

  @override
  State<ReportSummaryPage> createState() => _ReportSummaryPageState();
}

class _ReportSummaryPageState extends State<ReportSummaryPage> {
  List<Map<String, dynamic>> reports = [];

  @override
  void initState() {
    super.initState();
    loadReports();
  }

  Future<void> loadReports() async {
    final prefs = await SharedPreferences.getInstance();
    final List<String> storedReports = prefs.getStringList('reports') ?? [];

    final loadedReports =
        storedReports.map((jsonStr) {
          return jsonDecode(jsonStr) as Map<String, dynamic>;
        }).toList();

    setState(() {
      reports = loadedReports;
    });
  }

  Future<void> deleteReport(int index) async {
    final prefs = await SharedPreferences.getInstance();
    final List<String> storedReports = prefs.getStringList('reports') ?? [];

    if (index < storedReports.length) {
      storedReports.removeAt(index);
      await prefs.setStringList('reports', storedReports);
    }

    loadReports(); // refresh list after deletion
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Report Summary')),
      body:
          reports.isEmpty
              ? const Center(child: Text('No reports found.'))
              : ListView.builder(
                itemCount: reports.length,
                itemBuilder: (context, index) {
                  final report = reports[index];
                  return Card(
                    margin: const EdgeInsets.all(10),
                    child: Stack(
                      children: [
                        Padding(
                          padding: const EdgeInsets.all(12),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text('📍 Location: ${report['location']}'),
                              Text('📂 Category: ${report['category']}'),
                              Text('📝 Description: ${report['description']}'),
                              const SizedBox(height: 8),
                              if (report['imagePath'] != null &&
                                  File(report['imagePath']).existsSync())
                                Image.file(
                                  File(report['imagePath']),
                                  height: 150,
                                  width: double.infinity,
                                  fit: BoxFit.cover,
                                ),
                            ],
                          ),
                        ),
                        Positioned(
                          top: 8,
                          right: 8,
                          child: IconButton(
                            icon: const Icon(Icons.delete, color: Colors.red),
                            onPressed: () => deleteReport(index),
                          ),
                        ),
                      ],
                    ),
                  );
                },
              ),
    );
  }
}
