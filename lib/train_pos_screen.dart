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
  final fileOperation = FileOperation();
  final getJsonFile = GetJsonFile();

  List<String> jsonString = [];

  List<Widget> stationWidgetList = [];

  // 駅ウィジェットのリストをjsonから作成する関数
  Future<void> _updateStationWidgetList() async {
    final List<String> lineFileList = getJsonFile.changeLineNameToJsonFile(widget.lineName);
    List<String?> lineList = [];

    // 余白
    stationWidgetList.add(StationEnd(lineColor: widget.lineColor));

    for(var i in lineFileList){
      final jsonStr = await fileOperation.getFileContent('$i.json');
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

    // Widgetをリストに追加
    for(var i in lineList){
      stationWidgetList.add(Station(stationName: i, lineColor: widget.lineColor));
    }
    // 不要なnullを削除
    lineList.removeLast();

    // 余白
    stationWidgetList.add(StationEnd(lineColor: widget.lineColor));

    setState(() {});
  }

  // 画面を描画する関数
  Future<void> _draw() async {
    await _dataRefresh();
  }

  // jsonデータを取得する関数
  Future<void> _dataRefresh() async {
    final getJsonFile = GetJsonFile();

    Future(() async {
      final List<String> lineList = getJsonFile.changeLineNameToJsonFile(widget.lineName);

      for (var i in lineList) {
        try {
          jsonString.add(await getJsonFile.getTrainPos(i));
        } catch(e) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('列車走行位置データの取得に失敗しました(${widget.lineName})'), duration: Duration(seconds: 1),),
          );
        }
      }

      await getJsonFile.getTrainInfo();

      setState(() {});
    });
  }

  @override
  void initState() {
    super.initState();
    Future(() async{
      await _draw();
      await _updateStationWidgetList();
    });
  }

  @override
  Widget build(BuildContext context) {
    if(jsonString.isEmpty){
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
            children: stationWidgetList,
          ),
        ),
      ),
    );
  }
}

class Train extends StatelessWidget {
  const Train({super.key, required this.direction, required this.congestion, required this.lineColor});
  final int direction; // -1が下向き、1が上向き
  final int congestion; // 混雑度 -1 ~ 150?
  final int lineColor; // 路線カラー

  @override
  Widget build(BuildContext context) {

    return Container(
      margin: EdgeInsets.all(5),
      width: 40,
      height: 50,
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          backgroundColor: Color(lineColor),
          shape: BeveledRectangleBorder(
            borderRadius: BorderRadius.only(
              topRight: Radius.circular((9999 * (direction + 1)).toDouble()),
              topLeft: Radius.circular((9999 * (direction + 1)).toDouble()),
              bottomRight: Radius.circular((9999 * (direction - 1)).toDouble().abs()),
              bottomLeft: Radius.circular((9999 * (direction - 1)).toDouble().abs())
            ),
          )
        ),
        onPressed: (){},
        child: Text('a'),
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
            Text(stationName!, style: TextStyle(fontSize: 16),),
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
            Text(stationName!, style: TextStyle(color: Colors.white12, fontSize: 16),),
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
  const StationEnd({super.key, required this.lineColor});
  final int lineColor;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 20,
      color: Colors.white,
    );
  }
}