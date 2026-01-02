import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:jr_train_pos/file_operation.dart';

class Train extends StatefulWidget {
  const Train({
    super.key,
    required this.lineColor,
    required this.trainMap,
    required this.stationList,
    required this.stationPosMap,
  });

  final int lineColor;
  final List<Map<String, String?>> trainMap;
  final List<String?> stationList;
  final Map<String, String?> stationPosMap;

  @override
  State<Train> createState() => _TrainState();
}

class _TrainState extends State<Train> {
  bool _isWidgetCreated = false;

  int _posTop = 0;
  int _direction = 0;

  int _maxDelayMinutes = 0;
  Color _delayMinuteAccentColor = Color(0xffffffff); // 遅延分数の強調色
  String _trainTypeChar = ''; // 特、快などの種別を1文字で表す

  // 詳細画面に表示する情報
  final List<String> _trainNo = [];
  final List<String> _nickname = [];
  final List<String> _trainType = [];
  final List<String> _dest = [];
  final List<int> _delayMinutes = [];
  final List<int> _numberOfCars = [];
  final List<List<int>> _trainCarsNo = [];
  final List<List<int>> _trainCarsCongestion = [];

  // 車両詳細情報を変数に格納する
  Future<void> _updateTrainInfo() async {
    final List<Map<String, String?>> trains = widget.trainMap;
    final jsonStr = await FileOperation().getFileContent('train_info.json');

    for(int i = 0; i < trains.length; i++){
      _trainNo.add(trains[i]['no']!);
      _nickname.add(trains[i]['nickname'] ?? '');
      _trainType.add(trains[i]['displayType']!);
      _delayMinutes.add(int.parse(trains[i]['delayMinutes'] ?? '0'));
      _numberOfCars.add(int.parse(trains[i]['numberOfCars'] ?? '0'));

      String dest = trains[i]['dest'] ?? '';
      // 行先がjson文字列の場合
      if(dest.length > 10) {
        // 正しいjsonに変換
        dest = dest.replaceAll('{', '{"').replaceAll(':', '": "').replaceAll(',', '", "').replaceAll('}', '"}');
        // 行先を取り出す
        dest = (json.decode(dest) as Map<String, dynamic>)['text'].toString();
        _dest.add(dest);
      }
      else {
        _dest.add(dest);
      }

      if(_maxDelayMinutes < _delayMinutes[i]){
        _maxDelayMinutes = _delayMinutes[i];
      }

      // 列車情報から情報を取得
      final List<dynamic> trainInfoJsonList = [];
      final carList = json.decode(jsonStr)['trains'][_trainNo[i]];
      // 列車詳細情報がないなら終了
      if (carList == null) {
        continue;
      }

      // 車両情報を1両ごとにリストに追加
      for (var j in carList[0]['cars']) {
        trainInfoJsonList.add(j);
      }
      // 新快速等、連結車両用
      if (carList.length == 2) {
        for (var j in carList[1]['cars']) {
          trainInfoJsonList.add(j);
        }
      }

      // 情報表示用リストに追加
      final List<int> noTemp = [];
      final List<int> congestionTemp = [];
      for (var j in trainInfoJsonList) {
        noTemp.add(j['carNo']);
        congestionTemp.add(j['congestion']);
      }
      _trainCarsNo.add(noTemp);
      _trainCarsCongestion.add(congestionTemp);
    }

    // 遅延分数の強調色の変更
    if (_maxDelayMinutes < 10) {
      _delayMinuteAccentColor = Color(0xffffa726);
    } else if (_maxDelayMinutes < 30) {
      _delayMinuteAccentColor = Color(0xffff7043);
    } else {
      _delayMinuteAccentColor = Colors.red;
    }

    // アイコンの上に表示する種別を設定
    if(_trainType.contains('特急')){
      _trainTypeChar = '特';
    }
    else if(_trainType.contains('新快速')){
      _trainTypeChar = '新';
    }
    else if(_trainType.contains('快速') || _trainType.contains('関空紀州') || _trainType.contains('大和路快')){
      _trainTypeChar = '快';
    }
  }

