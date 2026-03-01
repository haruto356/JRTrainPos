import 'package:flutter/material.dart';

import 'package:jr_train_pos/core/line_manager.dart';
import 'package:jr_train_pos/core/shared_pref.dart';

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
        leading: IconButton(
          onPressed: () async {
            // 保存して画面を閉じる
            await _saveMyLine();
            if(context.mounted) {
              Navigator.pop(context, true);
            }
          },
          icon: const Icon(Icons.arrow_back),
        ),
      ),
      body: !_isWidgetCreated
        ? const Center(child: CircularProgressIndicator(),)
        : SafeArea(
          child: SingleChildScrollView(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                for(int i = 0; i < _lineListLength; i++)...{
                  Container(
                    margin: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      boxShadow: [
                        BoxShadow(
                          color: Colors.grey.shade300,
                          offset: const Offset(2, 2),
                          spreadRadius: 1.2,
                          blurRadius: 1,
                        ),
                      ],
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Material(
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                        color: Colors.white,
                        child: CheckboxListTile(
                          title: Text(_lineList[i]),
                          value: _checkboxList[i],
                          controlAffinity: ListTileControlAffinity.leading,
                          onChanged: (value) {
                            setState(() {
                              _checkboxList[i] = value!;
                            });
                          },
                        ),
                    ),
                  ),
                },
                const SizedBox(height: 10,),
              ],
            ),
          ),
        )
    );
  }
}
