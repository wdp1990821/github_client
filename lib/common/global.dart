import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:github_client/models/index.dart';
import 'package:shared_preferences/shared_preferences.dart';

const _themes = <MaterialColor>[
  Colors.blue,
  Colors.cyan,
  Colors.teal,
  Colors.green,
  Colors.red,
];

class Global {
  static late SharedPreferencesAsync _prefs;
  static Profile profile = Profile();
  // TODO 网络缓存对象
  // static NetCache netCache = NetChache();

  // 可选的主题列表
  static List<MaterialColor> get themes => _themes;

  // 初始化全局信息，会在App启动时执行
  static Future init() async {
    WidgetsFlutterBinding.ensureInitialized();
    _prefs = SharedPreferencesAsync();
    var _profile = _prefs.getString('profile');
    if (_profile != null) {
      try {
        profile = Profile.fromJson(jsonDecode(_profile as String));
      } catch (e) {
        print(e);
      }
    } else {
      // 默认主题索引为0，代表蓝色
      profile = Profile()..theme = 0;
    }

    // 如果没有缓存策略，设置默认缓存策略
    profile.cache = profile.cache ?? CacheConfig()
      ..enable = true
      ..maxAge = 3600
      ..maxCount = 100;

    // TODO 初始化网络请求相关配置
    // Git.init();
  }

  // 持久化Profile信息
  static saveProfile() =>
      _prefs.setString('profile', jsonEncode(profile.toJson()));
}
