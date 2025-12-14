import 'package:http/http.dart' as http;

import 'package:jr_train_pos/file_operation.dart';

class GetJsonFile {
  // 駅リストを取得し、ファイルに保存する関数
  Future<void> getStationList(String lineName) async {
    // 日付チェック（今日既に取得しているなら取得しない）
    DateTime now = DateTime.now();
    DateTime fileDate = await FileOperation().getFileModifiedDateTempDir(
      '$lineName.json',
    );
    if (now.year == fileDate.year &&
        now.month == fileDate.month &&
        now.day == fileDate.day) {
      return;
    }

    // 取得処理
    try {
      final Uri jsonUrl = Uri.parse(
        'https://www.train-guide.westjr.co.jp/api/v3/${lineName}_st.json',
      );
      final response = await http.get(jsonUrl);

      // 取得に成功したらファイルに保存する
      if (response.statusCode == 200) {
        await FileOperation().saveFileTempDir('$lineName.json', response.body);
      }
    } catch (e) {
      throw Exception();
    }
  }

  // 列車情報を取得し、ファイルに保存する関数
  Future<void> getTrainInfo() async {
    // 日付チェック
    DateTime now = DateTime.now();
    DateTime fileDate = await FileOperation().getFileModifiedDateTempDir(
      'train_info.json',
    );
    // 5秒以内に取得しているなら新たに取得しない
    if (now.difference(fileDate).inSeconds < 5) {
      return;
    }

    try {
      final jsonUrl = Uri.parse(
        'https://www.train-guide.westjr.co.jp/api/v3/trainmonitorinfo.json',
      );
      final response = await http.get(jsonUrl);

      // 取得に成功したらファイルに保存する
      if (response.statusCode == 200) {
        await FileOperation().saveFileTempDir('train_info.json', response.body);
      }
    } catch (e) {
      throw Exception();
    }
  }

  // 車両走行位置を取得する関数
  Future<String> getTrainPos(String lineName) async {
    String result = '';

    // 取得
    try {
      final jsonUrl = Uri.parse(
        'https://www.train-guide.westjr.co.jp/api/v3/$lineName.json',
      );
      final response = await http.get(jsonUrl);

      if (response.statusCode == 200) {
        result = response.body;
      } else {
        throw Exception();
      }
    } catch (e) {
      throw Exception();
    }

    return result;
  }
}
