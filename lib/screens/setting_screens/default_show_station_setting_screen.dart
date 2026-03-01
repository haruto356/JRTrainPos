import 'package:flutter/material.dart';

import 'package:jr_train_pos/core/line_manager.dart';
import 'package:jr_train_pos/screens/setting_screens/default_show_station_select_screen.dart';
import 'package:jr_train_pos/core/shared_pref.dart';

class DefaultShowStationSettingScreen extends StatefulWidget {
  const DefaultShowStationSettingScreen({super.key});

  @override
  State<DefaultShowStationSettingScreen> createState() => _DefaultShowStationSettingScreenState();
}

class _DefaultShowStationSettingScreenState extends State<DefaultShowStationSettingScreen> {
  final _lineManager = LineManager();
  final _sharedPref = SharedPref();

  late final List<String> _lineList;
  final List<String> _defaultStationList = [];

  bool _isSharedPrefGet = false;

  // 初期表示駅リストを更新する関数
  Future<void> _setDefaultStationList() async {
    _defaultStationList.clear();

    for(var i in _lineList){
      String defaultStation = await _sharedPref.getPrefString('$i初期表示駅');
      if(defaultStation.isEmpty){
        _defaultStationList.add('未設定');
      } else {
        _defaultStationList.add(defaultStation);
      }
    }

    setState(() {
      _isSharedPrefGet = true;
    });
  }

  @override
  void initState() {
    super.initState();

    _lineList = _lineManager.getLineStringList();

    Future(() async {
      await _setDefaultStationList();
    });
  }

  @override
  Widget build(BuildContext context) {
    if(_isSharedPrefGet == false){
      return Scaffold(
        appBar: AppBar(
          title: const Text('路線選択時の初期表示駅の変更', style: TextStyle(color: Colors.black),),
        ),
        body: const Center(
          child: CircularProgressIndicator(),
        ),
      );
    }
    return Scaffold(
      appBar: AppBar(
        title: const Text('路線選択時の初期表示駅の変更', style: TextStyle(color: Colors.black),),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            children: [
              for(var i in _lineList)...{
                const Divider(),
                Row(
                  children: [
                    const SizedBox(width: 30,),
                    DecoratedBox(
                      decoration: BoxDecoration(
                        boxShadow: [
                          BoxShadow(
                            color: Colors.grey.shade300,
                            offset: const Offset(2, 2),
                            spreadRadius: 1.2,
                            blurRadius: 1,
                          ),
                        ],
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Material(
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                        color: Colors.white,
                        child: TextButton(
                          onPressed: () async {
                            await Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => DefaultShowStationSelectScreen(lineName: i,),
                              ),
                            );
                            await _setDefaultStationList();
                          },
                          child: Text('   $i   '),
                        ),
                      ),
                    ),
                    const Spacer(),
                    Text(_defaultStationList[_lineList.indexOf(i)]),
                    const SizedBox(width: 50,),
                  ],
                ),
              },
              const Divider(),
            ],
          ),
        ),
      ),
    );
  }
}
