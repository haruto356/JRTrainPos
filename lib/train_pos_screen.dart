import 'package:flutter/material.dart';
import 'dart:convert';

import 'package:jr_train_pos/get_json_file.dart';

class TrainPosScreen extends StatefulWidget {
  const TrainPosScreen({super.key, required this.lineName, required this.lineColor, required this.lineCodeColor});

  final String lineName;
  final int lineColor;
  final int lineCodeColor;

  @override
  State<TrainPosScreen> createState() => _TrainPosScreenState();
}

class _TrainPosScreenState extends State<TrainPosScreen> {
  List<String> jsonString = [];
  List<String> encodedJson = [];
  List<Text> jsonText = [];

  @override
  void initState() {
    super.initState();

    final getJsonFile = GetJsonFile();

    Future(() async {
      final List<String> lineList = getJsonFile.changeLineNameToJsonFile(widget.lineName);

      for (var i in lineList) {
        try {
          jsonString.add(await getJsonFile.getTrainPos(i));
        } catch(e) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('列車走行位置データの取得に失敗しました(${widget.lineName})'), duration: Duration(seconds: 1),),
          );
        }
      }

      // 整形して表示（デバッグ用）
      final encoder = JsonEncoder.withIndent(' ');
      for(var i in jsonString){
        encodedJson.add(encoder.convert(json.decode(i)));
        jsonText.add(Text(encodedJson.last));
      }

      setState(() {});
    });
  }

  @override
  Widget build(BuildContext context) {
    if(encodedJson.isEmpty){
      return Scaffold(
        appBar: AppBar(
          title: Text(widget.lineName),
          titleTextStyle: TextStyle(color: Color(widget.lineCodeColor), fontSize: 20),
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
        titleTextStyle: TextStyle(color: Color(widget.lineCodeColor), fontSize: 20),
        backgroundColor: Color(widget.lineColor),
        iconTheme: IconThemeData(color: Color(widget.lineCodeColor)),
      ),

      body: SafeArea(
        child: SingleChildScrollView(
          child: Center(
            child: Column(
              children: jsonText,
            ),
          ),
        ),
      ),
    );
  }
}
