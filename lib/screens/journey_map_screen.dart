import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:image_picker/image_picker.dart';
import '../models/journey_step.dart';
import '../providers/journey_provider.dart';
import '../widgets/copy_badge.dart';
import 'smart_vault_screen.dart';

class JourneyMapScreen extends StatelessWidget {
  const JourneyMapScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F5F7), // Light grey background
      appBar: AppBar(
        title: const Text('ChinaReady Journey'),
        backgroundColor: Colors.transparent,
        elevation: 0,
        actions: [
          IconButton(
            icon: const Icon(Icons.folder_special, color: Colors.black),
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
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 20),
            itemCount: provider.steps.length,
            itemBuilder: (context, index) {
              final step = provider.steps[index];
              final isLast = index == provider.steps.length - 1;
              
              // Animation delay based on index
              return TweenAnimationBuilder<double>(
                tween: Tween(begin: 0.0, end: 1.0),
                duration: Duration(milliseconds: 500 + (index * 100)),
                curve: Curves.easeOutQuart,
                builder: (context, value, child) {
                  return Transform.translate(
                    offset: Offset(0, 50 * (1 - value)),
                    child: Opacity(
                      opacity: value,
                      child: child,
                    ),
                  );
                },
                child: _JourneyStepItem(
                  step: step,
                  isLast: isLast,
                  index: index,
                ),
              );
            },
          );
        },
      ),
    );
  }
}

class _JourneyStepItem extends StatelessWidget {
  final JourneyStep step;
  final bool isLast;
  final int index;

  const _JourneyStepItem({
    required this.step,
    required this.isLast,
    required this.index,
  });

