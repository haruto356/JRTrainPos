import 'package:http/http.dart' as http;

import 'package:jr_train_pos/file_operation.dart';

class GetJsonFile {
  // 駅リストを取得し、ファイルに保存する関数
  Future<void> getStationList(String lineName) async {
    // 日付チェック（今日既に取得しているなら取得しない）
    DateTime now = DateTime.now();
    DateTime fileDate = await FileOperation().getFileModifiedDateTempDir('$lineName.json');
    if(now.day == fileDate.day){
      return;
    }

    // 取得処理
    try {
      final Uri jsonUrl = Uri.parse('https://www.train-guide.westjr.co.jp/api/v3/${lineName}_st.json');
      final response = await http.get(jsonUrl);

      // 取得に成功したらファイルに保存する
      if (response.statusCode == 200) {
        await FileOperation().saveFileTempDir('$lineName.json', response.body);
      }
    } catch(e) {
      throw Exception();
    }
  }
}