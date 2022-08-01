import 'package:alma/ui/config_page.dart';
import 'package:alma/ui/cows_page.dart';
import 'package:alma/ui/home_page.dart';
import 'package:alma/ui/login.dart';
import 'package:alma/ui/welcome.dart';
import 'package:flutter/material.dart';

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
      case '/cows':
        return MaterialPageRoute(builder: (_) => CowsPage());
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