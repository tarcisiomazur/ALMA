import 'package:alma/models/user.dart';
import 'package:alma/services/server_api.dart';
import 'package:alma/ui/pages/config_page.dart';
import 'package:alma/ui/pages/cows_page.dart';
import 'package:alma/ui/pages/home_page.dart';
import 'package:flutter/material.dart';

class MyDrawer extends StatelessWidget {
  const MyDrawer({Key? key}) : super(key: key);
  static User? user;

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: ListView(
        children: <Widget>[
          DrawerHeader(
            decoration: BoxDecoration(
              color: Theme.of(context).primaryColor,
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  user?.farm?.propertyName ?? "",
                  style: TextStyle(fontSize: 20, color: Colors.white),
                ),
                const SizedBox(height: 4),
                Text(
                  user?.email ?? "",
                  style: TextStyle(fontSize: 14, color: Colors.white),
                ),
              ],
            ),
          ),
          ListTile(
            leading: Icon(Icons.dashboard_rounded),
            title: Text('Dashboard'),
            onTap: () {
              Navigator.pushReplacementNamed(context, HomePage.route);
            },
          ),
          ListTile(
            leading: Image.asset("lib/assets/images/cow.png",
                height: 24, color: Colors.grey[600]),
            title: Text('Rebanho'),
            onTap: () {
              Navigator.pushReplacementNamed(context, CowsPage.route);
            },
          ),
          ListTile(
            leading: Icon(Icons.settings),
            title: Text('Configurações'),
            onTap: () => Navigator.popAndPushNamed(context, ConfigPage.route),
          ),
          ListTile(
            leading: Icon(Icons.logout),
            title: Text('Sair'),
            onTap: ServerApi.getInstance().logout,
          ),
        ],
      ),
    );
  }
}
