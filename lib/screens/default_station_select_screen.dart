import 'package:flutter/material.dart';
import 'dart:convert';

import 'package:jr_train_pos/file_operation.dart';
import 'package:jr_train_pos/get_json_file.dart';
import 'package:jr_train_pos/line_manager.dart';
import 'package:jr_train_pos/shared_pref.dart';

class DefaultStationSelectScreen extends StatefulWidget {
  const DefaultStationSelectScreen({super.key, required this.lineName});

  final String lineName;

  @override
  State<DefaultStationSelectScreen> createState() => _DefaultStationSelectScreenState();
}

class _DefaultStationSelectScreenState extends State<DefaultStationSelectScreen> {
  final _getJsonFile = GetJsonFile();
  final _lineManager = LineManager();
  final _fileOperation = FileOperation();
  final _sharedPref = SharedPref();

  final List<String> _stationList = [];

  bool _isListGet = false;

  @override
  void initState() {
    super.initState();

    Future(() async {
      List<String> lineList = _lineManager.changeLineNameToJsonFile(widget.lineName);
      for(var i in lineList){
        await _getJsonFile.getStationList(i);
      }

      for (var i in lineList) {
        final jsonStr = await _fileOperation.getFileContent('$i.json');
        Map<String, dynamic> lineMap = json.decode(jsonStr);

        for (int j = 0; j < lineMap['stations'].length; j++) {
          String stationName = lineMap['stations'][j]['info']['name'];

          // 羽衣線の東羽衣駅は対象外とする
          if (stationName == '東羽衣') {
            continue;
          }

          // 重複を排除
          if (!_stationList.contains(stationName)) {
            _stationList.add(stationName);
          }
        }
      }

      setState(() {
        _isListGet = true;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    if(_isListGet == false){
      return Scaffold(
        appBar: AppBar(
          title: const Text('初期表示駅を選択', style: TextStyle(color: Colors.black),),
        ),
        body: const Center(
          child: CircularProgressIndicator(),
        )
      );
    }
    return Scaffold(
      appBar: AppBar(
        title: const Text('初期表示駅を選択', style: TextStyle(color: Colors.black),),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Center(
            child: Column(
              children: [
                for(var i in _stationList)...{
                  TextButton(
                    onPressed: (){
                      _sharedPref.savePrefString('${widget.lineName}初期表示駅', i);
                      Navigator.pop(context, true);
                    },
                    child: Text(i),
                  ),
                }
              ],
            ),
          )
        ),
      ),
    );
  }
}
