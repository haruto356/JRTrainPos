import 'package:http/http.dart' as http;
import 'package:jr_train_pos/dev_log.dart';

import 'package:jr_train_pos/file_operation.dart';

class GetJsonFile {
  // ファイル取得のタイムアウト時間
  static const Duration timeOutDuration = Duration(milliseconds: 15);
  final _devLog = DevLog();

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
      final response = await http.get(jsonUrl).timeout(timeOutDuration);

      // 取得に成功したらファイルに保存する
      if (response.statusCode == 200) {
        await FileOperation().saveFileTempDir('$lineName.json', response.body);
        _devLog.info('$lineNameの駅リスト取得完了');
      } else{
        throw Exception();
      }
    } catch (e) {
      _devLog.error('$lineName駅リスト取得失敗');
      _devLog.error(e.toString());
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
      final response = await http.get(jsonUrl).timeout(timeOutDuration);

      // 取得に成功したらファイルに保存する
      if (response.statusCode == 200) {
        await FileOperation().saveFileTempDir('train_info.json', response.body);
        _devLog.info('列車情報取得完了');
      } else {
        throw Exception();
      }
    } catch (e) {
      _devLog.error('列車情報取得失敗');
      _devLog.error(e.toString());
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
      final response = await http.get(jsonUrl).timeout(timeOutDuration);

      if (response.statusCode == 200) {
        result = response.body;
        _devLog.info('$lineNameの車両走行位置取得完了');
      } else {
        throw Exception();
      }
    } catch (e) {
      _devLog.error('$lineName車両走行位置取得失敗');
      _devLog.error(e.toString());
      throw Exception();
    }

    return result;
  }
}
