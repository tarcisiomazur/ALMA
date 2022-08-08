import 'package:alma/models/user.dart';
import 'package:alma/services/server_api.dart';
import 'package:alma/ui/my_widgets/buttons.dart';
import 'package:alma/ui/my_widgets/dialogs.dart';
import 'package:alma/utils/global_functions.dart';
import 'package:flutter/material.dart';
import 'package:flutter_login/src/widgets/animated_text_form_field.dart';

class SettingsPage extends StatefulWidget {
  const SettingsPage({Key? key}) : super(key: key);

  static const String route = '/settings';

  @override
  State<SettingsPage> createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> with TickerProviderStateMixin{
  late ServerApi _serverApi;
  late String? _propertyName;
  late User? _user;
  late ThemeData td;
  @override
  void initState() {
    _serverApi = ServerApi.getInstance();
    _user = _serverApi.user;
    _propertyName = _user?.farm.propertyName;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    var divider = Divider(
      color: Theme
          .of(context)
          .primaryColor,
      height: 2,
    );
    return Scaffold(
        appBar: AppBar(
          title: Text('Configurações'),
        ),
        body: Card(
          margin: EdgeInsets.symmetric(horizontal: 10, vertical: 5),
          child: ListView(
            children: [
              Column(
                children: [
                  ListTile(
                    title: Text("Alterar Dispositivo"),
                    onTap: changeDevice,
                  ),
                  divider,
                  ListTile(
                    title: Text("Nome da Propriedade"),
                    subtitle: _propertyName != null
                        ? Text(_propertyName!)
                        : null,
                    onTap: changePropertyName,
                  ),
                  divider,
                  ListTile(
                    title: Text("Alterar Senha"),
                    onTap: changePassword,
                  ),
                ],
              )
            ],
          ),
        )
    );
  }

  void changeDevice() {
  }


  void changePassword() {
    final TextEditingController oldPasswordController = TextEditingController();
    final TextEditingController newPasswordController = TextEditingController();
    final animatedController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1000),
    );
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return FormDialog(
          content: Wrap(
            runSpacing: 10,
            alignment: WrapAlignment.center,
            children: <Widget>[
              const Align(
                alignment: Alignment.centerLeft,
                child: Text("Alterar Senha de Usuário:"),
              ),
              AnimatedPasswordTextFormField(
                controller: oldPasswordController,
                animatedWidth: 200,
                labelText: "Senha antiga",
                textInputAction: TextInputAction.done,
              ),
              AnimatedPasswordTextFormField(
                controller: newPasswordController,
                animatedWidth: 200,
                labelText: "Nova Senha",
                textInputAction: TextInputAction.done,
              ),
              WaitingButton(
                text: "Confirmar",
                onPressed: () async {
                  await animatedController.forward();
                  var result = await _serverApi.changePassword(
                      _user?.email, oldPasswordController.text,
                      newPasswordController.text);
                  if (!mounted) return;
                  await animatedController.reverse();
                  if (result.data == true) {
                    showSuccessDialog(
                        this.context, "Senha Atualizada!");
                  } else {
                    showErrorDialog(this.context,
                        "Não foi possível atualizar a senha");
                  }
                  Navigator.of(this.context).popUntil(ModalRoute
                      .withName(SettingsPage.route));
                },
                controller: animatedController,
              ),
            ],
          )
        );
      },
    );
  }

  void changePropertyName(){

  }
}
