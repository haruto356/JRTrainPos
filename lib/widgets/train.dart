import 'package:flutter/material.dart';

class Train extends StatefulWidget {
  const Train({super.key, required this.lineColor, required this.posFirst, required this.posSecond, required this.direction});

  final int lineColor;
  final int posFirst;
  final int posSecond;
  final int direction;

  @override
  State<Train> createState() => _TrainState();
}

class _TrainState extends State<Train> {
  int _posTop = 0;
  late double screenWidth;

  @override
  void initState() {
    super.initState();

    // 停車中
    if(widget.posSecond == 0) {
      _posTop = widget.posFirst;
    }
    // 駅間
    else {
      _posTop = widget.posFirst - 1;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Positioned(
      top: _posTop * 70 + 40,
      left: widget.direction == 0 ? MediaQuery.of(context).size.width / 2 - 75 : MediaQuery.of(context).size.width / 2 + 55,
      child: Container(
        height: 30,
        width: 30,
        color: Color(widget.lineColor),
      ),
    );
  }
}