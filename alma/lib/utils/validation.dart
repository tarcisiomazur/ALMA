class Validation{
  static String? isValidMail(String? email){
    String pattern =
        r"^[a-zA-Z0-9.!#$%&'*+/=?^_`{|}~-]+@[a-zA-Z0-9](?:[a-zA-Z0-9-]"
        r"{0,253}[a-zA-Z0-9])?(?:\.[a-zA-Z0-9](?:[a-zA-Z0-9-]"
        r"{0,253}[a-zA-Z0-9])?)*$";
    RegExp regex = RegExp(pattern);
    return (email == null || email.isEmpty || !regex.hasMatch(email)) ? "Insira um e-mail válido": null;
  }

  static String? isValidPassword(String? password){
    String pattern = r"^(.{6,25})$";
    RegExp regex = RegExp(pattern);
    return (password == null || password.isEmpty || !regex.hasMatch(password)) ? "A senha deve conter entre 6 e 25 caracteres": null;
  }

  static String? isValidDeviceId(String? deviceId){
    return (deviceId == null || deviceId.length < 6) ? "DeviceId incorreto": null;
  }
}