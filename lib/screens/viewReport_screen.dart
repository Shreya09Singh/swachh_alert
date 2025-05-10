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
                    child: Padding(
                      padding: const EdgeInsets.all(20),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const SizedBox(height: 8),
                          if (report['imagePath'] != null &&
                              File(report['imagePath']).existsSync())
                            Image.file(
                              File(report['imagePath']),
                              height: 170,
                              width: double.infinity,
                              fit: BoxFit.cover,
                            ),
                          SizedBox(height: 10),
                          Text('📍 Location: ${report['location']}'),
                          Text('📂 Category: ${report['category']}'),
                          Text('📝 Description: ${report['description']}'),
                        ],
                      ),
                    ),
                  );
                },
              ),
    );
  }
}
