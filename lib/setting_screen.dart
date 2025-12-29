import 'package:flutter/material.dart';
import 'package:package_info_plus/package_info_plus.dart';

class SettingScreen extends StatefulWidget {
  const SettingScreen({super.key});

  @override
  State<SettingScreen> createState() => _SettingScreenState();
}

class _SettingScreenState extends State<SettingScreen> {
  String appVersion = "";

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
      return Scaffold(
        body: Center(
          child: CircularProgressIndicator(),
        ),
      );
    }

    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text('設定'),
            TextButton(
              onPressed: () {
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
              child: const Text('ライセンス'),
            )
          ],
        ),
      ),
    );
  }
}
