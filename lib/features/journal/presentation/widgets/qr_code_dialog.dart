// lib/features/journal/presentation/widgets/qr_code_dialog.dart

import 'package:flutter/material.dart';
import 'package:qr_flutter/qr_flutter.dart';
import '../../../../core/services/qr_service.dart';
import '../../domain/entities/journal_entity.dart';

class QRCodeDialog extends StatelessWidget {
  final JournalEntity journal;
  final GlobalKey qrKey = GlobalKey();

  QRCodeDialog({super.key, required this.journal});

  @override
  Widget build(BuildContext context) {
    final qrData = QRService.generateQRData(journal);

    return Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Journal QR Code',
                  style: Theme.of(context).textTheme.titleLarge?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                ),
                IconButton(
                  icon: const Icon(Icons.close),
                  onPressed: () => Navigator.pop(context),
                ),
              ],
            ),
            const SizedBox(height: 20),
            
            // QR Code with RepaintBoundary for screenshot
            RepaintBoundary(
              key: qrKey,
              child: Container(
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: Colors.purple.shade200, width: 2),
                ),
                child: Column(
                  children: [
                    QrImageView(
                      data: qrData,
                      version: QrVersions.auto,
                      size: 200,
                      backgroundColor: Colors.white,
                      foregroundColor: Colors.purple.shade700,
                    ),
                    const SizedBox(height: 12),
                    Text(
                      journal.title,
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 14,
                      ),
                      textAlign: TextAlign.center,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ],
                ),
              ),
            ),
            
            const SizedBox(height: 20),
            
            Text(
              'Scan this QR code to view the journal entry on another device',
              style: TextStyle(
                fontSize: 12,
                color: Colors.grey.shade600,
              ),
              textAlign: TextAlign.center,
            ),
            
            const SizedBox(height: 20),
            
            Row(
              children: [
                Expanded(
                  child: OutlinedButton.icon(
                    onPressed: () async {
                      await QRService.generateAndShareQR(qrKey, journal);
                    },
                    icon: const Icon(Icons.share),
                    label: const Text('Share'),
                    style: OutlinedButton.styleFrom(
                      foregroundColor: Colors.purple,
                      side: const BorderSide(color: Colors.purple),
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: ElevatedButton.icon(
                    onPressed: () async {
                      final imageBytes = await QRService.captureWidget(qrKey);
                      if (imageBytes != null) {
                        final timestamp = DateTime.now().millisecondsSinceEpoch;
                        await QRService.saveQRImage(imageBytes, 'journal_qr_$timestamp');
                        if (context.mounted) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(content: Text('QR code saved!')),
                          );
                          Navigator.pop(context);
                        }
                      }
                    },
                    icon: const Icon(Icons.download),
                    label: const Text('Save'),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.purple,
                      foregroundColor: Colors.white,
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}