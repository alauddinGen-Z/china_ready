import 'dart:io';
import 'package:google_mlkit_text_recognition/google_mlkit_text_recognition.dart';

class MLKitService {
  final _textRecognizer = TextRecognizer(script: TextRecognitionScript.latin);

  Future<String> extractText(File imageFile) async {
    final inputImage = InputImage.fromFile(imageFile);
    final RecognizedText recognizedText = await _textRecognizer.processImage(inputImage);
    return recognizedText.text;
  }

  Future<void> close() async {
    await _textRecognizer.close();
  }

  // Logic to verify if two texts contain similar names
  // Returns true if a reasonable match is found
  bool verifyNamesMatch(String text1, String text2) {
    // Simple normalization: lowercase, remove extra spaces
    final normalized1 = text1.toLowerCase().replaceAll(RegExp(r'\s+'), ' ');
    final normalized2 = text2.toLowerCase().replaceAll(RegExp(r'\s+'), ' ');

    // Split into words (tokens)
    final tokens1 = normalized1.split(' ').where((t) => t.length > 2).toSet();
    final tokens2 = normalized2.split(' ').where((t) => t.length > 2).toSet();

    // Check intersection
    final commonTokens = tokens1.intersection(tokens2);
    
    // If at least 2 significant name parts match (e.g. "John" and "Smith"), pass.
    return commonTokens.length >= 2;
  }
}
