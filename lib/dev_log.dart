import 'package:flutter/foundation.dart';

class DevLog {
  void info(String msg){
    if(kDebugMode){
      DateTime now = DateTime.now();
      msg = '[info] $now $msg';
      debugPrint(msg);
    }
  }

  void warn(String msg){
    if(kDebugMode){
      DateTime now = DateTime.now();
      msg = '\x1B[33m[warn] $now $msg\x1B[0m';
      debugPrint(msg);
    }
  }

  void error(String msg){
    if(kDebugMode){
      DateTime now = DateTime.now();
      msg = '\x1B[31m[warn] $now $msg\x1B[0m';
      debugPrint(msg);
    }
  }
}
