import 'dart:io';
import 'package:path_provider/path_provider.dart';
import 'package:pdf/widgets.dart';

class PdfApi {
  static Future<File> saveDocument({
    required Document pdf,
    String? name,
  }) async {
    final bytes = await pdf.save();
    Directory? dir;
    try {
      dir = await getExternalStorageDirectory();
    } catch (e) {
      dir = await getApplicationDocumentsDirectory();
    }

    final file = File('${dir!.path}/$name');
    await file.writeAsBytes(bytes);

    return file;
  }
}
