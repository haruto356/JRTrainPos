import 'package:flutter/material.dart';
import 'package:jr_train_pos/core/line_manager.dart';
import 'package:jr_train_pos/screens/my_line_edit_screen.dart';
import 'package:jr_train_pos/core/shared_pref.dart';
import 'package:url_launcher/url_launcher.dart';

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
  late Widget _goJrOfficialInfoButton;

  // SharedPreferencesからデータを取得する関数
  Future<void> _getMyLineList() async{
    _myLineList = await _sharedPref.getMyLineList();
    setState(() {
      _isGetMyLineList = true;
    });
  }

  @override
  void initState() {
    // my路線編集ボタン
    _floatingActionButton = FloatingActionButton(
      onPressed: () async {
        await Navigator.push(context, MaterialPageRoute(builder: (context) => const MyLineEditScreen()));
        await _getMyLineList();
      },
      child: const Icon(Icons.edit),
    );

    // JR公式情報遷移ボタン
    _goJrOfficialInfoButton = Ink(
      decoration: BoxDecoration(
        color: Colors.blue[100],
        border: Border.all(color: Colors.blue),
        borderRadius: BorderRadius.circular(10),
      ),
      child: InkWell(
        onTap: (){
          launchUrl(Uri.parse('https://trafficinfo.westjr.co.jp/kinki.html'));
        },
        child: const Padding(
          padding: EdgeInsetsGeometry.fromLTRB(35, 3, 35, 3),
          child: Text('JR西日本公式遅延情報'),
        ),
      )
    );

    super.initState();

    Future(() async{
      await _getMyLineList();
    });
  }

  @override
  Widget build(BuildContext context) {
    // my路線が取得できていないとき
    if(!_isGetMyLineList){
      return const Center(
        child: CircularProgressIndicator(),
      );
    }

    // my路線が登録されていないとき
    if(_myLineList.isEmpty){
      return Scaffold(
        floatingActionButton: _floatingActionButton,
        body: Center(
          child: Column(
            children: [
              const SizedBox(height: 15,),
              _goJrOfficialInfoButton,
              const SizedBox(height: 10,),
              const Text('My路線が登録されていません'),
            ],
          )
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
              const SizedBox(height: 15,),
              _goJrOfficialInfoButton,
              const Padding(
                padding: EdgeInsets.all(12),
                child: Text('My路線', style: TextStyle(fontSize: 16),),
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
