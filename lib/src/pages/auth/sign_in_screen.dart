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
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            children: [
              SizedBox(
                height: deviceSize.height / 10,
              ),
              //Nome do App
              Padding(
                padding: const EdgeInsets.all(12.0),
                child: SizedBox(
                    height: deviceSize.height / 4,
                    child: Image.asset('assets/icone.png')),
              ),
              const Text.rich(
                  TextSpan(style: TextStyle(fontSize: 40), children: [
                TextSpan(
                    text: 'Congregação',
                    style: TextStyle(
                        color: Colors.white,
                        fontSize: 30,
                        fontWeight: FontWeight.w200,
                        letterSpacing: 1.2)),
              ])),
              Padding(
                padding: const EdgeInsets.all(2.0),
                child: RichText(
                    textAlign: TextAlign.center,
                    text: const TextSpan(
                        style: TextStyle(fontSize: 40),
                        children: [
                          TextSpan(
                              text: 'Parque Cambuí',
                              style: TextStyle(
                                  color: Colors.cyanAccent,
                                  fontWeight: FontWeight.w400)),
                        ])),
              ),
              Padding(
                padding: const EdgeInsets.only(top: 12.0),
                child: SizedBox(
                    height: 45,
                    child: DefaultTextStyle(
                        style: const TextStyle(
                            fontSize: 26,
                            fontWeight: FontWeight.w100,
                            color: Colors.amber),
                        child: AnimatedTextKit(
                            pause: Duration.zero,
                            repeatForever: true,
                            animatedTexts: textoAnimated))),
              ),

              Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 25, vertical: 10),
                child: const AuthForm(),
              ),
              deviceSize.height > 500
                  ? const Padding(
                      padding: EdgeInsets.only(left: 30, top: 10, right: 30),
                      child: Column(mainAxisSize: MainAxisSize.min, children: [
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
    );
  }
}
