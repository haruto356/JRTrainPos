import 'package:flutter/material.dart';

import 'package:jr_train_pos/line_manager.dart';
import 'package:jr_train_pos/shared_pref.dart';

class MyLineEditScreen extends StatefulWidget {
  const MyLineEditScreen({super.key});

  @override
  State<MyLineEditScreen> createState() => _MyLineEditScreenState();
}

class _MyLineEditScreenState extends State<MyLineEditScreen> {
  final _lineManager = LineManager();
  final _sharedPref = SharedPref();

  late List<String> _lineList;
  late int _lineListLength;

  final List<String> _myLineList = [];
  late List<bool> _checkboxList;
  bool _isWidgetCreated = false;

  // my路線をSharedPreferencesに保存する関数
  Future<void> _saveMyLine() async {
    final List<String> myLineList = [];

    for(int i = 0; i < _checkboxList.length; i++){
      if(_checkboxList[i]){
        myLineList.add(i.toString());
      }
    }

    await _sharedPref.saveMyLineList(myLineList);
  }

  @override
  void initState() {
    super.initState();

    _lineList = _lineManager.getLineStringList();
    _lineListLength = _lineList.length;
    _checkboxList = List.filled(_lineListLength, false);

    // my路線の取得
    Future(() async{
      _myLineList.addAll(await _sharedPref.getMyLineList());

      // 登録されている路線のチェックをオンに
      for(var i in _myLineList){
        _checkboxList[int.parse(i)] = true;
      }

      _isWidgetCreated = true;
      setState(() {});
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('My路線の編集',style: TextStyle(color: Colors.black),),
        actions: [
          TextButton(
            child: const Text('保存'),
            onPressed: () async {
              // 保存して画面を閉じる
              await _saveMyLine();
              if(mounted) {
                Navigator.pop(context, true);
              }
            },
          )
        ],
      ),
      body: !_isWidgetCreated
        ? Center(child: CircularProgressIndicator(),)
        : Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            for(int i = 0; i < _lineListLength; i++)
              CheckboxListTile(
                title: Text(_lineList[i]),
                value: _checkboxList[i],
                controlAffinity: ListTileControlAffinity.leading,
                onChanged: (value) {
                  setState(() {
                    _checkboxList[i] = value!;
                  });
                },
              ),
          ],
      ),
    );
  }
}
