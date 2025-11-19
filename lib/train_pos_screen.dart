import 'package:flutter/material.dart';
import 'package:jr_train_pos/file_operation.dart';
import 'dart:convert';

import 'package:jr_train_pos/get_json_file.dart';
import 'package:jr_train_pos/widgets/train.dart';

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

  final List<String?> _stationList = ['####'];
  final List<String> _trainPosJsonString = [];
  final Map<String, String> _trainPosMapUp = {}; // 列車番号、位置の順
  final Map<String, String> _trainPosMapDown = {}; // 列車番号、位置の順
  final Map<String, String?> _stationPosMap = {'####' : '####'}; // 駅コード、駅名の順

  final List<Widget> _stationWidgetList = [];
  final List<Widget> _trainWidgetList = [];

  // 駅ウィジェットのリストをjsonから作成し、描画する関数
  Future<void> _drawStationList() async {
    final List<String> lineFileList = _getJsonFile.changeLineNameToJsonFile(widget.lineName);

    // 余白を追加
    _stationWidgetList.add(StationEnd());

    for(var i in lineFileList){
      final jsonStr = await _fileOperation.getFileContent('$i.json');
      Map<String, dynamic> lineMap = json.decode(jsonStr);

      for(int j = 0; j < lineMap['stations'].length; j++) {
        String stationName = lineMap['stations'][j]['info']['name'];
        // 重複を排除
        if(!_stationList.contains(stationName)){
          _stationList.add(stationName);
          _stationList.add(null);
        }

        // 駅コードと駅名を連想配列に格納
        _stationPosMap[lineMap['stations'][j]['info']['code']] = stationName;
      }
    }

    // 不要なnullを削除
    _stationList.removeLast();

    // Widgetをリストに追加
    for(var i in _stationList){
      if(i != '####') {
        _stationWidgetList.add(Station(stationName: i, lineColor: widget.lineColor));
      }
    }

    // 余白を追加
    _stationWidgetList.add(StationEnd());

    setState(() {});
  }

  // 列車を描画する関数
  Future<void> _drawTrain() async {
    // リストが更新されてから列車を描画する
    while(_trainPosMapUp.isEmpty || _trainPosMapDown.isEmpty){
      await Future.delayed(Duration(milliseconds: 50));
    }
    // 上方向
    _trainPosMapUp.forEach((key, value) {
      final String firstPos = value.substring(0,4);
      final String secondPos = value.substring(5,9);

      final int listPosFirst = _stationList.indexOf(_stationPosMap[firstPos]);
      final int listPosSecond = _stationList.indexOf(_stationPosMap[secondPos]);

      _trainWidgetList.add(Train(lineColor: widget.lineColor, posFirst: listPosFirst, posSecond: listPosSecond, direction: 0,));
    });
    // 下方向
    _trainPosMapDown.forEach((key, value) {
      final String firstPos = value.substring(0,4);
      final String secondPos = value.substring(5,9);

      final int listPosFirst = _stationList.indexOf(_stationPosMap[firstPos]);
      final int listPosSecond = _stationList.indexOf(_stationPosMap[secondPos]);

      _trainWidgetList.add(Train(lineColor: widget.lineColor, posFirst: listPosFirst, posSecond: listPosSecond, direction: 1,));
    });

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
          // 上方向
          if(j['direction'] == 0) {
            _trainPosMapUp[j['no']] = j['pos'];
          }
          // 下方向
          else {
            _trainPosMapDown[j['no']] = j['pos'];
          }
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
      await _drawTrain();
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
        child: Stack(
          children: [
            Positioned.fill(
              child: SingleChildScrollView(
                child: Stack(
                  children: [
                    Column(
                      children: _stationWidgetList,
                    ),
                    ..._trainWidgetList
                  ],
                ),
              ),
            )
          ],
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