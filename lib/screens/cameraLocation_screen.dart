import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:image_picker/image_picker.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:swachh_alert/model/sharepreference.dart';
import 'package:swachh_alert/provider/location_provider.dart';
import 'package:swachh_alert/screens/viewReport_screen.dart';
import 'package:swachh_alert/widget/customtype.dart';
import 'package:swachh_alert/widget/snakebar.dart';

class CameraLocationAIPage extends ConsumerStatefulWidget {
  const CameraLocationAIPage({Key? key}) : super(key: key);

  @override
  ConsumerState<CameraLocationAIPage> createState() =>
      _CameraLocationAIPageState();
}

class _CameraLocationAIPageState extends ConsumerState<CameraLocationAIPage> {
  File? _image;
  String? selectedcatagory;
  String? currentAddress;

  final ImagePicker _picker = ImagePicker();
  final TextEditingController catagoryController = TextEditingController();
  final List<String> categories = [
    "Garbage Dump / Overflowing Bins",
    "🚽 Unclean Public Toilet",
    "🌊 Open Drainage / Sewage Leakage",
    "🦴 Dead Animal in Public Area",
    "🦟 Mosquito Breeding Spot / Stagnant Water",
    "🐕 Stray Animal Waste",
    "🛣 Dirty Road or Footpath",
    "🏗 Construction Debris / Dumped Waste",
    "🧴 Chemical Spill / Hazardous Waste",
    "🔥 Burnt Garbage / Air Pollution Concern",
    "⚠ Blocked Public Dustbin Access",
    "❓ Other (Specify in Description)",
  ];

  Future<void> _pickFromGallery() async {
    final picked = await _picker.pickImage(source: ImageSource.gallery);
    if (picked != null) {
      setState(() => _image = File(picked.path));
    }
  }

  Future<void> _pickFromCamera() async {
    final status = await Permission.camera.request();
    if (status.isGranted) {
      final picked = await _picker.pickImage(source: ImageSource.camera);
      if (picked != null) {
        setState(() => _image = File(picked.path));
      }
    } else {
      openAppSettings(); // optional
    }
  }

  @override
  Widget build(BuildContext context) {
    final addressAsync = ref.watch(addressProvider);

    return Scaffold(
      resizeToAvoidBottomInset: false,
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 16.0),
            child: Row(
              children: [
                IconButton(
                  icon: const Icon(Icons.location_pin, color: Colors.red),
                  onPressed:
                      () => ref.refresh(addressProvider), // Refresh location
                ),
                addressAsync.when(
                  data: (address) => Text(address, textAlign: TextAlign.center),
                  loading: () => const CircularProgressIndicator(),
                  error: (err, _) => Text("Error: $err"),
                ),
              ],
            ),
          ),
        ],
        // toolbarHeight: 100,
        centerTitle: true,
        elevation: 0,
        leading: Image.asset('assets/swachh_alert.png', height: 40, scale: 2),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            // Image select buttons
            Container(
              height: 50,
              width: double.infinity,
              decoration: BoxDecoration(
                color: Colors.grey[300],
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: Colors.black26),
              ),
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text('Choose image'),
                    SizedBox(
                      width: 100,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          IconButton(
                            icon: const Icon(
                              Icons.attachment,
                              size: 30,
                              color: Colors.black,
                            ),
                            onPressed: () async {
                              await _pickFromGallery();
                              if (_image != null) {
                                print("Image selected: ${_image!.path}");
                              } else {
                                print("No image selected");
                              }
                            },
                          ),
                          IconButton(
                            icon: const Icon(
                              Icons.camera_alt,
                              size: 30,
                              color: Colors.black,
                            ),
                            onPressed: () async {
                              await _pickFromCamera();
                              if (_image != null) {
                                print("Image selected: ${_image!.path}");
                              } else {
                                print("No image selected");
                              }
                            },
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 20),

            // Image preview
            if (_image != null)
              Stack(
                children: [
                  Container(
                    height: 200,
                    width: double.infinity,
                    margin: const EdgeInsets.only(bottom: 20),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(color: Colors.black26),
                      image: DecorationImage(
                        image: FileImage(_image!),
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                  Positioned(
                    top: 8,
                    right: 8,
                    child: GestureDetector(
                      onTap: () {
                        setState(() {
                          _image = null;
                        });
                      },
                      child: Container(
                        decoration: BoxDecoration(
                          color: Colors.black54,
                          shape: BoxShape.circle,
                        ),
                        padding: const EdgeInsets.all(6),
                        child: const Icon(
                          Icons.close,
                          color: Colors.white,
                          size: 20,
                        ),
                      ),
                    ),
                  ),
                ],
              ),

            // Category dropdown
            CustomDropdown(
              controller: catagoryController,
              selectedValue: selectedcatagory,
              categories: categories,
              onChanged: (String? newval) {
                setState(() {
                  selectedcatagory = newval;
                });
              },
            ),

            const SizedBox(height: 19),

            // AI Description placeholder
            Container(
              height: 200,
              width: double.infinity,
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.black12,
                border: Border.all(color: Colors.black12),
                borderRadius: BorderRadius.circular(10),
                boxShadow: const [
                  BoxShadow(
                    color: Colors.black12,
                    blurRadius: 4,
                    offset: Offset(2, 2),
                  ),
                ],
              ),
              child: const TextField(
                maxLines: 8,
                decoration: InputDecoration(
                  hintText:
                      "AI Description will appear here after analyzing the photo...",
                  border: InputBorder.none,
                  hintStyle: TextStyle(color: Colors.black),
                ),
                style: TextStyle(fontSize: 16),
              ),
            ),

            const SizedBox(height: 30),

            // Submit button
            ElevatedButton(
              onPressed: () async {
                final address = ref
                    .read(addressProvider)
                    .maybeWhen(data: (val) => val, orElse: () => 'No location');

                if (_image == null || selectedcatagory == null) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text("Please select image and category"),
                    ),
                  );
                  return;
                }

                await saveReport(
                  imagePath: _image!.path,
                  location: address,
                  category: selectedcatagory!,
                  description:
                      "AI Description will appear here...", // Or real description
                );

                showReportSubmittedSnackbar(context);
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => ReportSummaryPage()),
                );
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.blue,
                padding: const EdgeInsets.symmetric(
                  horizontal: 100,
                  vertical: 15,
                ),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
              child: const Text(
                "Submit Report",
                style: TextStyle(fontSize: 20, color: Colors.white),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
