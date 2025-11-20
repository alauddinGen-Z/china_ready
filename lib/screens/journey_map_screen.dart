import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/journey_step.dart';
import '../providers/journey_provider.dart';
import '../widgets/copy_badge.dart';
import 'smart_vault_screen.dart';

class JourneyMapScreen extends StatelessWidget {
  const JourneyMapScreen({super.key});

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
      body: Consumer<JourneyProvider>(
        builder: (context, provider, child) {
          return ListView.builder(
            padding: const EdgeInsets.all(16),
            itemCount: provider.steps.length,
            itemBuilder: (context, index) {
              final step = provider.steps[index];
              return _buildStepCard(context, step, index == provider.steps.length - 1);
            },
          );
        },
      ),
    );
  }

  Widget _buildStepCard(BuildContext context, JourneyStep step, bool isLast) {
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
                                final isUploaded = Provider.of<JourneyProvider>(context).isDocumentUploaded(e.key);
                                return Stack(
                                  children: [
                                    CopyBadge(
                                      documentName: e.key,
                                      count: e.value,
                                    ),
                                    if (isUploaded)
                                      const Positioned(
                                        right: 0,
                                        top: 0,
                                        child: Icon(Icons.check_circle, size: 12, color: Colors.green),
                                      ),
                                  ],
                                );
                              }).toList(),
                            ),
                          ],
                          const SizedBox(height: 16),
                          if (step.status == JourneyStatus.active)
                            ElevatedButton.icon(
                              onPressed: () {
                                _showUploadDialog(context, step);
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

  void _showUploadDialog(BuildContext context, JourneyStep step) {
    showDialog(
      context: context,
      builder: (context) => SimpleDialog(
        title: const Text('Select Document to Upload'),
        children: step.requiredDocuments.keys.map((docName) {
          return SimpleDialogOption(
            onPressed: () {
              Provider.of<JourneyProvider>(context, listen: false).uploadDocument(docName);
              Navigator.pop(context);
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text('$docName uploaded to Smart Vault!')),
              );
            },
            child: Padding(
              padding: const EdgeInsets.symmetric(vertical: 8),
              child: Text(docName),
            ),
          );
        }).toList(),
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
