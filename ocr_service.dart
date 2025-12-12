import 'dart:io';
import 'package:google_mlkit_text_recognition/google_mlkit_text_recognition.dart';

class OCRService {
  static Future<String> extractText(File imageFile) async {
    print('🖼️ OCRService.extractText: ${imageFile.path}');
    
    try {
      if (!await imageFile.exists()) {
        print('❌ File not found');
        return "OCR Error: File not found";
      }

      final inputImage = InputImage.fromFile(imageFile);
      final textRecognizer = TextRecognizer(script: TextRecognitionScript.latin);
      final result = await textRecognizer.processImage(inputImage);
      
      print('✅ OCR success: ${result.blocks.length} blocks');
      textRecognizer.close();
      
      return result.text;
    } catch (e, stackTrace) {
      print('❌ OCR Error: $e');
      print('❌ Stack: $stackTrace');
      return "OCR Error: $e";
    }
  }
}
