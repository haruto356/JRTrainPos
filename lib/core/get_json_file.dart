import 'dart:async';
import 'dart:convert';
import 'package:http/http.dart' as http;

import 'package:jr_train_pos/core/file_operation.dart';

class GetJsonFile {
  // ファイル取得のタイムアウト時間
  static const Duration timeOutDuration = Duration(seconds: 15);
  final _fileOperation = FileOperation();

  // 駅リストを取得し、一時フォルダに保存する関数
  Future<void> saveStationListTempDir(String lineName) async {
    // 日付チェック
    DateTime now = DateTime.now();
    DateTime fileDate = await FileOperation().getFileModifiedDateTempDir(
      '$lineName.json',
    );
    // 今日既に取得しているなら新たに取得しない
    if (now.difference(fileDate).inDays == 0) {
      return;
    }

    // 取得処理
    try {
      final Uri jsonUrl = Uri.parse(
        'https://www.train-guide.westjr.co.jp/api/v3/${lineName}_st.json',
      );
      final response = await http.get(jsonUrl).timeout(timeOutDuration);
      final status = response.statusCode;

      switch(status){
        case 200:
          // 取得に成功したらファイルに保存する
          await FileOperation().saveFileTempDir('$lineName.json', response.body);
          break;
        case 403:
          throw Exception('[$status] $jsonUrlの閲覧権限がありません');
        case 404:
          throw Exception('[$status] $jsonUrlが見つかりません');
        default:
          throw Exception('[$status] $lineName駅リスト取得時にエラーが発生しました');
      }
    } catch (e) {
      throw Exception();
    }
  }

  // 駅のリストを取得する関数
  Future<List<String>> getStationList(List<String> lineList) async {
    final List<String> stationList = [];

    for(var i in lineList) {
      await saveStationListTempDir(i);

      final jsonStr = await _fileOperation.getFileContent('$i.json');
      Map<String, dynamic> lineMap = json.decode(jsonStr);

      for (int j = 0; j < lineMap['stations'].length; j++) {
        final String stationName = lineMap['stations'][j]['info']['name'];

        // 羽衣線の東羽衣駅は対象外とする
        if (stationName == '東羽衣') {
          continue;
        }

        // 重複を排除
        if (!stationList.contains(stationName)) {
          stationList.add(stationName);
        }
      }
    }

    return stationList;
  }

  // 列車情報を取得し、ファイルに保存する関数
  Future<void> saveTrainInfoTempDir() async {
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
      final status = response.statusCode;

      switch(status){
        case 200:
          // 取得に成功したらファイルに保存する
          await FileOperation().saveFileTempDir('train_info.json', response.body);
          break;
        case 403:
          throw Exception('[$status] $jsonUrlの閲覧権限がありません');
        case 404:
          throw Exception('[$status] $jsonUrlが見つかりません');
        default:
          throw Exception('[$status] 列車情報取得時にエラーが発生しました');
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
      final response = await http.get(jsonUrl).timeout(timeOutDuration);
      final status = response.statusCode;

      switch(status){
        case 200:
          result = response.body;
          break;
        case 403:
          throw Exception('[$status] $jsonUrlの閲覧権限がありません');
        case 404:
          throw Exception('[$status] $jsonUrlが見つかりません');
        default:
          throw Exception('[$status] 車両走行位置取得時にエラーが発生しました');
      }
    } catch (e) {
      throw Exception();
    }

    return result;
  }

  // 近畿エリアの運行状況を取得する関数
  Future<String> getKinkiTrafficInfo() async {
    String result = '';

    // 取得
    try {
      final jsonUrl = Uri.parse('https://www.train-guide.westjr.co.jp/api/v3/area_kinki_trafficinfo.json');
      final response = await http.get(jsonUrl).timeout(timeOutDuration);
      final status = response.statusCode;

      switch(status){
        case 200:
          result = response.body;
          break;
        case 403:
          throw Exception('[$status] $jsonUrlの閲覧権限がありません');
        case 404:
          throw Exception('[$status] $jsonUrlが見つかりません');
        default:
          throw Exception('[$status] 近畿エリアの運行状況取得時にエラーが発生しました');
      }
    } catch (e) {
      throw Exception();
    }

    return result;
  }
}
