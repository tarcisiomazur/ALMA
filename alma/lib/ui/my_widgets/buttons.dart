import 'package:flutter_login/flutter_login.dart';
import 'package:flutter_login/src/widgets/animated_text_form_field.dart';
import 'package:flutter_login/src/widgets/animated_button.dart';
import 'package:flutter_login/src/color_helper.dart';
import 'package:flutter/material.dart';
import 'package:flutter_login/theme.dart';

class WaitingButton extends StatefulWidget {
  const WaitingButton({
    Key? key,
    required this.text,
    required this.onPressed,
    required this.controller,
  }) : super(key: key);

  final String text;
  final Function? onPressed;
  final AnimationController? controller;

  @override
  State<WaitingButton> createState() => _WaitingButtonState();
}

class _WaitingButtonState extends State<WaitingButton> with SingleTickerProviderStateMixin {

  @override
  void initState() {
    super.initState();
  }


  ThemeData _mergeTheme() {
    final theme = Theme.of(context);
    final loginTheme = LoginTheme();
    final blackOrWhite =
    theme.brightness == Brightness.light ? Colors.black54 : Colors.white;
    final primaryOrWhite = theme.brightness == Brightness.light
        ? theme.primaryColor
        : Colors.white;
    final originalPrimaryColor = loginTheme.primaryColor ?? theme.primaryColor;
    final primaryDarkShades = getDarkShades(originalPrimaryColor);
    final primaryColor = primaryDarkShades.length == 1
        ? lighten(primaryDarkShades.first!)
        : primaryDarkShades.first;
    final primaryColorDark = primaryDarkShades.length >= 3
        ? primaryDarkShades[2]
        : primaryDarkShades.last;
    final accentColor = loginTheme.accentColor ?? theme.colorScheme.secondary;
    final errorColor = loginTheme.errorColor ?? theme.errorColor;
    // the background is a dark gradient, force to use white text if detect default black text color
    final isDefaultBlackText = theme.textTheme.headline3!.color ==
        Typography.blackMountainView.headline3!.color;
    final titleStyle = theme.textTheme.headline3!
        .copyWith(
      color: loginTheme.accentColor ??
          (isDefaultBlackText
              ? Colors.white
              : theme.textTheme.headline3!.color),
      fontSize: loginTheme.beforeHeroFontSize,
      fontWeight: FontWeight.w300,
    )
        .merge(loginTheme.titleStyle);
    final footerStyle = theme.textTheme.bodyText1!
        .copyWith(
      color: loginTheme.accentColor ??
          (isDefaultBlackText
              ? Colors.white
              : theme.textTheme.headline3!.color),
    )
        .merge(loginTheme.footerTextStyle);
    final textStyle = theme.textTheme.bodyText2!
        .copyWith(color: blackOrWhite)
        .merge(loginTheme.bodyStyle);
    final textFieldStyle = theme.textTheme.subtitle1!
        .copyWith(color: blackOrWhite, fontSize: 14)
        .merge(loginTheme.textFieldStyle);
    final buttonStyle = theme.textTheme.button!
        .copyWith(color: Colors.white)
        .merge(loginTheme.buttonStyle);
    final cardTheme = loginTheme.cardTheme;
    final inputTheme = loginTheme.inputTheme;
    final buttonTheme = loginTheme.buttonTheme;
    final roundBorderRadius = BorderRadius.circular(100);

    LoginThemeHelper.loginTextStyle = titleStyle;

    TextStyle labelStyle;

    if (loginTheme.primaryColorAsInputLabel) {
      labelStyle = TextStyle(color: primaryColor);
    } else {
      labelStyle = TextStyle(color: blackOrWhite);
    }

    return theme.copyWith(
      primaryColor: primaryColor,
      primaryColorDark: primaryColorDark,
      errorColor: errorColor,
      cardTheme: theme.cardTheme.copyWith(
        clipBehavior: cardTheme.clipBehavior,
        color: cardTheme.color ?? theme.cardColor,
        elevation: cardTheme.elevation ?? 12.0,
        margin: cardTheme.margin ?? const EdgeInsets.all(4.0),
        shape: cardTheme.shape ??
            RoundedRectangleBorder(borderRadius: BorderRadius.circular(20.0)),
      ),
      inputDecorationTheme: theme.inputDecorationTheme.copyWith(
        filled: inputTheme.filled,
        fillColor: inputTheme.fillColor ??
            Color.alphaBlend(
              primaryOrWhite.withOpacity(.07),
              Colors.grey.withOpacity(.04),
            ),
        contentPadding: inputTheme.contentPadding ??
            const EdgeInsets.symmetric(vertical: 4.0),
        errorStyle: inputTheme.errorStyle ?? TextStyle(color: errorColor),
        labelStyle: inputTheme.labelStyle ?? labelStyle,
        enabledBorder: inputTheme.enabledBorder ??
            inputTheme.border ??
            OutlineInputBorder(
              borderSide: const BorderSide(color: Colors.transparent),
              borderRadius: roundBorderRadius,
            ),
        focusedBorder: inputTheme.focusedBorder ??
            inputTheme.border ??
            OutlineInputBorder(
              borderSide: BorderSide(color: primaryColor!, width: 1.5),
              borderRadius: roundBorderRadius,
            ),
        errorBorder: inputTheme.errorBorder ??
            inputTheme.border ??
            OutlineInputBorder(
              borderSide: BorderSide(color: errorColor),
              borderRadius: roundBorderRadius,
            ),
        focusedErrorBorder: inputTheme.focusedErrorBorder ??
            inputTheme.border ??
            OutlineInputBorder(
              borderSide: BorderSide(color: errorColor, width: 1.5),
              borderRadius: roundBorderRadius,
            ),
        disabledBorder: inputTheme.disabledBorder ??
            inputTheme.border ??
            OutlineInputBorder(
              borderSide: const BorderSide(color: Colors.transparent),
              borderRadius: roundBorderRadius,
            ),
      ),
      floatingActionButtonTheme: theme.floatingActionButtonTheme.copyWith(
        backgroundColor: buttonTheme.backgroundColor ?? primaryColor,
        splashColor: buttonTheme.splashColor ?? theme.colorScheme.secondary,
        elevation: buttonTheme.elevation ?? 4.0,
        highlightElevation: buttonTheme.highlightElevation ?? 2.0,
        shape: buttonTheme.shape ?? const StadiumBorder(),
      ),
      // put it here because floatingActionButtonTheme doesnt have highlightColor property
      highlightColor:
      loginTheme.buttonTheme.highlightColor ?? theme.highlightColor,
      textTheme: theme.textTheme.copyWith(
        headline3: titleStyle,
        bodyText2: textStyle,
        subtitle1: textFieldStyle,
        subtitle2: footerStyle,
        button: buttonStyle,
      ),
      colorScheme:
      Theme.of(context).colorScheme.copyWith(secondary: accentColor),
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = _mergeTheme();
    return Theme(
      data: theme,
      child: AnimatedButton(
        controller: widget.controller,
        onPressed: widget.onPressed,
        text: "Alterar",
      ),
    );
  }
}
