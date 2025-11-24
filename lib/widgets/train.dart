import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:jr_train_pos/file_operation.dart';

class Train extends StatefulWidget {
  const Train({super.key, required this.lineColor, required this.trainMap, required this.stationList, required this.stationPosMap});

  final int lineColor;
  final Map<String, String?> trainMap;
  final List<String?> stationList;
  final Map<String, String?> stationPosMap;

  @override
  State<Train> createState() => _TrainState();
}

class _TrainState extends State<Train> {
  int _posTop = 0;
  int _direction = 0;

  // 詳細画面に表示する情報
  String _trainNo = '';
  String _nickname = '';
  String _trainType = '';
  String _dest = '';
  int _delayMinutes = 0;
  int _numberOfCars = 0;
  final List<dynamic> _trainInfoJsonList = [];
  final List<int> _trainCarsNo = [];
  final List<int> _trainCarsCongestion = [];

  // 車両詳細情報を変数に格納する
  Future<void> _updateTrainInfo() async {
    final Map<String, String?> map = widget.trainMap;

    _trainNo = map['no']!;
    _nickname = map['nickname']?? '';
    _trainType = map['displayType']!;
    _dest = map['dest']?? '';
    // 行先がjson文字列の場合
    if(_dest.length > 10){
      // 正しいjsonに変換
      _dest = _dest.replaceAll('{', '{"')
        .replaceAll(':', '": "')
        .replaceAll(',', '", "')
        .replaceAll('}', '"}');
      // 行先を取り出す
      _dest = (json.decode(_dest) as Map<String, dynamic>)['text'].toString();
    }
    _delayMinutes = int.parse(map['delayMinutes']?? '0');
    _numberOfCars = int.parse(map['numberOfCars']?? '0');

    // 列車情報から情報を取得
    final jsonStr = await FileOperation().getFileContent('train_info.json');
    final carList = json.decode(jsonStr)['trains'][_trainNo];

    // 列車詳細情報がないなら終了
    if(carList == null){
      return;
    }

    // 車両情報を1両ごとにリストに追加
    for(var i in carList[0]['cars']){
      _trainInfoJsonList.add(i);
      if(_trainNo == '803T'){
      }
    }
    // 新快速等、連結車両用
    if(carList.length == 2) {
      for (var i in carList[1]['cars']) {
        _trainInfoJsonList.add(i);
      }
    }

    // 情報表示用リストに追加
    for(var i in _trainInfoJsonList){
      _trainCarsNo.add(i['carNo']);
      _trainCarsCongestion.add(i['congestion']);
    }
  }

  @override
  void initState() {
    super.initState();

    Future(() async {
      await _updateTrainInfo();
    });

    _direction = int.parse(widget.trainMap['direction']!);

    int posFirst = widget.stationList.indexOf(widget.stationPosMap[widget.trainMap['pos']!.substring(0,4)]);
    int posSecond = widget.stationList.indexOf(widget.stationPosMap[widget.trainMap['pos']!.substring(5,9)]);

    // 停車中
    if(posSecond == 0) {
      _posTop = posFirst;
    }
    // 駅間
    else {
      _posTop = posFirst - 1;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Positioned(
      top: _posTop * 70 + 40,
      left: _direction == 0 ? MediaQuery.of(context).size.width / 2 - 85 : MediaQuery.of(context).size.width / 2 + 45,
      child: InkWell(
        onTap: (){
          // 下から列車情報画面を表示
          showModalBottomSheet(context: context, builder: (BuildContext context){
            return Column(
              children: [
                Container(
                  height: 50,
                  color: Color(widget.lineColor),
                  child: Row(
                    children: [
                      Text(_trainType),
                      Spacer(),
                      _dest == '' ? Text('') : Text('$_dest行き'),
                      Spacer(),
                      _numberOfCars == 0 ? Text('') : Text('$_numberOfCars両')
                    ],
                  ),
                ),
                // jsonから車両データを正しく取得できたら情報を表示する
                if(_trainInfoJsonList.isNotEmpty)...{
                  Text(_trainCarsNo.toString()),
                  Text(_trainCarsCongestion.toString()),
                }
              ],
            );
          });
        },
        child: Transform.scale(
          scaleY: _direction == 0 ? 1 : -1,
          child: Image(
            image: AssetImage('assets/images/train.png'),
            height: 45,
            width: 45,
            color: Color(widget.lineColor),
          ),
        ),
      ),
    );
  }
}