  @override
  void initState() {
    super.initState();

    Future(() async {
      await _updateTrainInfo();
      setState(() {
        _isWidgetCreated = true;
      });
    });

    _direction = int.parse(widget.trainMap[0]['direction']!);

    int posFirstIndex = widget.stationList.indexOf(
      widget.stationPosMap[widget.trainMap[0]['pos']!.substring(0, 4)],
    );
    int posSecondIndex = widget.stationList.indexOf(
      widget.stationPosMap[widget.trainMap[0]['pos']!.substring(5, 9)],
    );

    // 停車中
    if (posSecondIndex == 0) {
      _posTop = posFirstIndex - 1;
    }
    // 駅間
    else {
      if (posFirstIndex < posSecondIndex) {
        _posTop = posFirstIndex;
      } else {
        _posTop = posFirstIndex - 2;
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    if (!_isWidgetCreated) {
      return SizedBox();
    }

    return Positioned(
      top: _posTop * 70 + 25,
      left:
          _direction == 0
              ? MediaQuery.of(context).size.width / 2 - 75
              : MediaQuery.of(context).size.width / 2 + 30,
      child: GestureDetector(
        onTap: () {
          // 下から列車情報画面を表示
          showModalBottomSheet(
            context: context,
            builder: (BuildContext context) {
              return Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(20),
                    topRight: Radius.circular(20),
                  ),
                ),
                child: Column(
                  children: [
                    SizedBox(height: 20),
                    for(int i = 0; i < _trainNo.length; i++)...{
                      Padding(
                        padding: EdgeInsets.all(5),
                        child: Column(
                          children: [
                            Text(widget.trainMap[i].toString()),
                            if(_trainCarsNo.isNotEmpty && _trainCarsCongestion.isNotEmpty && _trainCarsCongestion.length > i)...{
                              Text(_trainCarsNo[i].toString()),
                              Text(_trainCarsCongestion[i].toString()),
                            },
                            Text('${_delayMinutes[i]}分遅れ'),
                            Text(_nickname[i]),
                          ],
                        ),
                      )
                    }
                  ],
                ),
              );
            },
          );
        },
        child:
            _direction == 0
                ?
                // 上向き
                Column(
                  children: [
                    Stack(
                      children: [
                        Image(
                          image: AssetImage('assets/images/train.png'),
                          height: 50,
                          width: 50,
                          color:
                          widget.trainMap.length == 1
                              ? Color(widget.lineColor)
                              : Colors.black,
                        ),
                        Positioned.fill(
                          top: 4,
                          child: Center(
                            child: Text(_trainTypeChar, style: TextStyle(fontSize: 18, color: Colors.white),),
                          ),
                        ),
                      ],
                    ),

                    // 遅延分数
                    if (_maxDelayMinutes > 0) ...{
                      Transform.translate(
                        offset: const Offset(0, -5),
                        child: Container(
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(5),
                            color: _delayMinuteAccentColor,
                          ),
                          padding: EdgeInsets.only(
                            left: 5,
                            right: 5,
                            bottom: 2,
                          ),
                          child: Text(
                            '$_maxDelayMinutes分遅れ',
                            style: TextStyle(fontSize: 10, color: Colors.white),
                          ),
                        ),
                      ),
                    },
                  ],
                )
                // 下向き
                : Column(
                  children: [
                    // 遅延分数
                    if (_maxDelayMinutes > 0) ...{
                      Transform.translate(
                        offset: const Offset(0, 5),
                        child: Container(
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(5),
                            color: _delayMinuteAccentColor,
                          ),
                          padding: EdgeInsets.only(
                            left: 5,
                            right: 5,
                            bottom: 2,
                          ),
                          child: Text(
                            '$_maxDelayMinutes分遅れ',
                            style: TextStyle(fontSize: 10, color: Colors.white),
                          ),
                        ),
                      ),
                    },

                    Stack(
                      children: [
                        Transform.scale(
                          scaleY: -1,
                          child: Image(
                            image: AssetImage('assets/images/train.png'),
                            height: 50,
                            width: 50,
                            color:
                            widget.trainMap.length == 1
                                ? Color(widget.lineColor)
                                : Colors.black,
                          ),
                        ),
                        Positioned.fill(
                          top: -8,
                          child: Center(
                            child: Text(_trainTypeChar, style: TextStyle(fontSize: 18, color: Colors.white),),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
      ),
    );
  }
}
