import 'package:flutter/material.dart';

class SmartVaultScreen extends StatelessWidget {
  const SmartVaultScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Smart Vault'),
      ),
      body: GridView.count(
        crossAxisCount: 2,
        padding: const EdgeInsets.all(16),
        mainAxisSpacing: 16,
        crossAxisSpacing: 16,
        children: [
          _buildDocCard('Passport', 'Verified', Colors.green),
          _buildDocCard('JW202 Form', 'Draft', Colors.grey),
          _buildDocCard('Admission Letter', 'Verified', Colors.green),
          _buildAddCard(),
        ],
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {
          // Print prep logic
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
          Text(title, style: const TextStyle(fontWeight: FontWeight.bold)),
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
