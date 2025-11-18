import 'package:flutter/material.dart';
import 'package:jr_train_pos/file_operation.dart';
import 'dart:convert';

import 'package:jr_train_pos/get_json_file.dart';

class TrainPosScreen extends StatefulWidget {
  const TrainPosScreen({super.key, required this.lineName, required this.lineColor, required this.lineCodeColor});

  final String lineName;
  final int lineColor;
  final int lineCodeColor;

  @override
  State<TrainPosScreen> createState() => _TrainPosScreenState();
}

class _TrainPosScreenState extends State<TrainPosScreen> {
  final _fileOperation = FileOperation();
  final _getJsonFile = GetJsonFile();

  final List<String> _trainPosJsonString = [];
  final Map<String, String> _trainPosMap = {}; // 列車番号、位置の順
  final List<Widget> _stationWidgetList = [];

  // 駅ウィジェットのリストをjsonから作成し、描画する関数
  Future<void> _drawStationList() async {
    final List<String> lineFileList = _getJsonFile.changeLineNameToJsonFile(widget.lineName);
    List<String?> lineList = [];

    // 余白を追加
    _stationWidgetList.add(StationEnd());

    for(var i in lineFileList){
      final jsonStr = await _fileOperation.getFileContent('$i.json');
      Map<String, dynamic> lineMap = json.decode(jsonStr);

      for(int i = 0; i < lineMap['stations'].length; i++) {
        String station = lineMap['stations'][i]['info']['name'];
        // 重複を排除
        if(!lineList.contains(station)){
          lineList.add(station);
          lineList.add(null);
        }
      }
    }

    // 不要なnullを削除
    lineList.removeLast();

    // Widgetをリストに追加
    for(var i in lineList){
      _stationWidgetList.add(Station(stationName: i, lineColor: widget.lineColor));
    }

    // 余白を追加
    _stationWidgetList.add(StationEnd());

    setState(() {});
  }

  // jsonデータを取得する関数
  Future<void> _dataRefresh() async {

    Future(() async {
      final List<String> lineList = _getJsonFile.changeLineNameToJsonFile(widget.lineName);

      // 列車走行位置の取得
      for (var i in lineList) {
        try {
          _trainPosJsonString.add(await _getJsonFile.getTrainPos(i));
        } catch(e) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('列車走行位置データの取得に失敗しました(${widget.lineName})'), duration: Duration(seconds: 1),),
          );
        }
      }

      // 列車走行位置を連想配列に格納
      for(var i in _trainPosJsonString){
        final Map<String, dynamic> jsonMap = json.decode(i);
        for(var j in jsonMap['trains']){
          _trainPosMap[j['no']] = j['pos'];
        }
      }

      // 列車詳細情報の取得
      await _getJsonFile.getTrainInfo();

      setState(() {});
    });
  }

  @override
  void initState() {
    super.initState();
    Future(() async{
      await _dataRefresh();
      await _drawStationList();
    });
  }

  @override
  Widget build(BuildContext context) {
    // 列車位置が取得できていないならロード画面を描画する
    if(_trainPosJsonString.isEmpty){
      return Scaffold(
        appBar: AppBar(
          title: Text(widget.lineName),
          titleTextStyle: TextStyle(color: Color(widget.lineCodeColor), fontSize: 20),
          backgroundColor: Color(widget.lineColor),
          iconTheme: IconThemeData(color: Color(widget.lineCodeColor)),
        ),
        body: Center(
          child: CircularProgressIndicator(),
        )
      );
    }

    return Scaffold(
      appBar: AppBar(
        title: Text(widget.lineName),
        titleTextStyle: TextStyle(color: Color(widget.lineCodeColor), fontSize: 20),
        backgroundColor: Color(widget.lineColor),
        iconTheme: IconThemeData(color: Color(widget.lineCodeColor)),
      ),

      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            children: _stationWidgetList,
          ),
        ),
      ),
    );
  }
}

class Station extends StatelessWidget {
  const Station({super.key, required this.stationName, required this.lineColor});
  final int lineColor;
  final String? stationName;

  @override
  Widget build(BuildContext context) {
    // 駅
    if(stationName != null){
      return Container(
        height: 70,
        color: Colors.white12,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SizedBox(width: 15,),
            Text(stationName!, style: TextStyle(fontSize: 15, fontWeight: FontWeight.w600,),),
            Spacer(),
            Stack(
              alignment: Alignment.center,
              children: [
                Container(
                  width: 12,
                  color: Color(lineColor),
                ),
                Container(
                  height: 10,
                  width: 10,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    shape: BoxShape.circle
                  ),
                )
              ],
            ),
            Spacer(),
            // バランスをとるためのダミー
            Text(stationName!, style: TextStyle(color: Colors.white12, fontSize: 15, fontWeight: FontWeight.w600,),),
            SizedBox(width: 15,),
          ],
        ),
      );
    }
    // 駅間
    else {
      return Container(
        height: 70,
        color: Colors.white,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              width: 12,
              color: Color(lineColor),
            )
          ],
        ),
      );
    }
  }
}

class StationEnd extends StatelessWidget{
  const StationEnd({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 20,
      color: Colors.white,
    );
  }
}