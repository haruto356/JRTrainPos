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
  static const String J = '播但線';
  static const String L = '舞鶴線';
  static const String O = '大阪環状線';
  static const String P = 'JRゆめ咲線';
  static const String Q = '大和路線';
  static const String R = '阪和線';
  static const String S = '関西空港線';
  static const String T = '和歌山線';
  static const String U = '万葉まほろば線';
  static const String V = '関西線';
  static const String W = 'きのくに線';

  // 日本語路線名のリスト
  final List<String> lineStringList = [
    A,
    B,
    C,
    D,
    E,
    F,
    G,
    H,
    J,
    L,
    O,
    P,
    Q,
    R,
    S,
    T,
    U,
    V,
    W,
  ];

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
      lineName: J,
      lineColor: 0xff9f2d5d,
      lineCode: 'J',
      lineCodeColor: 0xffffffff,
    ),
    Line(
      lineName: L,
      lineColor: 0xfff78b35,
      lineCode: 'L',
      lineCodeColor: 0xff000000,
    ),
    Line(
      lineName: O,
      lineColor: 0xffed1749,
      lineCode: 'O',
      lineCodeColor: 0xffffffff,
    ),
    Line(
      lineName: P,
      lineColor: 0xff133f85,
      lineCode: 'P',
      lineCodeColor: 0xffffffff,
    ),
    Line(
      lineName: Q,
      lineColor: 0xff35b17d,
      lineCode: 'Q',
      lineCodeColor: 0xffffffff,
    ),
    Line(
      lineName: R,
      lineColor: 0xfff78b35,
      lineCode: 'R',
      lineCodeColor: 0xff000000,
    ),
    Line(
      lineName: S,
      lineColor: 0xff2574b7,
      lineCode: 'S',
      lineCodeColor: 0xffffffff,
    ),
    Line(
      lineName: T,
      lineColor: 0xfff19eba,
      lineCode: 'T',
      lineCodeColor: 0xff000000,
    ),
    Line(
      lineName: U,
      lineColor: 0xffac1434,
      lineCode: 'U',
      lineCodeColor: 0xffffffff,
    ),
    Line(
      lineName: V,
      lineColor: 0xff562db3,
      lineCode: 'V',
      lineCodeColor: 0xffffffff,
    ),
    Line(
      lineName: W,
      lineColor: 0xff34a7b3,
      lineCode: 'W',
      lineCodeColor: 0xffffffff,
    ),
  ];

  // 全ての路線ウィジェットを返す関数
  List<Widget> getAllLineWidgetList() {
    return lineWidgetList;
  }

  // 指定した路線のウィジェットを返す関数
  Widget getLineWidget(int index){
    return lineWidgetList[index];
  }

  // 日本語路線名のリストを返す関数
  List<String> getLineStringList(){
    return lineStringList;
  }

  // 指定した路線の主要駅を返す関数
  List<String> getMainStation(String lineNameJa) {
    List<String> mainStationList = [];

    switch (lineNameJa) {
      case A:
        mainStationList.addAll(['米原', '京都', '大阪', '三ノ宮', '姫路']);
        break;
      case B:
        mainStationList.addAll(['京都', '比叡山坂本', '近江今津']);
        break;
      case C:
        mainStationList.addAll(['草津', '貴生川', '柘植']);
        break;
      case D:
        mainStationList.addAll(['京都', '宇治', '木津']);
        break;
      case E:
        mainStationList.addAll(['京都', '亀岡', '園部', '綾部', '福知山']);
        break;
      case F:
        mainStationList.addAll(['大阪', '放出', '久宝寺']);
        break;
      case G:
        mainStationList.addAll(['大阪', '宝塚', '新三田', '福知山']);
        break;
      case H:
        mainStationList.addAll(['木津', '四条畷', '放出', '京橋', '北新地']);
        break;
      case J:
        mainStationList.addAll(['姫路', '福崎']);
        break;
      case L:
        mainStationList.addAll(['綾部', '東舞鶴']);
        break;
      case O:
        mainStationList.addAll(['大阪', '天王寺', '京橋']);
        break;
      case P:
        mainStationList.addAll(['西九条']);
        break;
      case Q:
        mainStationList.addAll(['天王寺', '久宝寺', '王寺', '奈良']);
        break;
      case R:
        mainStationList.addAll(['天王寺', '鳳', '日根野', '和歌山']);
        break;
      case S:
        mainStationList.addAll(['日根野']);
        break;
      case T:
        mainStationList.addAll(['王寺', '五条', '橋本', '和歌山']);
        break;
      case U:
        mainStationList.addAll(['奈良', '天理', '桜井', '高田']);
        break;
      case V:
        mainStationList.addAll(['加茂', '柘植', '亀山']);
        break;
      case W:
        mainStationList.addAll(['和歌山', '海南', '御坊', '白浜', '串本']);
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
      case J:
        result.add('bantan');
        break;
      case L:
        result.add('maizuru');
        break;
      case O:
        result.add('osakaloop');
        break;
      case P:
        result.add('yumesaki');
        break;
      case Q:
        result.add('yamatoji');
        break;
      case R:
        result.add('hanwahagoromo');
        break;
      case S:
        result.add('kansaiairport');
        break;
      case T:
        result.add('wakayama2');
        result.add('wakayama1');
        break;
      case U:
        result.add('manyomahoroba');
        break;
      case V:
        result.add('kansai');
        break;
      case W:
        result.add('kinokuni');
        break;
    }

    return result;
  }
}
