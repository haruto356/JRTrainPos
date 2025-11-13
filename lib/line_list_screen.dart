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
      body: SingleChildScrollView(
        child: Center(
          child: Column(
            children: [
              // 路線一覧
              const Line(lineName: '東海道本線', lineColor: 0xff2574b7, lineCode: 'A', lineCodeColor: 0xffffffff,),
              const Line(lineName: '湖西線', lineColor: 0xff38aecf, lineCode: 'B', lineCodeColor: 0xffffffff,),
              const Line(lineName: '草津線', lineColor: 0xff60983d, lineCode: 'C', lineCodeColor: 0xffffffff,),
              const Line(lineName: '奈良線', lineColor: 0xffa67129, lineCode: 'D', lineCodeColor: 0xffffffff,),
              const Line(lineName: '嵯峨野山陰線', lineColor: 0xff898fd9, lineCode: 'E', lineCodeColor: 0xffffffff,),
              const Line(lineName: 'おおさか東線', lineColor: 0xff4b7187, lineCode: 'F', lineCodeColor: 0xffffffff,),
              const Line(lineName: '宝塚線', lineColor: 0xfffabc3c, lineCode: 'G', lineCodeColor: 0xff000000,),
              const Line(lineName: '東西線・学研都市線', lineColor: 0xffda5a83, lineCode: 'H', lineCodeColor: 0xffffffff,),
              const Line(lineName: '大阪環状線', lineColor: 0xffed1749, lineCode: 'O', lineCodeColor: 0xffffffff,),
            ],
          )
        ),
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
                SizedBox(width: 15,),
                Container(
                  width: 35,
                  padding: EdgeInsets.all(5),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(3),
                    color: Color(lineColor),
                  ),
                  child: Text(
                    lineCode,
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Color(lineCodeColor),
                    ),
                  ),
                ),

                // 路線名
                SizedBox(width: 20,),
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

