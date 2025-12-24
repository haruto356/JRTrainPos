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

  Color _delayMinuteAccentColor = Color(0xffffffff); // 遅延分数の強調色
  String _trainTypeChar = ''; // 特、快などの種別を1文字で表す

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
    final Map<String, String?> map = {};
    for (var i in widget.trainMap) {
      map.addAll(i);
    }

    _trainNo = map['no']!;
    _nickname = map['nickname'] ?? '';
    _trainType = map['displayType']!;
    _dest = map['dest'] ?? '';
    // 行先がjson文字列の場合
    if (_dest.length > 10) {
      // 正しいjsonに変換
      _dest = _dest
          .replaceAll('{', '{"')
          .replaceAll(':', '": "')
          .replaceAll(',', '", "')
          .replaceAll('}', '"}');
      // 行先を取り出す
      _dest = (json.decode(_dest) as Map<String, dynamic>)['text'].toString();
    }
    _delayMinutes = int.parse(map['delayMinutes'] ?? '0');
    _numberOfCars = int.parse(map['numberOfCars'] ?? '0');

    // 遅延分数の強調色の変更
    if (_delayMinutes < 10) {
      _delayMinuteAccentColor = Color(0xffffa726);
    } else if (_delayMinutes < 30) {
      _delayMinuteAccentColor = Color(0xffff7043);
    } else {
      _delayMinuteAccentColor = Colors.red;
    }

    // アイコンの上に表示する種別を設定
    if(_trainType.contains('特急')){
      _trainTypeChar = '特';
    }
    else if(_trainType == '新快速'){
      _trainTypeChar = '新';
    }
    else if(_trainType.contains('快速') || _trainType == '関空紀州'){
      _trainTypeChar = '快';
    }

    // 列車情報から情報を取得
    final jsonStr = await FileOperation().getFileContent('train_info.json');
    final carList = json.decode(jsonStr)['trains'][_trainNo];

    // 列車詳細情報がないなら終了
    if (carList == null) {
      return;
    }

    // 車両情報を1両ごとにリストに追加
    for (var i in carList[0]['cars']) {
      _trainInfoJsonList.add(i);
    }
    // 新快速等、連結車両用
    if (carList.length == 2) {
      for (var i in carList[1]['cars']) {
        _trainInfoJsonList.add(i);
      }
    }

    // 情報表示用リストに追加
    for (var i in _trainInfoJsonList) {
      _trainCarsNo.add(i['carNo']);
      _trainCarsCongestion.add(i['congestion']);
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
      child: InkWell(
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
                    Row(
                      children: [
                        Text(_trainType),
                        Spacer(),
                        _dest == '' ? Text('') : Text('$_dest行き'),
                        Spacer(),
                        _numberOfCars == 0 ? Text('') : Text('$_numberOfCars両'),
                      ],
                    ),
                    Text(widget.trainMap.toString()),
                    // jsonから車両データを正しく取得できたら情報を表示する
                    if (_trainInfoJsonList.isNotEmpty) ...{
                      Text(_trainCarsNo.toString()),
                      Text(_trainCarsCongestion.toString()),
                      Text('$_delayMinutes分遅れ'),
                      Text(_nickname),
                    },
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
                    if (_delayMinutes > 0) ...{
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
                            '$_delayMinutes分遅れ',
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
                    if (_delayMinutes > 0) ...{
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
                            '$_delayMinutes分遅れ',
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
