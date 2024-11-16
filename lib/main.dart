import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:github_client/common/change_notifier_provider.dart';
import 'package:github_client/common/global.dart';
import 'package:github_client/routes/home_page.dart';
import 'package:github_client/routes/login_route.dart';
import 'package:provider/provider.dart';

void main() {
  Global.init();
  runApp(MyApp());
}

// void main() => Global.init().then((e) => runApp(const MyApp()));

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => ThemeModel()),
        ChangeNotifierProvider(create: (_) => UserModel()),
        ChangeNotifierProvider(create: (_) => LocaleModel())
      ],
      child: Consumer2<ThemeModel, LocaleModel>(
        builder: (BuildContext context, themeModel, localModel, child) {
          return MaterialApp(
            theme: ThemeData(
              primarySwatch: themeModel.theme,
            ),
            onGenerateTitle: (context) {
              // todo 没有GmLocalization
              return Localizations.localeOf(context).toString();
            },
            home: HomeRoute(),
            locale: localModel.getLocale(),
            // 我们只支持美国英语和中文简体
            supportedLocales: const [
              Locale('en', 'US'),
              Locale('zh', 'CN'),
            ],
            localizationsDelegates: const [
              GlobalMaterialLocalizations.delegate,
              GlobalWidgetsLocalizations.delegate,
            ],
            localeListResolutionCallback: (locales, supportedLocales) {
              if (localModel.getLocale() != null) {
                // 如果已经选定语言，则不跟随系统
                return localModel.getLocale();
              } else {
                Locale locale;
                if (supportedLocales.contains(locales)) {
                  locale = locales! as Locale;
                } else {
                  locale = const Locale('en', 'US');
                }
                return locale;
              }
            },
            routes: <String, WidgetBuilder>{
              "login": (context) => LoginRoute(),
            
            },
          );
        },
      ),
    );
  }
}
