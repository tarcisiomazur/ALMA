import 'package:alma/main.dart';
import 'package:alma/models/user.dart';
import 'package:alma/services/server_api.dart';
import 'package:alma/ui/my_drawer.dart';
import 'package:alma/ui/my_widgets/buttons.dart';
import 'package:alma/ui/my_widgets/dialogs.dart';
import 'package:alma/ui/pages/dashboard_page.dart';
import 'package:alma/utils/global_functions.dart';
import 'package:alma/utils/validation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_login/src/widgets/animated_text_form_field.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  static const String route = '/home';

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> with TickerProviderStateMixin{
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
    final TextEditingController passwordController = TextEditingController();
    final animatedController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1000),
    );
    final formKey = GlobalKey<FormState>();

    submit([_]) async {
      if (formKey.currentState == null || !formKey.currentState!.validate()) {
        return;
      }
      await animatedController.forward();
      var result = await serverApi.changePassword(user?.email, null, passwordController.text);
      await animatedController.reverse();
      if (result.data == true) {
        showSuccessDialog(
            this.context, "Senha Atualizada!");
      } else {
        showErrorDialog(this.context,
            "Não foi possível atualizar a senha");
      }
      if (!mounted) return;
      Navigator.of(context).pop();
    }

    showDialog(
      barrierDismissible: false,
      context: context,
      builder: (BuildContext context) {
        return WillPopScope(
          onWillPop: () => Future.value(false),
          child: FormDialog(
            formKey: formKey,
            content: Wrap(
              runSpacing: 10,
              alignment: WrapAlignment.center,
              children: <Widget>[
                const Text(
                    "Acesso com a senha temporária. Informe a nova senha:"),
                AnimatedPasswordTextFormField(
                  controller: passwordController,
                  animatedWidth: 200,
                  labelText: "Nova senha",
                  textInputAction: TextInputAction.done,
                  onFieldSubmitted: submit,
                  validator: Validation.isValidPassword,
                ),
                WaitingButton(
                  text: "Confirmar",
                  onPressed: submit,
                  controller: animatedController,
                ),
              ],
            ),
          ),
        );
      },
    );
  }

}
