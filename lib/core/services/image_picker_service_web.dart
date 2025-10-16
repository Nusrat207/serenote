import 'dart:async';
import 'dart:convert';
import 'dart:html' as html;
import 'package:flutter/material.dart';

class ImagePickerService {
  // Platform-aware image picker for web
  static Future<String?> pickImage() async {
    return _pickImageWeb();
  }

  static Future<String?> _pickImageWeb() async {
    try {
      final html.FileUploadInputElement uploadInput = html.FileUploadInputElement();
      uploadInput.accept = 'image/*';
      uploadInput.click();

      final completer = Completer<String?>();

      uploadInput.onChange.listen((_) {
        final files = uploadInput.files;
        if (files != null && files.isNotEmpty) {
          final file = files[0];
          final reader = html.FileReader();

          reader.onLoadEnd.listen((_) {
            if (reader.result != null) {
              final String base64Data = reader.result as String;
              final String imageBase64 = base64Data.split(',').last;
              completer.complete(imageBase64);
            } else {
              completer.complete(null);
            }
          });

          reader.onError.listen((error) {
            completer.completeError(error);
          });

          reader.readAsDataUrl(file);
        } else {
          completer.complete(null);
        }
      });

      return completer.future;
    } catch (e) {
      // ignore: avoid_print
      print('Error picking image on web: $e');
      rethrow;
    }
  }

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

  static bool isValidBase64(String base64String) {
    try {
      base64Decode(base64String);
      return true;
    } catch (e) {
      return false;
    }
  }
}
