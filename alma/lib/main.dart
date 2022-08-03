import 'dart:io';

import 'package:alma/route_generator.dart';
import 'package:alma/services/preferences.dart';
import 'package:alma/services/web_socket.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_localizations/flutter_localizations.dart';

void main() async {
  await dotenv.load(fileName: "dev.env");
  await Preferences.load();
  ApiWebSocket.getInstance().Init();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      localizationsDelegates: GlobalMaterialLocalizations.delegates,
      supportedLocales: const[Locale('pt', 'BR')],
      title: 'ALMA',
      theme: ThemeData(
        primarySwatch: const MaterialColor(
          0xE0673AB7,
          <int, Color>{
            50: Color(0xFFEDE7F6),
            100: Color(0xFFD1C4E9),
            200: Color(0xFFB39DDB),
            300: Color(0xFF9575CD),
            400: Color(0xFF7E57C2),
            500: Color(0xFF673AB7),
            600: Color(0xFF5E35B1),
            700: Color(0xFF512DA8),
            800: Color(0xFF4527A0),
            900: Color(0xFF311B92),
          },
        ),
      ),
      initialRoute: "/",
      onGenerateRoute: RouteGenerator.generateRoute,
    );
  }
}
