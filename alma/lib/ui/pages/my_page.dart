import 'package:flutter/material.dart';

class MyPage<T extends Widget> {
  MyPage({required T this.widget, required this.pageName});

  T widget;
  String pageName;
}