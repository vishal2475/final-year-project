import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:permission_handler/permission_handler.dart';
import '../services/ocr_service.dart';
import '../services/api_service.dart';
import 'result_screen.dart';

class ScanScreen extends StatefulWidget {
  const ScanScreen({super.key});

  @override
  State<ScanScreen> createState() => _ScanScreenState();
}

class _ScanScreenState extends State<ScanScreen> {
  File? _image;
  bool _isLoading = false;
  String _status = 'Ready to scan';

  Future<void> _checkPermissions() async {
    print('🔐 Checking permissions...');
    try {
      var camera = await Permission.camera.request();
      var storage = await Permission.storage.request();
      print('📷 Camera: $camera, 💾 Storage: $storage');
    } catch (e) {
      print('❌ Permission error: $e');
    }
  }

  Future<void> _pickImage() async {
    print('📸 _pickImage called');
    await _checkPermissions();

    setState(() {
      _isLoading = true;
      _status = 'Opening camera...';
    });

    try {
      final picked = await ImagePicker().pickImage(
        source: ImageSource.camera,
        imageQuality: 80,
        maxWidth: 1920,
        maxHeight: 1080,
      );

      if (picked == null) {
        print(' User cancelled camera');
        setState(() {
          _isLoading = false;
          _status = 'Camera cancelled';
        });
        return;
      }

      print(' Image captured: ${picked.path}');
      setState(() {
        _image = File(picked.path);
        _status = 'Processing OCR...';
      });

      // OCR Processing
      print('🚀 Starting OCR extraction...');
      String ocrText = await OCRService.extractText(_image!);
      print('🏁 OCR completed: ${ocrText.length} characters');

      // API Call
      print('🚀 Calling AI API...');
      var aiResult = await ApiService.analyzeText(ocrText);
      print('🏁 API response: $aiResult');

      if (mounted) {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (_) => ResultScreen(
              text: ocrText,
              summary: aiResult["summary"] ?? "No summary",
              wordCount: aiResult["word_count"]?.toString() ?? "0",
            ),
          ),
        );
        setState(() {
          _image = null;
          _isLoading = false;
          _status = 'Ready to scan';
        });
      }
    } catch (e, stackTrace) {
      print(' Error: $e');
      print(' Stack: $stackTrace');
      setState(() {
        _isLoading = false;
        _status = 'Error occurred';
      });
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error: $e'), backgroundColor: Colors.red),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Scan Document")),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(_status, style: TextStyle(fontSize: 16)),
            SizedBox(height: 20),
            if (_image != null) ...[
              Image.file(_image!, width: 250, height: 250),
              SizedBox(height: 10),
            ],
            ElevatedButton.icon(
              onPressed: _isLoading ? null : _pickImage,
              icon: Icon(Icons.camera_alt),
              label: Text(_isLoading ? "Processing..." : "Capture Image"),
            ),
            if (_isLoading) ...[
              SizedBox(height: 20),
              CircularProgressIndicator(),
            ],
          ],
        ),
      ),
    );
  }
}
