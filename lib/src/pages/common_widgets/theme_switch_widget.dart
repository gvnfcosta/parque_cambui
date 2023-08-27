import 'package:flutter/material.dart';
import 'package:parquecambui/src/config/app_controller.dart';

class ThemeCustomWidget extends StatelessWidget {
  const ThemeCustomWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Transform.scale(
      scale: 0.8,
      child: Switch(
          value: AppController.instance.themeSwitch.value,
          onChanged: (value) {
            AppController.instance.changeTheme(value);
          }),
    );
  }
}
