import 'package:flutter/material.dart';
import 'package:jr_train_pos/line_manager.dart';
import 'package:jr_train_pos/shared_pref.dart';

class MyLineScreen extends StatefulWidget {
  const MyLineScreen({super.key});

  @override
  State<MyLineScreen> createState() => _MyLineScreenState();
}

class _MyLineScreenState extends State<MyLineScreen> {
  final _sharedPref = SharedPref();
  final _lineManager = LineManager();

  late List<String> _myLineList;
  bool _isGetMyLineList = false;

  // my路線に登録されている路線のウィジェットを作成する関数
  List<Widget> _createLineWidget(){
    final List<Widget> widgetList = [];

    for(var i in _myLineList){
      widgetList.add(_lineManager.getLineWidget(int.parse(i)));
    }

    return widgetList;
  }

  @override
  void initState() {
    super.initState();

    Future(() async{
      _myLineList = await _sharedPref.getMyLineList();
      setState(() {
        _isGetMyLineList = true;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    // my路線が取得できていないとき
    if(!_isGetMyLineList){
      return Center(
        child: CircularProgressIndicator(),
      );
    }

    // my路線が登録されていないとき
    if(_myLineList.isEmpty){
      return Scaffold(body: Center(child: Text('MY路線が登録されていません'),),);
    }
    return Scaffold(
      body: Column(
        children:[
          Padding(
            padding: EdgeInsets.all(12),
            child: const Text('My路線', style: TextStyle(fontSize: 16),),
          ),
          ..._createLineWidget(),
        ]
      ),
    );
  }
}
