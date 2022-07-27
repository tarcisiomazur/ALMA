import 'package:alma/services/server_api.dart';
import 'package:alma/utils/validation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_login/flutter_login.dart';
class LoginPage extends StatelessWidget {
  const LoginPage({Key? key}) : super(key: key);

  Future<String?> _authUser(LoginData data) async {
    debugPrint('Name: ${data.name}, Password: ${data.password}');
    try {
      return await ServerApi.authUser(data.name, data.password);
    }catch(ex){
      return "Erro ao se comunicar com o servidor";
    }
  }

  Future<String?> _signupUser(SignupData data) async {
    debugPrint('Signup Name: ${data.name}, Password: ${data.password}');
    try {
      return ServerApi.registerUser(data.name!, data.password!, data.additionalSignupData!['DeviceId']!);
    }catch(ex){
      return "Erro ao se comunicar com o servidor";
    }
  }

  Future<String> _recoverPassword(String name) {
    debugPrint('Name: $name');
    return Future.delayed(Duration(seconds: 1)).then((_) {
      return "hi";
    });
  }

  @override
  Widget build(BuildContext context) {
    return FlutterLogin(
      title: 'ALMA',
      userType: LoginUserType.email,
      onLogin: _authUser,
      userValidator: Validation.isValidMail,
      passwordValidator: Validation.isValidPassword,
      onSignup: _signupUser,
      additionalSignupFields: const [
        UserFormField(
          keyName: "DeviceId",
          displayName: "Código do Dispositivo",
          fieldValidator: Validation.isValidDeviceId,
          icon: Icon(Icons.devices),
        )
      ],
      onSubmitAnimationCompleted: () {
        Navigator.pushNamed(context, "/home");
      },
      onRecoverPassword: _recoverPassword,
      messages: LoginMessages(
        passwordHint: 'Senha',
        confirmPasswordHint: 'Confirmar',
        loginButton: 'Entrar',
        signupButton: 'Registrar',
        forgotPasswordButton: 'Esqueci minha senha',
        confirmPasswordError: 'As senhas não coincidem!',
        recoverPasswordDescription:'',
        recoverPasswordSuccess: 'Senha recuperada',
        additionalSignUpFormDescription: "Preencha as informações adicionais:",
        additionalSignUpSubmitButton: "Confirmar",
        goBackButton: "Voltar",
        flushbarTitleError: "Erro",
        flushbarTitleSuccess: "Sucesso",
        signUpSuccess: "Registrado com sucesso",
      ),
      theme: LoginTheme(
        primaryColor: Colors.deepPurple,
      ),
    );
  }
}

