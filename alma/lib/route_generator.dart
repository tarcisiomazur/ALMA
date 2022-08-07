import 'package:alma/models/cow.dart';
import 'package:alma/ui/pages/settings_page.dart';
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
        return MaterialPageRoute(builder: (_) => Welcome(), settings: settings);
      case LoginPage.route:
        return MaterialPageRoute(builder: (_) => LoginPage(), settings: settings);
      case HomePage.route:
        return MaterialPageRoute(builder: (_) => HomePage(), settings: settings);
      case SettingsPage.route:
        return MaterialPageRoute(builder: (_) => SettingsPage(), settings: settings);
      case CowsPage.route:
        return MaterialPageRoute(builder: (_) => CowsPage(), settings: settings);
      case EditCowPage.route:
        return MaterialPageRoute(builder: (_) => EditCowPage(cow: args as Cow), settings: settings);
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