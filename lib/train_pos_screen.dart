import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:jr_train_pos/file_operation.dart';
import 'dart:convert';

import 'package:jr_train_pos/get_json_file.dart';
import 'package:jr_train_pos/line_manager.dart';
import 'package:jr_train_pos/widgets/train.dart';

class TrainPosScreen extends StatefulWidget {
  const TrainPosScreen({super.key, required this.lineName, required this.lineColor, required this.lineCodeColor});

  final String lineName;
  final int lineColor;
  final int lineCodeColor;

  @override
  State<TrainPosScreen> createState() => _TrainPosScreenState();
}

class _TrainPosScreenState extends State<TrainPosScreen> with WidgetsBindingObserver {
  final _fileOperation = FileOperation();
  final _getJsonFile = GetJsonFile();
  final _lineManager = LineManager();

  final ScrollController _scrollController = ScrollController();

  final List<String?> _stationList = ['####'];
  final List<String> _trainPosJsonStringList = [];
  final List<Map<String, String?>> _trainJsonMapList = [];
  final Map<String, String?> _stationPosMap = {'####' : '####'}; // 駅コード、駅名の順

  final List<Widget> _stationWidgetList = [];
  final List<Widget> _trainWidgetList = [];

  bool _isRefreshButtonDisabled = false;

  bool _isWidgetCreated = false;

  // ウィジェットのキャッシュ
  late final Widget _lineColorMarkerCache;
  late final Widget _stationBetweenWidgetCache;

  // 駅ウィジェットのリストをjsonから作成し、描画する関数
  Future<void> _drawStationList() async {
    _stationWidgetList.clear();

    final List<String> lineFileList = _lineManager.changeLineNameToJsonFile(widget.lineName);

    // 余白を追加
    _stationWidgetList.add(StationEnd());

    for(var i in lineFileList){
      final jsonStr = await _fileOperation.getFileContent('$i.json');
      Map<String, dynamic> lineMap = json.decode(jsonStr);

      for(int j = 0; j < lineMap['stations'].length; j++) {
        String stationName = lineMap['stations'][j]['info']['name'];
        // 重複を排除
        if(!_stationList.contains(stationName)){
          _stationList.add(stationName);
          _stationList.add(null);
        }

        // 駅コードと駅名を連想配列に格納
        _stationPosMap[lineMap['stations'][j]['info']['code']] = stationName;
      }
    }

    // 不要なnullを削除
    _stationList.removeLast();

    // Widgetをリストに追加
    for(var i in _stationList){
      if(i != '####') {
        if(i == null){
          _stationWidgetList.add(_stationBetweenWidgetCache);
        }
        else {
          final mainStationList = _lineManager.getMainStation(widget.lineName);
          bool isMainStation = false;

          if(mainStationList.contains(i)){
            isMainStation = true;
          }
          _stationWidgetList.add(Station(stationName: i, lineColor: widget.lineColor, lineColorMarker: _lineColorMarkerCache, isMainStation: isMainStation,));
        }
      }
    }

    // 余白を追加
    _stationWidgetList.add(StationEnd());
  }

  // 列車を描画する関数
  Future<void> _drawTrain() async {
    _trainWidgetList.clear();

    // リストが更新されてから列車を描画する
    int i = 0;
    while(_trainJsonMapList.isEmpty){
      await Future.delayed(Duration(milliseconds: 1));
      i++;
      if(i >= 5000) {
        // しばらく待ってもリストが空の場合、その路線に列車が存在しないとする
        return;
      }
    }

    // 追加したposのリスト
    Set<String> addedPosList = {};

    // 下方向のTrainウィジェットをリストに追加
    for(var j in _trainJsonMapList) {
      if(j['direction'].toString() == '0'){
        continue;
      }

      String currentPos = j['pos'].toString();

      // 既に追加済みならスキップ
      if(addedPosList.contains(currentPos)){
        continue;
      }

      // 同じ位置の列車を抽出
      List<Map<String, String?>> trainList = _trainJsonMapList
        .where((train) => train['pos'].toString() == currentPos && train['direction'].toString() == '1')
        .toList();

      _trainWidgetList.add(Train(
        lineColor: widget.lineColor,
        trainMap: trainList,
        stationList: _stationList,
        stationPosMap: _stationPosMap,
      ));

      addedPosList.add(currentPos);
    }

    addedPosList.clear();

    // 上方向のTrainウィジェットをリストに追加
    for(var j in _trainJsonMapList) {
      if(j['direction'].toString() == '1'){
        continue;
      }

      String currentPos = j['pos'].toString();

      // 既に追加済みならスキップ
      if(addedPosList.contains(currentPos)){
        continue;
      }

      // 同じ位置の列車を抽出
      List<Map<String, String?>> trainList = _trainJsonMapList
          .where((train) => train['pos'].toString() == currentPos && train['direction'].toString() == '0')
          .toList();

      _trainWidgetList.add(Train(
        lineColor: widget.lineColor,
        trainMap: trainList,
        stationList: _stationList,
        stationPosMap: _stationPosMap,
      ));

      addedPosList.add(currentPos);
    }
  }

