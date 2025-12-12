import 'dart:convert';
import 'package:http/http.dart' as http;

class ApiService {
  static Future<Map<String, dynamic>> analyzeText(String text) async {
    print('📡 ApiService.analyzeText: ${text.length} chars');
    
    try {
      final url = Uri.parse('http://192.168.1.182:5000/analyze');
      final response = await http.post(
        url,
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({'text': text}),
      );
      
      print(' Response: ${response.statusCode}');
      
      if (response.statusCode == 200) {
        return jsonDecode(response.body);
      } else {
        print('API Error: ${response.body}');
        return {"summary": "API Error ${response.statusCode}", "word_count": 0};
      }
    } catch (e) {
      print(' API Exception: $e');
      return {"summary": "API Error: $e", "word_count": 0};
    }
  }
}
