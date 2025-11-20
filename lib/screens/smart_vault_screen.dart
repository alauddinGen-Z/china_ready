import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/journey_provider.dart';

class SmartVaultScreen extends StatelessWidget {
  const SmartVaultScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Smart Vault'),
      ),
      body: Consumer<JourneyProvider>(
        builder: (context, provider, child) {
          final docs = provider.uploadedDocuments;
          return GridView.builder(
            padding: const EdgeInsets.all(16),
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              mainAxisSpacing: 16,
              crossAxisSpacing: 16,
            ),
            itemCount: docs.length + 1, // +1 for Add button
            itemBuilder: (context, index) {
              if (index == docs.length) {
                return _buildAddCard();
              }
              final docName = docs.keys.elementAt(index);
              final isVerified = docs.values.elementAt(index);
              return _buildDocCard(docName, isVerified ? 'Verified' : 'Draft', isVerified ? Colors.green : Colors.grey);
            },
          );
        },
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Generating PDF Bundle... (Mock)')),
          );
        },
        icon: const Icon(Icons.print),
        label: const Text('Prepare for Printer'),
      ),
    );
  }

  Widget _buildDocCard(String title, String status, Color statusColor) {
    return Card(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Icon(Icons.insert_drive_file, size: 48, color: Colors.blue),
          const SizedBox(height: 8),
          Text(title, style: const TextStyle(fontWeight: FontWeight.bold), textAlign: TextAlign.center),
          const SizedBox(height: 4),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
            decoration: BoxDecoration(
              color: statusColor.withOpacity(0.1),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Text(
              status,
              style: TextStyle(color: statusColor, fontSize: 12),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildAddCard() {
    return Card(
      color: Colors.grey.shade100,
      child: InkWell(
        onTap: () {},
        child: const Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.add, size: 48, color: Colors.grey),
            SizedBox(height: 8),
            Text('Add Document'),
          ],
        ),
      ),
    );
  }
}
