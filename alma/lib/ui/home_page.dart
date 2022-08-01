import 'package:flutter/material.dart';

import '../models/user.dart';
import '../services/server_api.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  late ServerApi serverApi;
  User? user;
  late Future _dataFuture;

  @override
  void initState() {
    serverApi = ServerApi.getInstance();
    serverApi.onLogout = () {
      Navigator.pushReplacementNamed(context, "/");
    };
    _dataFuture = getUserData();

    super.initState();
  }

  Future getUserData() async{
    while(true){
      var result = await serverApi.getUserData();
      if(result.error){
        if(result.errorCode == 401) {
          return;
        }
        Future.delayed(Duration(seconds: 1));
        continue;
      }
      setState(() {
        user = result.data!;
      });
      return;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text('DashBoard'),
        ),
        drawer: Drawer(
          child: ListView(
            children: <Widget>[
              DrawerHeader(
                decoration: BoxDecoration(
                  color: Theme
                      .of(context)
                      .primaryColor,
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
                leading: Image.asset("lib/assets/images/cow-1.png", height: 24, color: Colors.grey[600]),
                title: Text('Vacas'),
                onTap: () => Navigator.popAndPushNamed(context, "/cows"),
              ),
              ListTile(
                leading: Icon(Icons.settings),
                title: Text('Configurações'),
                onTap: () => Navigator.popAndPushNamed(context, "/config"),
              ),
              ListTile(
                leading: Icon(Icons.logout),
                title: Text('Sair'),
                onTap: serverApi.logout,
              ),
            ],
          ),
        ),
        body: FutureBuilder(
            future: _dataFuture,
            builder: (BuildContext c, AsyncSnapshot s) {
              if (s.connectionState == ConnectionState.waiting) {
                return Center(child: SizedBox(
                    height: 50,
                    width: 50,
                    child:CircularProgressIndicator()));
              }
              if (s.hasData) {
                return Text(s.data);
              }
              return bodyApp();
            }
        )
    );
  }

  Widget bodyApp() {
    return Row(
          children: [
            Text("hi")
          ]
      );
  }

  Widget buildMenuItem({
    required String text,
    required IconData icon,
    VoidCallback? onClicked,
  }) {
    final color = Colors.white;
    final hoverColor = Colors.white70;

    return ListTile(
      leading: Icon(icon, color: color),
      title: Text(text, style: TextStyle(color: color)),
      hoverColor: hoverColor,
      onTap: onClicked,
    );
  }

}
