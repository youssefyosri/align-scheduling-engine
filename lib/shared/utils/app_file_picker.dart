import 'dart:io';
// 1. Add the 'as fp' prefix to the import
import 'package:file_picker/file_picker.dart' as fp;
import 'package:image_picker/image_picker.dart';

class AppFilePicker {
  static final ImagePicker _imagePicker = ImagePicker();

  static Future<File?> pickImage({required ImageSource source}) async {
    try {
      final XFile? pickedFile = await _imagePicker.pickImage(
        source: source,
        imageQuality: 80,
      );
      if (pickedFile != null) {
        return File(pickedFile.path);
      }
    } catch (e) {
      return null;
    }
    return null;
  }

  static Future<File?> pickDocument({List<String>? allowedExtensions}) async {
    try {
      // 2. Add the 'fp.' prefix to explicitly target the package's classes and enums
      final fp.FilePickerResult? result = await fp.FilePicker.pickFiles(
        type: allowedExtensions != null ? fp.FileType.custom : fp.FileType.any,
        allowedExtensions: allowedExtensions,
      );

      if (result != null && result.files.single.path != null) {
        return File(result.files.single.path!);
      }
    } catch (e) {
      return null;
    }
    return null;
  }
}