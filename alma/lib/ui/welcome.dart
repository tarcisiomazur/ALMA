import 'package:alma/services/server_api.dart';
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
      Navigator.pushReplacementNamed(context, ok ? "/home" : "/login")
    );
    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    return Container();
  }

}
