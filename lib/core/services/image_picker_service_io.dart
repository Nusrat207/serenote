import 'dart:io';
import 'dart:async';
import 'dart:convert';
// no web-only imports here
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class ImagePickerService {
  static final ImagePicker _picker = ImagePicker();

  // Platform-aware image picker
  static Future<String?> pickImage() async {
    return _pickImageMobile();
  }

  // Mobile/Desktop image picker
  static Future<String?> _pickImageMobile() async {
    try {
      final XFile? image = await _picker.pickImage(
        source: ImageSource.gallery,
        maxWidth: 800,
        maxHeight: 800,
        imageQuality: 70,
      );

      if (image != null) {
        final file = File(image.path);
        final bytes = await file.readAsBytes();
        return base64Encode(bytes);
      }
      return null;
    } catch (e) {
      // ignore: avoid_print
      print('Error picking image on mobile: $e');
      rethrow;
    }
  }

  // Convert Base64 to Image widget
  static Image imageFromBase64(String base64String, {double? width, double? height, BoxFit? fit}) {
    return Image.memory(
      base64Decode(base64String),
      width: width,
      height: height,
      fit: fit ?? BoxFit.cover,
      errorBuilder: (context, error, stackTrace) {
        return Container(
          color: Colors.grey.shade200,
          child: const Icon(Icons.broken_image, color: Colors.grey),
        );
      },
    );
  }

  // Check if Base64 string is valid
  static bool isValidBase64(String base64String) {
    try {
      base64Decode(base64String);
      return true;
    } catch (e) {
      return false;
    }
  }
}