  @override
  Widget build(BuildContext context) {
    final isLocked = step.status == JourneyStatus.locked;
    final isCompleted = step.status == JourneyStatus.completed;

    return IntrinsicHeight(
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Custom Timeline Painter
          SizedBox(
            width: 40,
            child: CustomPaint(
              painter: _TimelinePainter(
                isLast: isLast,
                isCompleted: isCompleted,
                isLocked: isLocked,
              ),
            ),
          ),
          const SizedBox(width: 12),
          // Card Content
          Expanded(
            child: Padding(
              padding: const EdgeInsets.only(bottom: 24.0),
              child: Card(
                elevation: isLocked ? 0 : 4,
                shadowColor: Colors.black26,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16),
                  side: isLocked ? BorderSide.none : BorderSide.none,
                ),
                color: isLocked ? Colors.grey.shade100 : Colors.white,
                child: Theme(
                  data: Theme.of(context).copyWith(dividerColor: Colors.transparent),
                  child: ExpansionTile(
                    initiallyExpanded: step.status == JourneyStatus.active,
                    tilePadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                    leading: Container(
                      padding: const EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        color: isLocked ? Colors.grey.shade300 : (isCompleted ? Colors.green.shade100 : Colors.red.shade50),
                        shape: BoxShape.circle,
                      ),
                      child: Icon(
                        _getIconForStep(step.id),
                        color: isLocked ? Colors.grey : (isCompleted ? Colors.green : Colors.red),
                        size: 20,
                      ),
                    ),
                    title: Text(
                      step.title,
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                        color: isLocked ? Colors.grey : Colors.black87,
                      ),
                    ),
                    subtitle: Text(
                      step.description,
                      style: TextStyle(
                        fontSize: 12,
                        color: isLocked ? Colors.grey : Colors.black54,
                      ),
                    ),
                    children: [
                      Padding(
                        padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Divider(),
                            ...step.subTasks.map((task) => Padding(
                              padding: const EdgeInsets.symmetric(vertical: 4),
                              child: Row(
                                children: [
                                  Icon(
                                    isCompleted ? Icons.check_box : Icons.check_box_outline_blank,
                                    size: 18,
                                    color: isCompleted ? Colors.green : Colors.grey,
                                  ),
                                  const SizedBox(width: 8),
                                  Expanded(
                                    child: Text(
                                      task,
                                      style: const TextStyle(fontSize: 13),
                                    ),
                                  ),
                                ],
                              ),
                            )),
                            if (step.requiredDocuments.isNotEmpty) ...[
                              const SizedBox(height: 12),
                              const Text(
                                'Required Documents:',
                                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 12),
                              ),
                              const SizedBox(height: 8),
                              Wrap(
                                spacing: 8,
                                runSpacing: 8,
                                children: step.requiredDocuments.entries.map((e) {
                                  final isUploaded = Provider.of<JourneyProvider>(context).isDocumentUploaded(e.key);
                                  return Stack(
                                    clipBehavior: Clip.none,
                                    children: [
                                      CopyBadge(
                                        documentName: e.key,
                                        count: e.value,
                                      ),
                                      if (isUploaded)
                                        const Positioned(
                                          right: -4,
                                          top: -4,
                                          child: Icon(Icons.check_circle, size: 14, color: Colors.green),
                                        ),
                                    ],
                                  );
                                }).toList(),
                              ),
                            ],
                            const SizedBox(height: 16),
                            if (step.status == JourneyStatus.active)
                              SizedBox(
                                width: double.infinity,
                                child: ElevatedButton.icon(
                                  onPressed: () {
                                    _showUploadDialog(context, step);
                                  },
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: const Color(0xFFE60012),
                                    foregroundColor: Colors.white,
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(12),
                                    ),
                                    padding: const EdgeInsets.symmetric(vertical: 12),
                                  ),
                                  icon: const Icon(Icons.upload_file, size: 18),
                                  label: const Text('Upload Documents'),
                                ),
                              ),
                          ],
                        ),
                      ),
                    ],
                  ),
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
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        children: step.requiredDocuments.keys.map((docName) {
          return SimpleDialogOption(
            onPressed: () {
              Navigator.pop(context);
              _showSourceDialog(context, docName);
            },
            child: Padding(
              padding: const EdgeInsets.symmetric(vertical: 8),
              child: Row(
                children: [
                  const Icon(Icons.insert_drive_file, color: Colors.blue),
                  const SizedBox(width: 12),
                  Text(docName),
                ],
              ),
            ),
          );
        }).toList(),
      ),
    );
  }

  void _showSourceDialog(BuildContext context, String docName) {
    showDialog(
      context: context,
      builder: (context) => SimpleDialog(
        title: Text('Upload $docName'),
        children: [
          SimpleDialogOption(
            onPressed: () {
              Provider.of<JourneyProvider>(context, listen: false)
                  .uploadDocument(docName, ImageSource.camera);
              Navigator.pop(context);
            },
            child: const Row(
              children: [
                Icon(Icons.camera_alt),
                SizedBox(width: 12),
                Text('Take Photo'),
              ],
            ),
          ),
          SimpleDialogOption(
            onPressed: () {
              Provider.of<JourneyProvider>(context, listen: false)
                  .uploadDocument(docName, ImageSource.gallery);
              Navigator.pop(context);
            },
            child: const Row(
              children: [
                Icon(Icons.photo_library),
                SizedBox(width: 12),
                Text('Choose from Gallery'),
              ],
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

class _TimelinePainter extends CustomPainter {
  final bool isLast;
  final bool isCompleted;
  final bool isLocked;

  _TimelinePainter({
    required this.isLast,
    required this.isCompleted,
    required this.isLocked,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = isLocked ? Colors.grey.shade300 : (isCompleted ? Colors.green : const Color(0xFFE60012))
      ..strokeWidth = 3
      ..style = PaintingStyle.stroke;

    final centerTop = Offset(size.width / 2, 30); // Center of the icon roughly
    final centerBottom = Offset(size.width / 2, size.height);

    // Draw the line
    if (!isLast) {
      final path = Path();
      path.moveTo(centerTop.dx, centerTop.dy + 15); // Start below the circle
      
      // Draw a subtle curve
      path.quadraticBezierTo(
        centerTop.dx - 10, // Control point (curve out)
        (centerTop.dy + centerBottom.dy) / 2, 
        centerBottom.dx, 
        centerBottom.dy
      );
      
      canvas.drawPath(path, paint);
    }

    // Draw the dot (node)
    final circlePaint = Paint()
      ..color = isLocked ? Colors.grey.shade300 : (isCompleted ? Colors.green : const Color(0xFFE60012))
      ..style = PaintingStyle.fill;
      
    canvas.drawCircle(centerTop, 6, circlePaint);
    
    // Draw white center for active/locked
    if (!isCompleted) {
      canvas.drawCircle(centerTop, 3, Paint()..color = Colors.white);
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
