import 'package:flutter/material.dart';
import 'package:jr_train_pos/line_manager.dart';

class LineListScreen extends StatefulWidget {
  const LineListScreen({super.key});

  @override
  State<LineListScreen> createState() => _LineListScreenState();
}

class _LineListScreenState extends State<LineListScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Center(
          child: Column(children: LineManager().getAllLineWidgetList()),
        ),
      ),
    );
  }
}
