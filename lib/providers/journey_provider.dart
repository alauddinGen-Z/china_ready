import 'package:flutter/material.dart';
import '../models/journey_step.dart';

class JourneyProvider with ChangeNotifier {
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

  List<JourneyStep> get steps => _steps;
  Map<String, bool> get uploadedDocuments => _uploadedDocuments;

  void uploadDocument(String docName) {
    _uploadedDocuments[docName] = false; // Default to 'Draft' (false)
    notifyListeners();
  }

  void verifyDocument(String docName) {
    if (_uploadedDocuments.containsKey(docName)) {
      _uploadedDocuments[docName] = true;
      notifyListeners();
    }
  }

  bool isDocumentUploaded(String docName) {
    return _uploadedDocuments.containsKey(docName);
  }
}
