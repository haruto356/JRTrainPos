import 'package:flutter/material.dart';

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

  @override
  void initState() {
    super.initState();

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
      left: _direction == 0 ? MediaQuery.of(context).size.width / 2 - 75 : MediaQuery.of(context).size.width / 2 + 55,
      child: Container(
        height: 30,
        width: 30,
        color: Color(widget.lineColor),
      ),
    );
  }
}