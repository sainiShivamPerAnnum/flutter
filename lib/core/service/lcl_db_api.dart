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

  Future<File> get userFile async {
    final path = await _localPath;
    return File('$path/userdetails.txt');
  }

  Future<File> get freshUserFile async {
    final path = await _localPath;
    return File('$path/freshuser.txt');
  }

  Future<File> get confettiFile async{
    final path = await _localPath;
    return File('$path/confettitrack.txt');
  }

  Future<List<String>> readUserFile() async{
    final file = await userFile;
    return file.readAsLines();
  }

  Future<File> writeUserFile(String content) async{
    final file = await userFile;
    return file.writeAsString(content);
  }

  Future<void> deleteUserFile() async{
    final file = await userFile;
    if(file != null)return file.delete();
  }

  Future<File> writeOnboardFile(String content) async {
    final file = await onboardFile;
    return file.writeAsString(content);
  }

  Future<void> deleteOnboardFile() async{
    final file = await onboardFile;
    if(file != null)return file.delete();
  }

  Future<File> writeFreshUserFile(String content) async {
    final file = await freshUserFile;
    return file.writeAsString(content);
  }

  Future<void> deleteFreshUserFile() async{
    final file = await freshUserFile;
    if(file != null)return file.delete();
  }


  Future<File> writeConfettiTrackFile(String content) async{
    final file = await confettiFile;
    return file.writeAsString(content);
  }

  Future<void> deleteConfettiFile() async{
    final file = await confettiFile;
    if(file != null)return file.delete();
  }
}