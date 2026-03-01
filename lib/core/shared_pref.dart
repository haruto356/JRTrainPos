import 'package:shared_preferences/shared_preferences.dart';

class SharedPref {
  // 文字列を保存する関数
  Future<void> savePrefString(String key, String value) async {
    final pref = await SharedPreferences.getInstance();
    await pref.setString(key, value);
  }

  // 文字列を取得する関数
  Future<String> getPrefString(String key) async {
    final pref = await SharedPreferences.getInstance();
    return pref.getString(key) ?? '';
  }

  // my路線をSharedPreferenceに保存する関数
  Future<void> saveMyLineList(List<dynamic> list) async {
    final pref = await SharedPreferences.getInstance();

    // List<String>に変換
    final List<String> strList = [];
    for(var i in list){
      strList.add(i.toString());
    }

    await pref.setStringList('myLine', strList);
  }

  // SharedPreferenceに保存されているmy路線を取得する関数
  Future<List<String>> getMyLineList() async {
    final pref = await SharedPreferences.getInstance();
    List<String>? myLineList;

    try {
      myLineList = pref.getStringList('myLine');
    } catch(e) {
      return [];
    }

    if(myLineList == null) {
      return [];
    } else {
      return myLineList;
    }
  }
}