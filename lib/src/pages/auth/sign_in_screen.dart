import 'package:flutter/material.dart';
import 'package:animated_text_kit/animated_text_kit.dart';
import '../../constants/app_customs.dart';
import '../common_widgets/auth_form.dart';

enum AuthMode { signup, login }

class SignInScreen extends StatefulWidget {
  const SignInScreen({super.key});

  @override
  State<SignInScreen> createState() => _SignInScreenState();
}

class _SignInScreenState extends State<SignInScreen> {
  bool isObscure = false;
  bool isSecret = true;
  IconData icon = Icons.visibility_off;

  @override
  void initState() {
    super.initState();
    isObscure = isSecret;
  }

  List<AnimatedText> textoAnimated = [
    FadeAnimatedText('Reuniões'),
    FadeAnimatedText('Ministério'),
    FadeAnimatedText('Anúncios'),
    FadeAnimatedText('Territórios'),
    FadeAnimatedText('Testemunho Público'),
    FadeAnimatedText('Congresso'),
    FadeAnimatedText('Assembléias'),
  ];

  @override
  Widget build(BuildContext context) {
    final deviceSize = MediaQuery.of(context).size;
    return Scaffold(
      backgroundColor: CustomColors.customSwatchColor,
      body: Center(
        child: SingleChildScrollView(
          child: SizedBox(
            width: 400,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                deviceSize.height > 600
                    ? Padding(
                        padding: const EdgeInsets.symmetric(vertical: 12.0),
                        child: SizedBox(
                            height: 150,
                            child: Image.asset('assets/icone.png')),
                      )
                    : const SizedBox.shrink(),
                //Nome do App
                const Text.rich(
                    TextSpan(style: TextStyle(fontSize: 40), children: [
                  TextSpan(
                      text: 'Congregação',
                      style: TextStyle(
                          color: Colors.white,
                          fontSize: 36,
                          fontWeight: FontWeight.w200,
                          letterSpacing: 1.2)),
                ])),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: RichText(
                      textAlign: TextAlign.center,
                      text: const TextSpan(
                          style: TextStyle(fontSize: 44),
                          children: [
                            TextSpan(
                                text: 'Parque Cambuí',
                                style: TextStyle(
                                    color: Colors.cyanAccent,
                                    fontWeight: FontWeight.w400)),
                          ])),
                ),

                const SizedBox(height: 10),

                Column(children: [
                  Container(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 25, vertical: 10),
                    child: const AuthForm(),
                  ),
                ]),

                Padding(
                  padding: const EdgeInsets.only(top: 12.0),
                  child: SizedBox(
                      height: 45,
                      child: DefaultTextStyle(
                          style: const TextStyle(
                              fontSize: 30,
                              fontWeight: FontWeight.w100,
                              color: Colors.amber),
                          child: AnimatedTextKit(
                              pause: Duration.zero,
                              repeatForever: true,
                              animatedTexts: textoAnimated))),
                ),

                deviceSize.height > 500
                    ? const Padding(
                        padding: EdgeInsets.only(left: 30, top: 10, right: 30),
                        child: Column(children: [
                          Text(
                              '"Mas eu entrarei na tua casa por causa do teu grande amor leal." - Salmo 5:7\n',
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                  fontSize: 16,
                                  color: Colors.white,
                                  fontWeight: FontWeight.w200)),
                        ]),
                      )
                    : const SizedBox(),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
