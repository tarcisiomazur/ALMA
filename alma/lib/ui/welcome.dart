import 'package:alma/services/server_api.dart';
import 'package:alma/ui/pages/home_page.dart';
import 'package:alma/ui/pages/login_page.dart';
import 'package:flutter/material.dart';

class Welcome extends StatefulWidget {
  const Welcome({Key? key}) : super(key: key);

  @override
  State<Welcome> createState() => _WelcomeState();
}

class _WelcomeState extends State<Welcome> {

  @override
  void initState() {
    ServerApi.getInstance().getLoggedUser().then((ok) =>
      Navigator.pushReplacementNamed(context, ok ? HomePage.route : LoginPage.route)
    );
    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    return Container();
  }

}
