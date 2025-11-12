import 'package:flutter/material.dart';

import 'package:jr_train_pos/train_pos_screen.dart';

class LineListScreen extends StatefulWidget {
  const LineListScreen({super.key});

  @override
  State<LineListScreen> createState() => _LineListScreenState();
}

class _LineListScreenState extends State<LineListScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          children: [
            // 路線一覧
            const Line(lineName: '東海道本線', lineColor: 0xff2574b7, lineCode: ' A ', lineCodeColor: 0xffffffff,),
            const Line(lineName: '湖西線', lineColor: 0xff38aecf, lineCode: ' B ', lineCodeColor: 0xffffffff,),
            const Line(lineName: '草津線', lineColor: 0xff60983d, lineCode: ' C ', lineCodeColor: 0xffffffff,),
            const Line(lineName: '奈良線', lineColor: 0xffa67129, lineCode: ' D ', lineCodeColor: 0xffffffff,),
          ],
        )
      ),
    );
  }
}

class Line extends StatelessWidget {
  const Line({super.key, required this.lineName, required this.lineColor, required this.lineCode, required this.lineCodeColor});

  final String lineName; // 路線名
  final int lineColor; // 路線カラー
  final String lineCode; // 路線番号
  final int lineCodeColor; // 路線番号の文字色



  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.all(8),
      child: Material(
        color: Colors.white,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),

        child: InkWell(
          // 画面遷移
          onTap: (){
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => TrainPosScreen(lineName: lineName, lineColor: lineColor, lineCodeColor: lineCodeColor,)
              )
            );
          },
          child: Padding(
            padding: EdgeInsets.all(14),
            child: Row(
              children: [
                // 路線番号
                Spacer(flex: 1,),
                Container(
                  padding: EdgeInsets.all(5),
                  color: Color(lineColor),
                  child: Text(lineCode, style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Color(lineCodeColor)),),
                ),

                // 路線名
                Spacer(flex: 2,),
                Text(lineName, style: TextStyle(fontSize: 17, fontWeight: FontWeight.bold),),

                // アイコン
                Spacer(flex: 10,),
                Icon(Icons.keyboard_arrow_right),
                Spacer(flex: 1,)
              ],
            ),
          ),
        ),
      ),
    );
  }
}

