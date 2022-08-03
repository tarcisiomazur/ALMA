import 'package:alma/models/user.dart';
import 'package:alma/services/server_api.dart';
import 'package:alma/services/web_socket.dart';
import 'package:alma/ui/pages/cows_page.dart';
import 'package:alma/ui/pages/dashboard_page.dart';
import 'package:alma/ui/pages/my_page.dart';
import 'package:flutter/material.dart';

import 'package:flutter_login/src/widgets/animated_text_form_field.dart';


class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  late ServerApi serverApi;
  User? user;
  late Future _dataFuture;
  late MyPage page;

  @override
  void initState() {
    page = MyPage(widget:DashBoard(), pageName: 'DashBoard');
    serverApi = ServerApi.getInstance();
    serverApi.onLogout = () {
      Navigator.pushReplacementNamed(context, "/");
    };
    _dataFuture = getUserData();

    super.initState();
  }

  Future getUserData() async {
    while (true) {
      var result = await serverApi.getUserData();
      if (result.error) {
        if (result.errorCode == 401) {
          return;
        }
        Future.delayed(Duration(seconds: 1));
        continue;
      }
      setState(() {
        user = result.data!;
      });

      if (user?.changePassword == true) {
        showPasswordDialog(context);
      }

      return;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(page.pageName),
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
              leading: Icon(Icons.dashboard_rounded),
              title: Text('Dashboard'),
              onTap: () {
                setState(() =>
                page = MyPage(widget: CowsPage(), pageName: 'Dashboard'));
                Navigator.pop(context);
              },
            ),
            ListTile(
              leading: Image.asset("lib/assets/images/cow.png", height: 24,
                  color: Colors.grey[600]),
              title: Text('Vacas'),
              onTap: () {
                setState(()
                {
                  page = MyPage(widget: CowsPage(), pageName: 'Vacas');
                });
                Navigator.pop(context);
              },
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
            return Center(
              child: SizedBox(
                height: 50,
                width: 50,
                child: CircularProgressIndicator(),
              ),
            );
          }
          if (s.hasData) {
            return Text(s.data);
          }
          return page.widget;
        },
      ),
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

  void showPasswordDialog(BuildContext context) {
    TextEditingController _passwordController = new TextEditingController();
    showDialog(
      barrierDismissible: false,
      context: context,
      builder: (BuildContext context) {
        return WillPopScope(
          onWillPop: () => Future.value(false),
          child: AlertDialog(
            content: Container(
              width: MediaQuery
                  .of(context)
                  .size
                  .width / 1.3,
              height: MediaQuery
                  .of(context)
                  .size
                  .height / 4,
              decoration: BoxDecoration(
                shape: BoxShape.rectangle,
                color: const Color(0xFFFFFF),
                borderRadius: new BorderRadius.all(new Radius.circular(32.0)),
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  const Text("Acesso com a senha temporária. Informe a nova senha:"),
                  AnimatedPasswordTextFormField(
                      animatedWidth: 200,
                      labelText: "Nova senha",
                      textInputAction: TextInputAction.done,
                      onFieldSubmitted: (value) {
                        serverApi.changePassword(user?.email,null,value).then((value){
                          if(!value.error){
                            Navigator.of(context).pop();
                          }
                        });
                      },
                      validator: (value) => null
                  ),
                  MaterialButton(
                    onPressed: () async {
                      Navigator.of(context).pop();
                    },
                    child: Container(
                      width: MediaQuery
                          .of(context)
                          .size
                          .width,
                      height: MediaQuery
                          .of(context)
                          .size
                          .height / 15,
                      padding: EdgeInsets.all(2.0),
                      child: Material(
                          color: Theme
                              .of(context)
                              .primaryColor,
                          borderRadius: BorderRadius.circular(25.0),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: <Widget>[
                              Text(
                                'Confirmar',
                                style: TextStyle(
                                  color: Colors.white,
                                ),
                                textAlign: TextAlign.center,
                              ),
                            ],
                          )
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}
