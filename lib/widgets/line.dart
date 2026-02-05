import 'package:flutter/material.dart';

import 'package:jr_train_pos/screens/train_pos_screen.dart';

class Line extends StatelessWidget {
  const Line({
    super.key,
    required this.lineName,
    required this.lineColor,
    required this.lineCode,
    required this.lineCodeColor,
  });

  final String lineName; // 路線名
  final int lineColor; // 路線カラー
  final String lineCode; // 路線番号
  final int lineCodeColor; // 路線番号の文字色

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.all(8),
      decoration: BoxDecoration(
        boxShadow: [
          BoxShadow(
            color: Colors.grey.shade300,
            offset: const Offset(2, 2),
            spreadRadius: 1.2,
            blurRadius: 1,
          )
        ],
        borderRadius: BorderRadius.circular(12),
      ),
      child: Material(
        color: Colors.white,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),

        child: InkWell(
          // 画面遷移
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder:
                    (context) => TrainPosScreen(
                      lineName: lineName,
                      lineColor: lineColor,
                      lineCodeColor: lineCodeColor,
                    ),
              ),
            );
          },
          child: Padding(
            padding: const EdgeInsets.all(14),
            child: Row(
              children: [
                // 路線番号
                const SizedBox(width: 15),
                Container(
                  width: 35,
                  padding: const EdgeInsets.all(5),
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
                const SizedBox(width: 20),
                Text(
                  lineName,
                  style: const TextStyle(fontSize: 17, fontWeight: FontWeight.bold),
                ),

                // アイコン
                const Spacer(flex: 10),
                const Icon(Icons.keyboard_arrow_right),
                const Spacer(flex: 1),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
