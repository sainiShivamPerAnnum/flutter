import 'dart:io';

import 'package:path_provider/path_provider.dart';

class LocalApi {
  Future<String> get _localPath async {
    final directory = await getApplicationDocumentsDirectory();
    return directory.path;
  }

  Future<File> get tambolaResultFile async {
    final path = await _localPath;
    return File('$path/tmbresult.txt');
  }

  Future<File> get userFile async {
    final path = await _localPath;
    return File('$path/userdetails.txt');
  }

  Future<File> get tambolaTutorialFile async {
    final path = await _localPath;
    return File('$path/freshtambolauser.txt');
  }

  Future<File> get homeTutorialFile async {
    final path = await _localPath;
    return File('$path/freshhomeuser.txt');
  }

  Future<File> get confettiFile async {
    final path = await _localPath;
    return File('$path/confettitrack.txt');
  }

  Future<List<String>> readUserFile() async {
    final file = await userFile;
    return file.readAsLines();
  }

  Future<File> writeUserFile(String content) async {
    final file = await userFile;
    return file.writeAsString(content);
  }

  Future<void> deleteUserFile() async {
    final file = await userFile;
    file.delete();
  }

  Future<File> writeTmbResultFile(String content) async {
    final file = await tambolaResultFile;
    return file.writeAsString(content);
  }

  Future<void> deleteTmbResultFile() async {
    final file = await tambolaResultFile;
    file.delete();
  }

  Future<File> writeFreshTambolaTutorialFile(String content) async {
    final file = await tambolaTutorialFile;
    return file.writeAsString(content);
  }

  Future<void> deleteFreshTambolaTutorialFile() async {
    final file = await tambolaTutorialFile;
    file.delete();
  }

  Future<File> writeFreshHomeTutorialFile(String content) async {
    final file = await homeTutorialFile;
    return file.writeAsString(content);
  }

  Future<void> deleteFreshHomeTutorialFile() async {
    final file = await homeTutorialFile;
    file.delete();
  }

  Future<File> writeConfettiTrackFile(String content) async {
    final file = await confettiFile;
    return file.writeAsString(content);
  }

  Future<void> deleteConfettiFile() async {
    final file = await confettiFile;
    file.delete();
  }
}