  // jsonデータを取得する関数
  Future<void> _dataRefresh() async {
    _trainPosJsonStringList.clear();
    _trainJsonMapList.clear();

    Future(() async {
      final List<String> lineList = _lineManager.changeLineNameToJsonFile(widget.lineName);

      // 列車走行位置の取得
      for (var i in lineList) {
        try {
          _trainPosJsonStringList.add(await _getJsonFile.getTrainPos(i));
        } catch(e) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('列車走行位置データの取得に失敗しました(${widget.lineName})'), duration: Duration(seconds: 1),),
          );
        }
      }

      // 車両No重複検知用リスト
      List<String> addedTrainNoList = [];

      // 列車jsonデータをリストに格納
      for(var i in _trainPosJsonStringList){

        final Map<String, dynamic> jsonMap = json.decode(i);
        for(var j in jsonMap['trains']){
          // dynamicをMap<String, String?>に変換してからリストに追加
          final temp = (j as Map).map(
            (key, value) => MapEntry(key.toString(), value?.toString()),
          );

          // 既に該当する車両Noがあるときのみリストに追加
          if(!addedTrainNoList.contains(temp['no'])){
            _trainJsonMapList.add(temp);
            addedTrainNoList.add(temp['no'].toString());
          }
        }
      }

      // 列車詳細情報の取得
      await _getJsonFile.getTrainInfo();
    });
  }

  // 駅リストを取得する関数
  Future<void> _getStationList() async {
    final List<String> lineList = _lineManager.changeLineNameToJsonFile(widget.lineName);
    for(var i in lineList){
      await _getJsonFile.getStationList(i);
    }
  }

  // 更新ボタンが押されたとき
  Future<void> _onPressedRefreshButton() async {
    setState(() {
      _isRefreshButtonDisabled = true;
    });

    await _dataRefresh();
    await _drawTrain();
    setState(() {});

    // 連打対策として一定時間ボタンを無効化
    await Future.delayed(Duration(seconds: 5));

    if(mounted) {
      setState(() {
        _isRefreshButtonDisabled = false;
      });
    }
  }

  // 主要駅にジャンプするダイアログのオプションを作る関数
  List<SimpleDialogOption> _createDialogOption() {
    final List<String> mainStationList = _lineManager.getMainStation(widget.lineName);
    final List<SimpleDialogOption> dialogOptionList = [];

    // 指定された駅までジャンプする関数
    onDialogOptionPressed(String stationName){
      if(stationName == '一番上'){
        _scrollController.jumpTo(0);
      }
      else if(stationName == '一番下'){
        _scrollController.jumpTo(_scrollController.position.maxScrollExtent);
      }
      else {
        // 指定した駅が真ん中に来るように-4で調整
        double jumpPos = (_stationList.indexOf(stationName) - 4) * 70.0;
        // ジャンプ先が0未満
        if(jumpPos < 0){
          jumpPos = 0.0;
        }
        // ジャンプ先がスクロール範囲外
        else if(jumpPos > _scrollController.position.maxScrollExtent){
          jumpPos = _scrollController.position.maxScrollExtent;
        }
        _scrollController.jumpTo(jumpPos);
      }
    }

    // 一番上を追加
    dialogOptionList.add(
      SimpleDialogOption(
        onPressed: (){
          onDialogOptionPressed('一番上');
          Navigator.pop(context);
        },
        child: const Text('一番上'),
      )
    );

    // 主要駅を追加
    for(var i in mainStationList){
      dialogOptionList.add(
        SimpleDialogOption(
          onPressed: (){
            onDialogOptionPressed(i);
            Navigator.pop(context);
          },
          child: Text('$i駅'),
        )
      );
    }

    // 一番下を追加
    dialogOptionList.add(
      SimpleDialogOption(
        onPressed: (){
          onDialogOptionPressed('一番下');
          Navigator.pop(context);
        },
        child: const Text('一番下'),
      )
    );

    return dialogOptionList;
  }

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);

    // ウィジェットのキャッシュを作成
    _lineColorMarkerCache = LineColorMarker(lineColor: widget.lineColor);
    _stationBetweenWidgetCache = Station(stationName: null, lineColor: widget.lineColor, lineColorMarker: _lineColorMarkerCache, isMainStation: false,);

    Future(() async{
      await _getStationList();
      await _dataRefresh();
      await _drawStationList();
      await _drawTrain();

      // 情報更新待ち
      await Future.delayed(Duration(milliseconds: 100));

      if(mounted){
        setState(() {
          _isWidgetCreated = true;
        });
      }
    });
  }

  @override
  void dispose(){
    super.dispose();
    // ステータスバーの色変更
    SystemChrome.setSystemUIOverlayStyle(
      SystemUiOverlayStyle(
        statusBarBrightness: Brightness.light,
        statusBarIconBrightness: Brightness.dark
      )
    );

    _scrollController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // 列車位置が取得できていないならロード画面を描画する
    if(!_isWidgetCreated){
      return Scaffold(
        appBar: AppBar(
          title: Text(widget.lineName),
          titleTextStyle: TextStyle(color: Color(widget.lineCodeColor), fontSize: 20, fontFamily: 'NotoSansJP'),
          backgroundColor: Color(widget.lineColor),
          iconTheme: IconThemeData(color: Color(widget.lineCodeColor)),
        ),
        body: Center(
          child: CircularProgressIndicator(),
        )
      );
    }

    return Scaffold(
      appBar: AppBar(
        title: Text(widget.lineName),
        titleTextStyle: TextStyle(color: Color(widget.lineCodeColor), fontSize: 20, fontFamily: 'NotoSansJP'),
        backgroundColor: Color(widget.lineColor),
        iconTheme: IconThemeData(color: Color(widget.lineCodeColor)),
        actions: [
          IconButton(
            onPressed: _isRefreshButtonDisabled ? null : _onPressedRefreshButton,
            icon: const Icon(Icons.refresh),
          ),
        ],
      ),

      floatingActionButton: FloatingActionButton(
        onPressed: (){
          // 選択肢を表示
          showDialog(
            context: context,
            builder: (context) {
              return SimpleDialog(
                title: const Text('移動先を選択'),
                children: _createDialogOption(),
              );
            }
          );
        },
      ),

      body: SafeArea(
        child: SingleChildScrollView(
          controller: _scrollController,
          child: Stack(
            children: [
              Column(
                children: _stationWidgetList,
              ),
              ..._trainWidgetList
            ],
          ),
        ),
      ),
    );
  }
}

