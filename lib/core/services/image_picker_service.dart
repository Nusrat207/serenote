import 'dart:io';
import 'dart:async';
import 'dart:convert';
import 'dart:html' as html; // For web
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:universal_html/html.dart' as universal_html;

class ImagePickerService {
  static final ImagePicker _picker = ImagePicker();

  // Platform-aware image picker
  static Future<String?> pickImage() async {
    if (kIsWeb) {
      return _pickImageWeb();
    } else {
      return _pickImageMobile();
    }
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
      print('Error picking image on mobile: $e');
      rethrow;
    }
  }

  // Web image picker
  static Future<String?> _pickImageWeb() async {
    try {
      // Create file input element
      final html.FileUploadInputElement uploadInput = html.FileUploadInputElement();
      uploadInput.accept = 'image/*';
      uploadInput.click();

      final completer = Completer<String?>();
      
      uploadInput.onChange.listen((e) {
        final files = uploadInput.files;
        if (files != null && files.isNotEmpty) {
          final file = files[0];
          final reader = html.FileReader();
          
          reader.onLoadEnd.listen((e) {
            if (reader.result != null) {
              // Remove data:image/...;base64, prefix
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
      print('Error picking image on web: $e');
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