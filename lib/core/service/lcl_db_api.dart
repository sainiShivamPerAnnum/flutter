import 'dart:io';

import 'package:path_provider/path_provider.dart';

class LocalApi {
  Future<String> get _localPath async {
    final directory = await getApplicationDocumentsDirectory();
    return directory.path;
  }

  Future<File> get onboardFile async {
    final path = await _localPath;
    return File('$path/onboarded.txt');
  }

  Future<File> writeOnboardFile(String content) async {
    final file = await onboardFile;
    return file.writeAsString(content);
  }

  Future<void> deleteOnboardFile() async{
    final file = await onboardFile;
    if(file != null)return file.delete();
  }
}