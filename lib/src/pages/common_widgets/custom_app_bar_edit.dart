import 'package:flutter/material.dart';
import 'package:parquecambui/src/constants/app_customs.dart';

class CustomAppBarEdit extends StatelessWidget {
  const CustomAppBarEdit(
      this.title, this.posTitle, // this.setDate, // this.submit,
      {super.key});
  final String title;
  final String posTitle;
  //final DateTime setDate;
  // final Future Function() submit;

  @override
  Widget build(BuildContext context) {
    return AppBar(
      automaticallyImplyLeading: false,
      elevation: 0,
      backgroundColor: CustomColors.editAppBarBackgroundColor,
      title: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: const TextStyle(fontSize: CustomFonts.appBarEditFontSize),
          ),
          Text(
            posTitle,
            style: const TextStyle(
              fontSize: CustomFonts.appBarEditFontSize + 2,
            ),
          ),
        ],
      ),
    );
  }
}
