import 'package:flutter/material.dart';

import 'package:jr_train_pos/get_json_file.dart';
import 'my_line_screen.dart';
import 'line_list_screen.dart';
import 'setting_screen.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.blueGrey),
        fontFamily: 'NotoSansJP',
      ),
      home: const MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key});

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {

  final _screens = [
    MyLineScreen(),
    LineListScreen(),
    SettingScreen()
  ];

  int _selectedScreenIndex = 0;

  void _onTapBottomBar(int index){
    setState(() {
      _selectedScreenIndex = index;
    });
  }

  // 駅リストを取得する路線一覧
  final List<String> supportedLineList = [
    'hokuriku',
    'hokurikubiwako',
    'kyoto',
    'kobesanyo',
    'kosei',
    'kusatsu',
    'nara',
    'sagano',
    'sanin1',
    'osakahigashi',
    'takarazuka',
    'fukuchiyama',
    'tozai',
    'gakkentoshi',
    'osakaloop',
  ];

  @override
  void initState() {
    super.initState();

    final getJsonFile = GetJsonFile();

    // json取得
    Future(() async {
      // 駅json
      for(var i in supportedLineList) {
        try{
          await getJsonFile.getStationList(i);
        } catch(e) {
          ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text('駅データの取得に失敗しました($i)'), duration: Duration(seconds: 1),),
          );
        }
        // 負荷軽減のためやや遅らせる
        await Future.delayed(Duration(milliseconds: 200));
      }

      // 列車情報を取得
      try {
        await getJsonFile.getTrainInfo();
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('列車情報の取得に失敗しました'), duration: Duration(seconds: 1),),
        );
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: _screens[_selectedScreenIndex],
      ),

      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _selectedScreenIndex,
        onTap: _onTapBottomBar,
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.train), label: 'MY路線'),
          BottomNavigationBarItem(icon: Icon(Icons.list), label: '路線一覧'),
          BottomNavigationBarItem(icon: Icon(Icons.settings), label: '設定'),
        ],
        type: BottomNavigationBarType.fixed,
      ),
    );
  }
}
