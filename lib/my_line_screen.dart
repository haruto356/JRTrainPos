import 'package:flutter/material.dart';

class MyLineScreen extends StatefulWidget {
  const MyLineScreen({super.key});

  @override
  State<MyLineScreen> createState() => _MyLineScreenState();
}

class _MyLineScreenState extends State<MyLineScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(body: Center(child: Text('MY路線')));
  }
}
