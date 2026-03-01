import 'dart:io';

import 'package:path_provider/path_provider.dart';

class FileOperation {
  // 一時フォルダにファイルを保存する関数
  Future<void> saveFileTempDir(String fileName, String fileContent) async {
    try {
      final file = File('${(await getTemporaryDirectory()).path}/$fileName');
      await file.writeAsString(fileContent);
    } catch (e) {
      throw Exception();
    }
  }

  // ファイルが一時フォルダに存在するかを確認する関数
  Future<bool> isFileExistTempDir(String fileName) async {
    final file = File('${(await getTemporaryDirectory()).path}/$fileName');

    return file.existsSync();
  }

  // 一時フォルダにあるファイルの最終変更日時を取得する関数
  Future<DateTime> getFileModifiedDateTempDir(String fileName) async {
    if (!(await isFileExistTempDir(fileName))) {
      return DateTime(1970);
    }

    final file = File('${(await getTemporaryDirectory()).path}/$fileName');

    return file.statSync().modified;
  }

  // 一時フォルダにあるファイルの中身を返す関数
  Future<String> getFileContent(String fileName) async {
    // 存在確認
    if (!(await isFileExistTempDir(fileName))) {
      return '';
    }

    final file = File('${(await getTemporaryDirectory()).path}/$fileName');

    return file.readAsString();
  }
}
