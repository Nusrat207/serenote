// Conditional export: web uses image_picker_service_web.dart, others use image_picker_service_io.dart
export 'image_picker_service_io.dart'
    if (dart.library.html) 'image_picker_service_web.dart';