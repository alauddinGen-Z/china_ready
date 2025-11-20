import 'package:flutter/material.dart';

enum JourneyStatus {
  locked,
  active,
  completed,
}

class JourneyStep {
  final String id;
  final String title;
  final String description;
  final JourneyStatus status;
  final List<String> subTasks;
  final Map<String, int> requiredDocuments; // e.g., {'Passport': 5}

  JourneyStep({
    required this.id,
    required this.title,
    required this.description,
    required this.status,
    required this.subTasks,
    this.requiredDocuments = const {},
  });
}
