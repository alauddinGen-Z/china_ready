import 'package:flutter/material.dart';
import '../models/journey_step.dart';
import '../widgets/copy_badge.dart';
import 'smart_vault_screen.dart';

class JourneyMapScreen extends StatefulWidget {
  const JourneyMapScreen({super.key});

  @override
  State<JourneyMapScreen> createState() => _JourneyMapScreenState();
}

class _JourneyMapScreenState extends State<JourneyMapScreen> {
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('ChinaReady Journey'),
        actions: [
          IconButton(
            icon: const Icon(Icons.folder_special),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const SmartVaultScreen()),
              );
            },
          ),
        ],
      ),
      body: ListView.builder(
        padding: const EdgeInsets.all(16),
        itemCount: _steps.length,
        itemBuilder: (context, index) {
          final step = _steps[index];
          return _buildStepCard(step, index == _steps.length - 1);
        },
      ),
    );
  }

  Widget _buildStepCard(JourneyStep step, bool isLast) {
    final isLocked = step.status == JourneyStatus.locked;
    
    return IntrinsicHeight(
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // Timeline Line
          Column(
            children: [
              Container(
                width: 20,
                height: 20,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: isLocked ? Colors.grey : Colors.red,
                  border: Border.all(color: Colors.white, width: 2),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.1),
                      blurRadius: 4,
                    ),
                  ],
                ),
              ),
              if (!isLast)
                Expanded(
                  child: Container(
                    width: 2,
                    color: Colors.grey.shade300,
                  ),
                ),
            ],
          ),
          const SizedBox(width: 16),
          // Content
          Expanded(
            child: Padding(
              padding: const EdgeInsets.only(bottom: 32),
              child: Card(
                elevation: isLocked ? 0 : 2,
                color: isLocked ? Colors.grey.shade50 : Colors.white,
                child: ExpansionTile(
                  enabled: !isLocked,
                  leading: Icon(
                    _getIconForStep(step.id),
                    color: isLocked ? Colors.grey : Colors.red,
                  ),
                  title: Text(
                    step.title,
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      color: isLocked ? Colors.grey : Colors.black,
                    ),
                  ),
                  subtitle: Text(step.description),
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(16),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          ...step.subTasks.map((task) => CheckboxListTile(
                            value: false,
                            onChanged: (v) {},
                            title: Text(task),
                            controlAffinity: ListTileControlAffinity.leading,
                            dense: true,
                          )),
                          if (step.requiredDocuments.isNotEmpty) ...[
                            const Divider(),
                            const Text(
                              'Required Documents:',
                              style: TextStyle(fontWeight: FontWeight.bold),
                            ),
                            const SizedBox(height: 8),
                            Wrap(
                              spacing: 8,
                              runSpacing: 8,
                              children: step.requiredDocuments.entries.map((e) {
                                return CopyBadge(
                                  documentName: e.key,
                                  count: e.value,
                                );
                              }).toList(),
                            ),
                          ],
                          const SizedBox(height: 16),
                          if (step.status == JourneyStatus.active)
                            ElevatedButton.icon(
                              onPressed: () {
                                // Upload logic
                              },
                              icon: const Icon(Icons.upload_file),
                              label: const Text('Upload Documents'),
                            ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  IconData _getIconForStep(String id) {
    switch (id) {
      case '1': return Icons.school;
      case '2': return Icons.description;
      case '3': return Icons.airplane_ticket;
      case '4': return Icons.luggage;
      case '5': return Icons.location_city;
      default: return Icons.circle;
    }
  }
}
