import 'package:alma/main.dart';
import 'package:alma/models/user.dart';
import 'package:alma/services/server_api.dart';
import 'package:alma/ui/my_drawer.dart';
import 'package:alma/ui/pages/dashboard_page.dart';
import 'package:alma/utils/validation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_login/src/widgets/animated_text_form_field.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  static const String route = '/home';

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  late ServerApi serverApi;
  User? user;
  late Future _dataFuture;
  late Widget page;

  @override
  void initState() {
    serverApi = ServerApi.getInstance();
    serverApi.onLogout = () {
      Navigator.pushNamedAndRemoveUntil(MyApp.context, "/login", (route) => false);
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
      MyDrawer.user = user;
      page = DashBoard();

      return;
    }
  }

  @override
  Widget build(BuildContext context) {
    Widget wait = Scaffold(
        appBar: AppBar(
          title: Text("Alma - Sistemas de Controle"),
        ),
        body: Center(
          child: SizedBox(
            height: 50,
            width: 50,
            child: CircularProgressIndicator(),
          ),
        )
    );
    return FutureBuilder(
      future: _dataFuture,
      builder: (BuildContext c, AsyncSnapshot s) {
        if (s.connectionState == ConnectionState.waiting) {
          return wait;
        }
        if (s.hasData) {
          return Text(s.data);
        }
        if (user == null) {
          _dataFuture = getUserData();
          return wait;
        }
        return page;
      },
    );
  }

  void showPasswordDialog(BuildContext context) {
    final TextEditingController _passwordController = TextEditingController();
    showDialog(
      barrierDismissible: false,
      context: context,
      builder: (BuildContext context) {
        return WillPopScope(
          onWillPop: () => Future.value(false),
          child: AlertDialog(
            content: Container(
              width: MediaQuery.of(context).size.width / 1.3,
              height: MediaQuery.of(context).size.height / 4,
              decoration: BoxDecoration(
                shape: BoxShape.rectangle,
                color: const Color(0xFFFFFF),
                borderRadius: new BorderRadius.all(new Radius.circular(32.0)),
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  const Text(
                      "Acesso com a senha temporária. Informe a nova senha:"),
                  AnimatedPasswordTextFormField(
                    controller: _passwordController,
                    animatedWidth: 200,
                    labelText: "Nova senha",
                    textInputAction: TextInputAction.done,
                    onFieldSubmitted: (value) {
                      serverApi.changePassword(user?.email, null, value);
                      Navigator.of(context).pop();
                    },
                    validator: Validation.isValidPassword,
                  ),
                  MaterialButton(
                    onPressed: () {
                      serverApi.changePassword(user?.email, null, _passwordController.text);
                      Navigator.of(context).pop();
                    },
                    child: Container(
                      width: MediaQuery.of(context).size.width,
                      height: MediaQuery.of(context).size.height / 15,
                      padding: EdgeInsets.all(2.0),
                      child: Material(
                          color: Theme.of(context).primaryColor,
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
                          )),
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
