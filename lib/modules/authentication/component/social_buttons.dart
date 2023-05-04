import 'dart:io';

import 'package:auth_buttons/auth_buttons.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:ekayzone/modules/authentication/controllers/login/login_bloc.dart';

class SocialButtons extends StatelessWidget {
  const SocialButtons({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Visibility(
          visible: true,
          child: GoogleAuthButton(
            onPressed: () {
              context.read<LoginBloc>().add(LoginWithGoogleEventSubmit(context));
            },
            themeMode: ThemeMode.system,
            style: const AuthButtonStyle(
                buttonType: AuthButtonType.secondary,
                elevation: 0,
                iconSize: 18,
                padding: EdgeInsets.symmetric(horizontal: 10),
                height: 40,
                width: 40
                // iconType: AuthIconType.secondary,
                ),
          ),
        ),
        const SizedBox(width: 15),
        Visibility(
          visible: false,
          child: FacebookAuthButton(
            onPressed: () {
              print("///////////////////////");
              context.read<LoginBloc>().add(LoginWithFacebookEventSubmit(context));
            },
            themeMode: ThemeMode.system,
            style: const AuthButtonStyle(
                buttonType: AuthButtonType.secondary,
                padding: EdgeInsets.symmetric(horizontal: 8),
                iconColor: Colors.blue,
                elevation: 0,
                iconSize: 18,
                height: 40,
                width: 40
                // iconType: AuthIconType.secondary,
                ),
          ),
        ),
        const SizedBox(width: 15),
        Visibility(
          visible: Platform.isIOS,
          child: AppleAuthButton(
            onPressed: () {},
            themeMode: ThemeMode.system,
            style: const AuthButtonStyle(
                buttonType: AuthButtonType.secondary,
                elevation: 0,
                padding: EdgeInsets.symmetric(horizontal: 10),
                iconSize: 18,
                height: 40,
                width: 40
              // iconType: AuthIconType.secondary,
            ),
          ),
        ),

      ],
    );
  }
}
