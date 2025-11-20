import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import '../models/journey_step.dart';
import '../services/ml_kit_service.dart';

class JourneyProvider with ChangeNotifier {
  final MLKitService _mlKitService = MLKitService();
  final ImagePicker _picker = ImagePicker();

  // Hardcoded initial steps
  final List<JourneyStep> _steps = [
    JourneyStep(
      id: '1',
      title: 'Accepted',
      description: 'You have your Admission Letter.',
      status: JourneyStatus.completed,
      subTasks: ['Check admission letter details', 'Confirm acceptance'],
      requiredDocuments: {'Admission Letter': 2},
    ),
    JourneyStep(
      id: '2',
      title: 'The JW Form',
      description: 'The most confusing document.',
      status: JourneyStatus.active,
      subTasks: ['Receive JW202/JW201 Form', 'Verify personal details'],
      requiredDocuments: {'JW202 Form': 2, 'Passport': 5},
    ),
    JourneyStep(
      id: '3',
      title: 'Visa Application',
      description: 'COVA form & Embassy appointment.',
      status: JourneyStatus.locked,
      subTasks: ['Fill COVA form', 'Book appointment', 'Take visa photo'],
    ),
    JourneyStep(
      id: '4',
      title: 'Flight & Packing',
      description: 'Pre-departure preparation.',
      status: JourneyStatus.locked,
      subTasks: ['Book flight', 'Pack essentials', 'Buy VPN'],
    ),
    JourneyStep(
      id: '5',
      title: 'The Landing',
      description: 'Police Registration & Sim Card.',
      status: JourneyStatus.locked,
      subTasks: ['Register with police', 'Get SIM card', 'Open bank account'],
    ),
  ];

  // Track uploaded documents: { 'Document Name': isVerified }
  final Map<String, bool> _uploadedDocuments = {
    'Admission Letter': true, // Already uploaded
  };

  // Track extracted text for verification
  final Map<String, String> _documentText = {};

  List<JourneyStep> get steps => _steps;
  Map<String, bool> get uploadedDocuments => _uploadedDocuments;

  Future<void> uploadDocument(String docName, ImageSource source) async {
    try {
      final XFile? image = await _picker.pickImage(source: source);
      if (image == null) return;

      // Simulate upload (in real app, upload to Firebase Storage)
      _uploadedDocuments[docName] = false; // Default to 'Draft'
      notifyListeners();

      // Run OCR if it's a verifiable document
      if (docName == 'Passport' || docName.contains('JW')) {
        final text = await _mlKitService.extractText(File(image.path));
        _documentText[docName] = text;
        _checkVerification();
      }
    } catch (e) {
      debugPrint('Error uploading document: $e');
    }
  }

  void _checkVerification() {
    final passportText = _documentText['Passport'];
    // Check for JW202 or JW201
    final jwText = _documentText['JW202 Form'] ?? _documentText['JW201 Form'];

    if (passportText != null && jwText != null) {
      final isMatch = _mlKitService.verifyNamesMatch(passportText, jwText);
      if (isMatch) {
        _uploadedDocuments['Passport'] = true;
        if (_documentText.containsKey('JW202 Form')) _uploadedDocuments['JW202 Form'] = true;
        if (_documentText.containsKey('JW201 Form')) _uploadedDocuments['JW201 Form'] = true;
        notifyListeners();
      }
    }
  }

  bool isDocumentUploaded(String docName) {
    return _uploadedDocuments.containsKey(docName);
  }
  
  @override
  void dispose() {
    _mlKitService.close();
    super.dispose();
  }
}
