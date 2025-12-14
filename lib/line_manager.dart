import 'package:flutter/material.dart';

import 'package:jr_train_pos/widgets/line.dart';

class LineManager {
  static const String A = '東海道本線';
  static const String B = '湖西線';
  static const String C = '草津線';
  static const String D = '奈良線';
  static const String E = '嵯峨野山陰線';
  static const String F = 'おおさか東線';
  static const String G = '宝塚線';
  static const String H = '東西線・学研都市線';
  static const String O = '大阪環状線';

  // 路線一覧画面に表示するウィジェットのリスト
  final List<Widget> lineWidgetList = [
    Line(
      lineName: A,
      lineColor: 0xff2574b7,
      lineCode: 'A',
      lineCodeColor: 0xffffffff,
    ),
    Line(
      lineName: B,
      lineColor: 0xff38aecf,
      lineCode: 'B',
      lineCodeColor: 0xffffffff,
    ),
    Line(
      lineName: C,
      lineColor: 0xff60983d,
      lineCode: 'C',
      lineCodeColor: 0xffffffff,
    ),
    Line(
      lineName: D,
      lineColor: 0xffa67129,
      lineCode: 'D',
      lineCodeColor: 0xffffffff,
    ),
    Line(
      lineName: E,
      lineColor: 0xff898fd9,
      lineCode: 'E',
      lineCodeColor: 0xffffffff,
    ),
    Line(
      lineName: F,
      lineColor: 0xff4b7187,
      lineCode: 'F',
      lineCodeColor: 0xffffffff,
    ),
    Line(
      lineName: G,
      lineColor: 0xfffabc3c,
      lineCode: 'G',
      lineCodeColor: 0xff000000,
    ),
    Line(
      lineName: H,
      lineColor: 0xffda5a83,
      lineCode: 'H',
      lineCodeColor: 0xffffffff,
    ),
    Line(
      lineName: O,
      lineColor: 0xffed1749,
      lineCode: 'O',
      lineCodeColor: 0xffffffff,
    ),
  ];

  // 全ての路線ウィジェットを返す関数
  List<Widget> getAllLineWidgetList() {
    return lineWidgetList;
  }

  List<String> getMainStation(String lineNameJa) {
    List<String> mainStationList = [];

    switch (lineNameJa) {
      case A:
        mainStationList.addAll(['米原', '京都', '大阪', '三ノ宮', '姫路']);
        break;
      case B:
        mainStationList.addAll(['京都']);
        break;
      case C:
        mainStationList.addAll(['草津', '貴生川']);
        break;
      case D:
        mainStationList.addAll(['京都', '木津']);
        break;
      case E:
        mainStationList.addAll(['京都', '綾部', '福知山']);
        break;
      case F:
        mainStationList.addAll(['大阪', '放出', '久宝寺']);
        break;
      case G:
        mainStationList.addAll(['大阪', '宝塚', '福知山']);
        break;
      case H:
        mainStationList.addAll(['木津', '放出', '京橋', '北新地']);
        break;
      case O:
        mainStationList.addAll(['大阪', '天王寺', '京橋']);
        break;
    }

    return mainStationList;
  }

  // 日本語路線名からjsonファイル用の路線名に変換する関数（東海道本線などの都合により配列を返す）
  List<String> changeLineNameToJsonFile(String lineNameJa) {
    List<String> result = [];
    result.clear();

    switch (lineNameJa) {
      case A:
        result.add('hokuriku');
        result.add('hokurikubiwako');
        result.add('kyoto');
        result.add('kobesanyo');
        break;
      case B:
        result.add('kosei');
        break;
      case C:
        result.add('kusatsu');
        break;
      case D:
        result.add('nara');
        break;
      case E:
        result.add('sagano');
        result.add('sanin1');
        break;
      case F:
        result.add('osakahigashi');
        break;
      case G:
        result.add('takarazuka');
        result.add('fukuchiyama');
        break;
      case H:
        result.add('gakkentoshi');
        result.add('tozai');
        break;
      case O:
        result.add('osakaloop');
        break;
    }

    return result;
  }
}
