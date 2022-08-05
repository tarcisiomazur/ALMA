import 'package:alma/models/cow.dart';
import 'package:alma/ui/pages/config_page.dart';
import 'package:alma/ui/pages/cows_page.dart';
import 'package:alma/ui/pages/edit_cow_page.dart';
import 'package:alma/ui/pages/home_page.dart';
import 'package:alma/ui/pages/login_page.dart';
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
      case '/editCow':
        return MaterialPageRoute(builder: (_) => EditCowPage(cow: args as Cow));
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