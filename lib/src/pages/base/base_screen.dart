import 'dart:async';

import 'package:another_flushbar/flushbar.dart';
import 'package:flutter/material.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:parquecambui/src/models/publicador_list.dart';
import 'package:parquecambui/src/pages/base/check_user.dart';
import 'package:parquecambui/src/pages/home/components/page_tabs/publisher_cart_tab.dart';
import 'package:provider/provider.dart';
import '../home/components/page_tabs/anuncios_tab.dart';
import '../home/components/page_tabs/home_tab.dart';
import '../home/components/page_tabs/ministerio_tab.dart';
import '../home/components/page_tabs/profile_tab.dart';
import '../home/components/page_tabs/territories_tab.dart';

class BaseScreen extends StatefulWidget {
  const BaseScreen({super.key});

  @override
  State<BaseScreen> createState() => _BaseScreenState();
}

Future<void> onBackgroundMessage(RemoteMessage message) async {
  print(message.data);
}

class _BaseScreenState extends State<BaseScreen> {
  FirebaseMessaging messaging = FirebaseMessaging.instance;

  //Controle da tela aberta
  int currentIndex = 0;
  final pageController = PageController();

  final List<Widget> tabsGeral = [
    const HomeTab(),
    const ProfileTab(),
  ];

  final List<Widget> tabsPub = [
    const HomeTab(),
    const MinisterioTab(),
    const AnunciosTab(),
    const TerritoriesTab(),
    const ProfileTab(),
  ];

  final List<Widget> tabsCart = [
    const HomeTab(),
    const MinisterioTab(),
    const AnunciosTab(),
    const PublisherCartTab(),
    const TerritoriesTab(),
    const ProfileTab(),
  ];

  final List<BottomNavigationBarItem> navigationsGeral = [
    const BottomNavigationBarItem(
      icon: Icon(Icons.home),
      label: 'Reuniões',
    ),
    const BottomNavigationBarItem(
      icon: Icon(Icons.person),
      label: 'Perfil',
    ),
  ];

  final List<BottomNavigationBarItem> navigationsPub = [
    const BottomNavigationBarItem(
      icon: Icon(Icons.home),
      label: 'Reuniões',
    ),
    const BottomNavigationBarItem(
      icon: Icon(Icons.business_center),
      label: 'Ministério',
    ),
    const BottomNavigationBarItem(
      icon: Icon(Icons.list),
      label: 'Anúncios',
    ),
    const BottomNavigationBarItem(
      icon: Icon(Icons.map),
      label: 'Territórios',
    ),
    const BottomNavigationBarItem(
      icon: Icon(Icons.person),
      label: 'Perfil',
    ),
  ];

  final List<BottomNavigationBarItem> navigationsCart = [
    const BottomNavigationBarItem(
      icon: Icon(Icons.home),
      label: 'Reuniões',
    ),
    const BottomNavigationBarItem(
      icon: Icon(Icons.business_center),
      label: 'Ministério',
    ),
    const BottomNavigationBarItem(
      icon: Icon(Icons.list),
      label: 'Anúncios',
    ),
    const BottomNavigationBarItem(
      icon: Icon(Icons.kitchen_outlined),
      label: 'Público',
    ),
    const BottomNavigationBarItem(
      icon: Icon(Icons.map),
      label: 'Territórios',
    ),
    const BottomNavigationBarItem(
      icon: Icon(Icons.person),
      label: 'Perfil',
    ),
  ];

  @override
  void initState() {
    super.initState();

    initializeFcm();
  }

  String? token;

  Future<void> initializeFcm() async {
    // token = await messaging.getToken(
    //     vapidKey:
    //         'BI70t7lMsc44mXUX2X44YhXxFx-SA0R5r0r1cgagDUddGjzkSiCG064WF4m6-Epujltwk2uzCuh7BLZamuOjosA');
    // print(token);
    // setState(() {});

    FirebaseMessaging.onMessage.listen((message) {
      if (message.notification != null) {
        Flushbar(
            margin: const EdgeInsets.all(8),
            borderRadius: BorderRadius.circular(8),
            title: message.notification!.title,
            titleColor: Colors.indigo,
            titleSize: 18,
            message: message.notification!.body,
            messageColor: Colors.black,
            messageSize: 16,
            flushbarPosition: FlushbarPosition.TOP,
            backgroundColor: Colors.grey.shade100,
            duration: const Duration(seconds: 60),
            onTap: (_) {
              print('Foreground message ${message.data}');
              // Navigator.of(context).pushNamed(message.data['route'])
            }).show(context);
      }
    });

    FirebaseMessaging.onBackgroundMessage(onBackgroundMessage);

    FirebaseMessaging.onMessageOpenedApp.listen((message) {
      print('Toque em background: ${message.notification?.title}');
    });

    final RemoteMessage? message = await messaging.getInitialMessage();
    if (message != null) {
      print('Toque em terminated: ${message.notification?.title}');
    }
  }

  @override
  Widget build(BuildContext context) {
    var firstPub = Provider.of<PublicadorList>(context).firstPub;
    String user = firstPub?.nome ?? '';
    bool isPub = (firstPub?.nivel ?? 0) == 1;
    bool isCart = (firstPub?.nivel ?? 0) >= 2;

    return user == ''
        ? const CheckUser()
        : Scaffold(
            body: Stack(children: [
              PageView(
                  physics: const NeverScrollableScrollPhysics(),
                  controller: pageController, //indica qual a tela aberta
                  children: isCart
                      ? tabsCart
                      : isPub
                          ? tabsPub
                          : tabsGeral),
              //  if (token != null) SelectableText(token!),
            ]),
            bottomNavigationBar: BottomNavigationBar(
                currentIndex: currentIndex,
                onTap: (indice) {
                  setState(() {
                    currentIndex = indice;
                    pageController.jumpToPage(indice); //muda a tela pelo indice
                  });
                },
                type: BottomNavigationBarType.fixed,
                backgroundColor: const Color(0xFF12202F),
                selectedItemColor: Colors.white,
                selectedFontSize: 12,
                unselectedItemColor: Colors.white.withAlpha(100),
                unselectedFontSize: 11,
                items: isCart
                    ? navigationsCart
                    : isPub
                        ? navigationsPub
                        : navigationsGeral),
          );
  }
}
