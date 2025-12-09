import 'package:flutter/material.dart';

import 'package:jr_train_pos/widgets/line.dart';

class LineManager {
  // 路線一覧画面に表示するウィジェットのリスト
  final List<Widget> lineWidgetList = [
    Line(lineName: '東海道本線', lineColor: 0xff2574b7, lineCode: 'A', lineCodeColor: 0xffffffff,),
    Line(lineName: '湖西線', lineColor: 0xff38aecf, lineCode: 'B', lineCodeColor: 0xffffffff,),
    Line(lineName: '草津線', lineColor: 0xff60983d, lineCode: 'C', lineCodeColor: 0xffffffff,),
    Line(lineName: '奈良線', lineColor: 0xffa67129, lineCode: 'D', lineCodeColor: 0xffffffff,),
    Line(lineName: '嵯峨野山陰線', lineColor: 0xff898fd9, lineCode: 'E', lineCodeColor: 0xffffffff,),
    Line(lineName: 'おおさか東線', lineColor: 0xff4b7187, lineCode: 'F', lineCodeColor: 0xffffffff,),
    Line(lineName: '宝塚線', lineColor: 0xfffabc3c, lineCode: 'G', lineCodeColor: 0xff000000,),
    Line(lineName: '東西線・学研都市線', lineColor: 0xffda5a83, lineCode: 'H', lineCodeColor: 0xffffffff,),
    Line(lineName: '大阪環状線', lineColor: 0xffed1749, lineCode: 'O', lineCodeColor: 0xffffffff,),
  ];

  // 全ての路線ウィジェットを返す関数
  List<Widget> getAllLineWidgetList(){
    return lineWidgetList;
  }

  // 日本語路線名からjsonファイル用の路線名に変換する関数（東海道本線などの都合により配列を返す）
  List<String> changeLineNameToJsonFile(String lineNameJa){
    List<String> result = [];
    result.clear();

    switch(lineNameJa){
      case '東海道本線':
        result.add('hokuriku');
        result.add('hokurikubiwako');
        result.add('kyoto');
        result.add('kobesanyo');
        break;
      case '湖西線':
        result.add('kosei');
        break;
      case '草津線':
        result.add('kusatsu');
        break;
      case '奈良線':
        result.add('nara');
        break;
      case '嵯峨野山陰線':
        result.add('sagano');
        result.add('sanin1');
        break;
      case 'おおさか東線':
        result.add('osakahigashi');
        break;
      case '宝塚線':
        result.add('takarazuka');
        result.add('fukuchiyama');
        break;
      case '東西線・学研都市線':
        result.add('gakkentoshi');
        result.add('tozai');
        break;
      case '大阪環状線':
        result.add('osakaloop');
        break;
    }

    return result;
  }
}