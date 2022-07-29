import 'package:flutter/material.dart';

import 'ui/config_page.dart';
import 'ui/home_page.dart';
import 'ui/login.dart';
import 'ui/welcome.dart';

class RouteGenerator{
  static Route<dynamic> generateRoute(RouteSettings settings){
    final args = settings.arguments;

    switch(settings.name){
      case '/':
      case '/welcome':
        return MaterialPageRoute(builder: (_) => Welcome());
      case '/login':
        return MaterialPageRoute(builder: (_) => LoginPage());
      case '/home':
        return MaterialPageRoute(builder: (_) => HomePage());
      case '/config':
        return MaterialPageRoute(builder: (_) => ConfigPage());
      default:
        return _errorRoute();
    }
  }

  static Route<dynamic> _errorRoute(){
    return MaterialPageRoute(builder: (_) {
      return Scaffold(
        appBar: AppBar(
          title: const Text("Erro"),
        ),
        body: const Center(child: Text("Página não encontrada!")),
      );
    });
  }
}