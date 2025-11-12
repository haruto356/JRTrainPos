import 'package:flutter/material.dart';
import 'dart:io';

import 'package:http/http.dart' as http;
import 'package:path_provider/path_provider.dart';

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

  final List<String> supportedLineList = [
    'hokuriku',
    'hokurikubiwako',
    'kyoto',
    'kobesanyo',
  ];

  @override
  void initState() {
    super.initState();

    // json取得
    Future(() async {
      // 駅json
      for(var i in supportedLineList) {
        final jsonUrl = Uri.parse('https://www.train-guide.westjr.co.jp/api/v3/${i}_st.json');
        final response = await http.get(jsonUrl);

        // 取得に成功したらファイルとして保存する
        if(response.statusCode == 200){
          final saveDirTemp = await getTemporaryDirectory();
          final filePath = '${saveDirTemp.path}/$i.json';

          final file = File(filePath);
          await file.writeAsString(response.body);
        }
        else{
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('駅データの取得に失敗しました($i)'), duration: Duration(seconds: 1),)
          );
        }

        // 負荷軽減のためやや遅らせる
        await Future.delayed(Duration(milliseconds: 200));
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
