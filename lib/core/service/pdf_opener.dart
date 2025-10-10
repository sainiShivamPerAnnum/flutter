import 'dart:io';
import 'package:flutter/services.dart';

class PdfOpener {
  static const MethodChannel _channel = MethodChannel('pdf_opener');

  static Future<bool> openPdfWithPlatformChannel(File pdfFile) async {
    try {
      final bool result = await _channel.invokeMethod('openPdf', {
        'filePath': pdfFile.path,
      });
      return result;
    } on PlatformException catch (e) {
      print('Error opening PDF: ${e.message}');
      return false;
    }
  }

  // Fallback method using share
  static Future<void> openPdfWithShare(File pdfFile) async {
    try {
      // You can use share_plus here as fallback
      await _channel.invokeMethod('sharePdf', {
        'filePath': pdfFile.path,
      });
    } catch (e) {
      print('Error sharing PDF: $e');
    }
  }

  // Main method that tries platform channel first, then share
  static Future<void> openPdf(File pdfFile) async {
    final bool opened = await openPdfWithPlatformChannel(pdfFile);
    if (!opened) {
      print('Platform channel failed, trying share...');
      await openPdfWithShare(pdfFile);
    }
  }
}
