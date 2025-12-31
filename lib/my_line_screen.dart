import 'package:flutter/material.dart';
import 'package:jr_train_pos/line_manager.dart';
import 'package:jr_train_pos/my_line_edit_screen.dart';
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

  late FloatingActionButton _floatingActionButton;

  // SharedPreferencesからデータを取得する関数
  Future<void> _getMyLineList() async{
    _myLineList = await _sharedPref.getMyLineList();
    setState(() {
      _isGetMyLineList = true;
    });
  }

  @override
  void initState() {
    super.initState();

    // my路線編集ボタン
    _floatingActionButton = FloatingActionButton(
      onPressed: () async {
        await Navigator.push(context, MaterialPageRoute(builder: (context) => MyLineEditScreen()));
        _getMyLineList();
      },
      child: const Icon(Icons.edit),
    );

    Future(() async{
      _getMyLineList();
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
      return Scaffold(
        floatingActionButton: _floatingActionButton,
        body: Center(
          child: Text('My路線が登録されていません'),
        ),
      );
    }

    // my路線が登録されているとき
    else {
      return Scaffold(
        floatingActionButton: _floatingActionButton,
        body: SingleChildScrollView(
          child: Column(
            children: [
              Padding(
                padding: EdgeInsets.all(12),
                child: const Text('My路線', style: TextStyle(fontSize: 16),),
              ),
              for(var i in _myLineList)
                _lineManager.getLineWidget(int.parse(i)),
            ]
          ),
        )
      );
    }
  }
}
