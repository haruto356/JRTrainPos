import 'package:flutter/material.dart';

import 'package:jr_train_pos/core/get_json_file.dart';
import 'package:jr_train_pos/core/line_manager.dart';
import 'package:jr_train_pos/core/shared_pref.dart';
import 'package:jr_train_pos/widgets/color_button.dart';

class DefaultShowStationSelectScreen extends StatefulWidget {
  const DefaultShowStationSelectScreen({super.key, required this.lineName});

  final String lineName;

  @override
  State<DefaultShowStationSelectScreen> createState() => _DefaultShowStationSelectScreenState();
}

class _DefaultShowStationSelectScreenState extends State<DefaultShowStationSelectScreen> {
  final _getJsonFile = GetJsonFile();
  final _lineManager = LineManager();
  final _sharedPref = SharedPref();

  final List<String> _stationList = [];

  bool _isListGet = false;

  @override
  void initState() {
    super.initState();

    Future(() async {
      List<String> lineList = _lineManager.changeLineNameToJsonFile(widget.lineName);

      _stationList.addAll(await _getJsonFile.getStationList(lineList));

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
                ColorButton(
                  color: Colors.white,
                  margin: const EdgeInsets.all(5),
                  onPressed: (){
                    _sharedPref.savePrefString('${widget.lineName}初期表示駅', '未設定');
                    Navigator.pop(context, true);
                  },
                  child: const Padding(
                    padding: EdgeInsetsGeometry.fromSTEB(15, 3, 15, 3),
                    child: Text('設定を解除'),
                  ),
                ),
                for(var i in _stationList)...{
                  ColorButton(
                    color: Colors.white,
                    margin: const EdgeInsets.all(5),
                    onPressed: (){
                      _sharedPref.savePrefString('${widget.lineName}初期表示駅', i);
                      Navigator.pop(context, true);
                    },
                    child: Padding(
                      padding: const EdgeInsetsGeometry.fromSTEB(15, 3, 15, 3),
                      child: Text(i),
                    ),
                  ),
                },
              ],
            ),
          ),
        ),
      ),
    );
  }
}
