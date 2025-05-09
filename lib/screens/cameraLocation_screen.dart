import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:swachh_alert/widget/customtype.dart';

class CameraLocationAIPage extends StatefulWidget {
  const CameraLocationAIPage({Key? key}) : super(key: key);

  @override
  State<CameraLocationAIPage> createState() => _CameraLocationAIPageState();
}

class _CameraLocationAIPageState extends State<CameraLocationAIPage> {
  File? _image;
  String? selectedcatagory;

  final ImagePicker _picker = ImagePicker();
  final TextEditingController catagoryController = TextEditingController();
  final List<String> categories = ["University", "Health", "Music", "Work"];

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
    return Scaffold(
      resizeToAvoidBottomInset: false,
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        actions: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: IconButton(
              icon: const Icon(Icons.location_pin, size: 30, color: Colors.red),
              onPressed: () {
                Navigator.pop(context);
              },
            ),
          ),
        ],
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
              onPressed: () {
                // TODO: Trigger AI logic
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
