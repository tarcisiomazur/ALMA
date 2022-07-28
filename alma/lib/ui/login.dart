import 'package:alma/services/preferences.dart';
import 'package:alma/services/server_api.dart';
import 'package:alma/utils/validation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_login/flutter_login.dart';
class LoginPage extends StatelessWidget {
  LoginPage({Key? key}) : super(key: key);
  String email = Preferences.getInstance().getString("email") ?? "";

  Future<String?> _authUser(LoginData data) async {
    debugPrint('Name: ${data.name}, Password: ${data.password}');
    try {
      Preferences.getInstance().setString("email", data.name);
      return await ServerApi.getInstance().authUser(data.name, data.password);
    }catch(ex){
      return "Erro ao se comunicar com o servidor";
    }
  }

  Future<String?> _signupUser(SignupData data) async {
    debugPrint('Signup Name: ${data.name}, Password: ${data.password}');
    try {
      Preferences.getInstance().setString("email", data.name!);
      return await ServerApi.getInstance().registerUser(data.name!, data.password!, data.additionalSignupData!['DeviceId']!);
    }catch(ex){
      return "Erro ao se comunicar com o servidor";
    }
  }

  Future<String?> _recoverPassword(String email) async{
    debugPrint('Email: $email');
    try {
      return await ServerApi.getInstance().recoverPassword(email);
    }catch(ex){
      return "Erro ao se comunicar com o servidor";
    }
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
      savedEmail: email,
      additionalSignupFields: const [
        UserFormField(
          keyName: "DeviceId",
          displayName: "Código do Dispositivo",
          fieldValidator: Validation.isValidDeviceId,
          icon: Icon(Icons.devices),
        )
      ],
      onSubmitAnimationCompleted: () {
        Navigator.pushReplacementNamed(context, "/home");
      },
      onRecoverPassword: _recoverPassword,
      messages: LoginMessages(
        passwordHint: 'Senha',
        confirmPasswordHint: 'Confirmar',
        loginButton: 'Entrar',
        signupButton: 'Registrar',
        recoverPasswordButton: 'Recuperar',
        recoverPasswordIntro: 'Recuperare a sua senha',
        forgotPasswordButton: 'Esqueci minha senha',
        confirmPasswordError: 'As senhas não coincidem!',
        recoverPasswordDescription:'Será enviada uma senha temporária para o seu endereço de email',
        recoverPasswordSuccess: 'Senha enviada com sucesso',
        additionalSignUpFormDescription: "Preencha as informações adicionais:",
        additionalSignUpSubmitButton: "Confirmar",
        goBackButton: "Voltar",
        flushbarTitleError: "Erro",
        flushbarTitleSuccess: "Sucesso",
        signUpSuccess: "Registrado com sucesso",
      ),
    );
  }
}

