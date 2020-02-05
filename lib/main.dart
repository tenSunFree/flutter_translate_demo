import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_translate/localization_delegate.dart';
import 'package:flutter_translate/localization_provider.dart';
import 'package:flutter_translate/localized_app.dart';
import 'package:flutter_translate/flutter_translate.dart';
import 'package:flutter_translate_demo/screens/home_page.dart';
import 'dart:io';

void main() async {
  var delegate = await LocalizationDelegate.create(
      fallbackLocale: 'zh_TW',
      supportedLocales: ['zh_TW', 'zh_CN', 'en_US', 'ja_JP', 'ko_KR']);
  runApp(LocalizedApp(delegate, MyApp()));
  initializeStatusBar();
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    var localizationDelegate = LocalizedApp.of(context).delegate;

    return LocalizationProvider(
      state: LocalizationProvider.of(context).state,
      child: MaterialApp(
        title: 'flutter_translate_demo',
        localizationsDelegates: [
          GlobalMaterialLocalizations.delegate,
          GlobalWidgetsLocalizations.delegate,
          localizationDelegate
        ],
        supportedLocales: localizationDelegate.supportedLocales,
        locale: localizationDelegate.currentLocale,
        theme: ThemeData(
          primarySwatch: Colors.blue,
        ),
        // home: MyHomePage(title: "jjj"),
        home: HomePage(),
      ),
    );
  }
}

/// 設置android狀態欄為透明的沉浸, 以及文字顏色變成黑色
/// 寫在組件渲染之後, 是為了在渲染後進行set賦值, 覆蓋狀態欄
/// 寫在渲染之前, MaterialApp組件會覆蓋掉這個值
void initializeStatusBar() {
  if (Platform.isAndroid) {
    SystemChrome.setSystemUIOverlayStyle(
      SystemUiOverlayStyle.dark.copyWith(
          statusBarColor: Colors.transparent, // Color for Android
          statusBarBrightness:
              Brightness.dark // Dark == white status bar -- for IOS.
          ),
    );
  }
}
