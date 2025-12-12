import 'package:flutter/material.dart';

class ResultScreen extends StatelessWidget {
  final String text;
  final String summary;
  final String wordCount;

  const ResultScreen({
    super.key,
    required this.text,
    required this.summary,
    required this.wordCount,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Extracted Text & AI Result")),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text("Extracted Text:", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
              const SizedBox(height: 8),
              Text(text, style: TextStyle(fontSize: 16)),
              const SizedBox(height: 20),
              Text("AI Summary:", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
              const SizedBox(height: 8),
              Text(summary, style: TextStyle(fontSize: 16)),
              const SizedBox(height: 20),
              Text("Word Count: $wordCount", style: TextStyle(fontSize: 16)),
            ],
          ),
        ),
      ),
    );
  }
}
