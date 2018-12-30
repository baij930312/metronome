import 'dart:io';
import 'package:metronome/agent/api_model.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:device_info/device_info.dart';
import 'package:rxdart/rxdart.dart';

class Utils {
  //应用名称
  static String appName = '节拍器';
  static String cacheKey = 'LOCAL_CACHE';

  // 返回当前时间戳
  static int currentTimeMillis() {
    return new DateTime.now().millisecondsSinceEpoch;
  }

  // 返回当前时间字符串 年月日 YYYY年MM月DD日
  static String dateformatWithYYYYMMDD(int timeStamp) {
    DateTime date = DateTime.fromMillisecondsSinceEpoch(timeStamp);
    return '${date.year}年${date.month}月${date.day}日';
  }

  // 返回当前时间字符串 时分秒 hh:mm:ss
  static String dateformatWithHHMMSS(int timeStamp) {
    DateTime date = DateTime.fromMillisecondsSinceEpoch(timeStamp);
    return '${date.hour}:${date.minute}:${date.second}';
  }

  // 复制到剪粘板
  static copyToClipboard(final String text) {
    if (text == null) return;
    Clipboard.setData(new ClipboardData(text: text));
  }

  static const RollupSize_Units = ["GB", "MB", "KB", "B"];
  // 返回文件大小字符串
  static String getRollupSize(int size) {
    int idx = 3;
    int r1 = 0;
    String result = "";
    while (idx >= 0) {
      int s1 = size % 1024;
      size = size >> 10;
      if (size == 0 || idx == 0) {
        r1 = (r1 * 100) ~/ 1024;
        if (r1 > 0) {
          if (r1 >= 10)
            result = "$s1.$r1${RollupSize_Units[idx]}";
          else
            result = "$s1.0$r1${RollupSize_Units[idx]}";
        } else
          result = s1.toString() + RollupSize_Units[idx];
        break;
      }
      r1 = s1;
      idx--;
    }
    return result;
  }

// 返回两个日期相差的天数
  static int daysBetween(DateTime a, DateTime b, [bool ignoreTime = false]) {
    if (ignoreTime) {
      int v = a.millisecondsSinceEpoch ~/ 86400000 -
          b.millisecondsSinceEpoch ~/ 86400000;
      if (v < 0) return -v;
      return v;
    } else {
      int v = a.millisecondsSinceEpoch - b.millisecondsSinceEpoch;
      if (v < 0) v = -v;
      return v ~/ 86400000;
    }
  }

  // 获取屏幕宽度
  static double getScreenWidth(BuildContext context) {
    return MediaQuery.of(context).size.width;
  }

  // 获取屏幕高度
  static double getScreenHeight(BuildContext context) {
    return MediaQuery.of(context).size.height;
  }

  // 获取系统状态栏高度
  static double getSysStatsHeight(BuildContext context) {
    return MediaQuery.of(context).padding.top;
  }

  // 页面跳转
  static void pushScreen(BuildContext context, Widget screen) {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (BuildContext context) {
          return screen;
        },
      ),
    );
  }

  static void replaceScreen(BuildContext context, Widget screen) {
    Navigator.of(context).pushReplacement(
      MaterialPageRoute(
        builder: (BuildContext context) {
          return screen;
        },
      ),
    );
  }

  static Future<String> getDeviceUUID() async {
    DeviceInfoPlugin deviceInfo = new DeviceInfoPlugin();

    if (Platform.isIOS) {
      IosDeviceInfo iosInfo = await deviceInfo.iosInfo;
      return iosInfo.identifierForVendor;
    } else if (Platform.isAndroid) {
      AndroidDeviceInfo androidInfo = await deviceInfo.androidInfo;
      return androidInfo.fingerprint;
    }
    return null;
  }

  static showSnackBar(BuildContext context,
      {@required String text, int duration}) {
    final snackBar = SnackBar(
      content: new Text(text ?? 'hahaha'),
      duration: Duration(seconds: duration ?? 1),
    );
    Scaffold.of(context).showSnackBar(snackBar);
  }

  static Observable<Function> createRequireReducer(
      Observable<Future> s, Function f) {
    return s
        .switchMap((Future f) => Observable<ApiModel>.fromFuture(f))
        .where((ApiModel model) => model.error == 0)
        .map(f);
  }
}
