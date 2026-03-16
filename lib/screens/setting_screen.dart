import 'package:flutter/material.dart';

import 'package:jr_train_pos/screens/setting_screens/default_show_station_setting_screen.dart';
import 'package:jr_train_pos/widgets/color_button.dart';
import 'package:package_info_plus/package_info_plus.dart';

class SettingScreen extends StatefulWidget {
  const SettingScreen({super.key});

  @override
  State<SettingScreen> createState() => _SettingScreenState();
}

class _SettingScreenState extends State<SettingScreen> {
  String appVersion = '';

  @override
  void initState() {
    super.initState();

    Future(() async {
      PackageInfo packageInfo = await PackageInfo.fromPlatform();

      appVersion = packageInfo.version;

      setState(() {});
    });
  }

  @override
  Widget build(BuildContext context) {
    if(appVersion.isEmpty){
      return const Scaffold(
        body: Center(
          child: CircularProgressIndicator(),
        ),
      );
    }

    return Scaffold(
      body: Column(
        children: [
          const SizedBox(height: 20,),
          const Text('設定', style: TextStyle(fontSize: 20),),
          const SizedBox(height: 10,),
          const Divider(),
          ColorButton(
            color: Colors.white,
            onPressed: (){
              Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => const DefaultShowStationSettingScreen()
                ),
              );
            },
            child: const Padding(
              padding: EdgeInsetsGeometry.fromSTEB(20, 5, 20, 5),
              child: Text('初期表示駅の変更'),
            ),
          ),
          const SizedBox(height: 10,),
          ColorButton(
            color: Colors.white,
            onPressed: (){
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => LicensePage(
                    applicationName: '非公式JRW列車位置',
                    applicationVersion: appVersion,
                  ),
                ),
              );
            },
            child: const Padding(
              padding: EdgeInsetsGeometry.fromSTEB(20, 5, 20, 5),
              child: Text('ライセンス'),
            ),
          ),
        ],
      ),
    );
  }
}
