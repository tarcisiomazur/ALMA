import 'package:alma/models/user.dart';
import 'package:alma/ui/my_drawer.dart';
import 'package:flutter/material.dart';

class DashBoard extends StatefulWidget {
  DashBoard({Key? key}) : super(key: key);

  @override
  String pageName = "DashBoard";

  @override
  State<DashBoard> createState() => _DashboardState();

}

class _DashboardState extends State<DashBoard> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text('Dashboard'),
        ),
        drawer: MyDrawer(),
        body: Container(
          child: Text("Dashboard"))
    );
  }
}
