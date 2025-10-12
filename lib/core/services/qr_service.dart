// lib/core/services/qr_service.dart

import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';
import 'dart:ui' as ui;
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:path_provider/path_provider.dart';
import 'package:share_plus/share_plus.dart';
import '../../features/journal/domain/entities/journal_entity.dart';

class QRService {
  // Generate QR data from journal entry
  static String generateQRData(JournalEntity journal) {
    final data = {
      'title': journal.title,
      'content': journal.content,
      'timestamp': journal.timestamp.toIso8601String(),
      'mood': journal.linkedMood,
      'tags': journal.tags,
    };
    return jsonEncode(data);
  }

  // Decode QR data to journal entry
  static JournalEntity? decodeQRData(String qrData) {
    try {
      final data = jsonDecode(qrData) as Map<String, dynamic>;
      return JournalEntity(
        title: data['title'] as String,
        content: data['content'] as String,
        timestamp: DateTime.parse(data['timestamp'] as String),
        linkedMood: data['mood'] as String?,
        tags: data['tags'] != null ? List<String>.from(data['tags']) : [],
      );
    } catch (e) {
      print('Error decoding QR data: $e');
      return null;
    }
  }

  // Capture widget as image
  static Future<Uint8List?> captureWidget(GlobalKey key) async {
    try {
      RenderRepaintBoundary boundary = 
          key.currentContext!.findRenderObject() as RenderRepaintBoundary;
      ui.Image image = await boundary.toImage(pixelRatio: 3.0);
      ByteData? byteData = await image.toByteData(format: ui.ImageByteFormat.png);
      return byteData?.buffer.asUint8List();
    } catch (e) {
      print('Error capturing widget: $e');
      return null;
    }
  }

  // Save QR code image
  static Future<String?> saveQRImage(Uint8List imageBytes, String filename) async {
    try {
      final directory = await getApplicationDocumentsDirectory();
      final imagePath = '${directory.path}/$filename.png';
      final file = File(imagePath);
      await file.writeAsBytes(imageBytes);
      return imagePath;
    } catch (e) {
      print('Error saving QR image: $e');
      return null;
    }
  }

  // Share QR code
  static Future<void> shareQRCode(String imagePath, String title) async {
    try {
      final file = XFile(imagePath);
      await Share.shareXFiles(
        [file],
        subject: 'Journal Entry: $title',
        text: 'My journal entry QR code',
      );
    } catch (e) {
      print('Error sharing QR code: $e');
    }
  }

  // Generate and share QR code
  static Future<void> generateAndShareQR(
    GlobalKey qrKey,
    JournalEntity journal,
  ) async {
    try {
      final imageBytes = await captureWidget(qrKey);
      if (imageBytes == null) return;

      final timestamp = DateTime.now().millisecondsSinceEpoch;
      final filename = 'journal_qr_$timestamp';
      final imagePath = await saveQRImage(imageBytes, filename);
      
      if (imagePath != null) {
        await shareQRCode(imagePath, journal.title);
      }
    } catch (e) {
      print('Error generating and sharing QR: $e');
    }
  }
}