// 駅ウィジェット
class Station extends StatelessWidget {
  const Station({super.key, required this.stationName, required this.lineColor, required this.lineColorMarker, required this.isMainStation});
  final int lineColor;
  final String? stationName;
  final Widget lineColorMarker;
  final bool isMainStation;

  @override
  Widget build(BuildContext context) {
    // 駅
    if(stationName != null){
      return Container(
        height: 70,
        color: Colors.white12,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const SizedBox(width: 15,),
            Text(stationName!, style: TextStyle(fontSize: isMainStation? 17 : 14, fontWeight: FontWeight.w600),),
            const Spacer(),
            lineColorMarker,
            const Spacer(),
            // バランスをとるためのダミー
            Text(stationName!, style: TextStyle(color: Colors.white12, fontSize: isMainStation? 17 : 14, fontWeight: FontWeight.w600,),),
            const SizedBox(width: 15,),
          ],
        ),
      );
    }
    // 駅間
    else {
      return Container(
        height: 70,
        color: Colors.white,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              width: 12,
              color: Color(lineColor),
            )
          ],
        ),
      );
    }
  }
}

// 駅の終わりのウィジェット
class StationEnd extends StatelessWidget{
  const StationEnd({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 20,
      color: Colors.white,
    );
  }
}

// 駅ウィジェットの路線カラー表示ウィジェット
class LineColorMarker extends StatelessWidget{
  const LineColorMarker({super.key, required this.lineColor});
  final int lineColor;

  @override
  Widget build(BuildContext context) {
    return Stack(
      alignment: Alignment.center,
      children: [
        Container(
          width: 12,
          color: Color(lineColor),
        ),
        Container(
          height: 10,
          width: 10,
          decoration: const BoxDecoration(
              color: Colors.white,
              shape: BoxShape.circle
          ),
        )
      ],
    );
  }
}