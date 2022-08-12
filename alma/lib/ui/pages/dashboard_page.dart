import 'package:alma/ui/my_drawer.dart';
import 'package:alma/ui/my_widgets/farm_production_chart.dart';
import 'package:flutter/material.dart';

class DashBoard extends StatefulWidget {
  DashBoard({Key? key}) : super(key: key);

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
      body: SingleChildScrollView(
        padding: EdgeInsets.all(15),
        child: Row(

          children: [
            Column(
              children: [
                Container(
                  child: FarmProductionChart(),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
