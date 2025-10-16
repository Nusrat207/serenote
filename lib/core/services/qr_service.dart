import 'dart:ui' as ui;
import 'dart:io';
import 'dart:typed_data';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';
import 'package:share_plus/share_plus.dart';
import 'package:flutter/rendering.dart';
import '../../features/journal/domain/entities/journal_entity.dart';
import 'package:permission_handler/permission_handler.dart';

class QRService {
  /// Format readable QR data
  static String generateQRData(JournalEntity journal) {
    final buffer = StringBuffer();
    buffer.writeln('📝 ${journal.title}');
    buffer.writeln('');
    buffer.writeln(journal.content);
    buffer.writeln('');
    buffer.writeln('Mood: ${journal.linkedMood ?? '—'}');
    buffer.writeln('Tags: ${journal.tags.isNotEmpty ? journal.tags.join(', ') : '—'}');
    buffer.writeln(
      'Date: ${journal.timestamp.toLocal().toString().split(' ')[0]}',
    );
    if (journal.imageData != null) {
      buffer.writeln('🖼️ (Contains image)');
    }
    return buffer.toString();
  }

  ///  Capture QR widget as PNG bytes
  static Future<Uint8List?> captureWidget(GlobalKey key) async {
    try {
      final boundary = key.currentContext!.findRenderObject() as RenderRepaintBoundary;
      final image = await boundary.toImage(pixelRatio: 3.0);
      final byteData = await image.toByteData(format: ui.ImageByteFormat.png);

      return byteData?.buffer.asUint8List();
    } catch (e) {
      debugPrint('Error capturing widget: $e');
      return null;
    }
  }

  /// Save QR image to app directory
  static Future<String?> saveQRImage(Uint8List bytes, String filename) async {
    try {
      // Request permission to access storage (Android 10+ needs this)
      var status = await Permission.storage.request();
      if (!status.isGranted) {
        debugPrint('Storage permission denied.');
        return null;
      }

      Directory? directory;

      if (Platform.isAndroid) {
        directory = Directory('/storage/emulated/0/Download');
      } else {
        directory = await getApplicationDocumentsDirectory();
      }

      if (!await directory.exists()) {
        await directory.create(recursive: true);
      }

      final filePath = '${directory.path}/$filename.png';
      final file = File(filePath);
      await file.writeAsBytes(bytes);

      debugPrint('✅ Saved QR to $filePath');
      return filePath;
    } catch (e) {
      debugPrint('Error saving QR image: $e');
      return null;
    }
  }

  /// Share QR as an image
  static Future<void> generateAndShareQR(GlobalKey key, JournalEntity journal) async {
    final bytes = await captureWidget(key);
    if (bytes == null) return;

    final dir = await getTemporaryDirectory();
    final filePath = '${dir.path}/${journal.title.replaceAll(' ', '_')}.png';
    final file = File(filePath);
    await file.writeAsBytes(bytes);

    await Share.shareXFiles([XFile(file.path)], text: 'Journal: ${journal.title}');
  }
}
