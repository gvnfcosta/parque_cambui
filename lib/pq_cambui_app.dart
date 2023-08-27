import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:parquecambui/src/pages/home/users/user_form.dart';
import 'package:provider/provider.dart';

import 'package:parquecambui/src/config/app_controller.dart';
import 'package:parquecambui/src/models/anuncios_locais_list.dart';
import 'package:parquecambui/src/models/publisher_cart_list.dart';
import 'package:parquecambui/src/pages/home/anuncios/anuncios_locais_form_page.dart';
import 'package:parquecambui/src/pages/home/publisher_cart/publisher_cart_back.dart';
import 'package:parquecambui/src/pages/home/publisher_cart/publisher_cart_form_page.dart';
import 'package:parquecambui/src/pages/home/publisher_cart/publisher_cart_send.dart';
import 'src/models/limpeza_list.dart';
import 'src/pages/auth/auth_home_page.dart';
import 'src/pages/base/base_screen.dart';
import 'src/models/auth.dart';
import 'src/config/app_routes.dart';
import 'src/models/servico_campo_list.dart';
import 'src/models/reuniao_publica_list.dart';
import 'src/models/territories_list.dart';
import 'src/pages/home/components/controllers/admin_controller.dart';
import 'src/pages/home/limpeza/limpeza_form_page.dart';
import 'src/pages/home/reunioes/reuniao_publica_form.dart';
import 'src/models/grupos_list.dart';
import 'src/models/publicador_list.dart';
import 'src/models/reuniao_rvmc_list.dart';
import 'src/models/user_list.dart';
import 'src/pages/auth/sign_in_screen.dart';
import 'src/pages/home/reunioes/reuniao_rvmc_form.dart';
import 'src/pages/home/ministerio/servico_campo_form.dart';
import 'src/pages/home/territories/territories_back.dart';
import 'src/pages/home/territories/territories_form_pages.dart';
import 'src/pages/home/territories/territories_send.dart';

class PqCambuiApp extends StatelessWidget {
  const PqCambuiApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => Auth()),
        ChangeNotifierProvider(create: (_) => AdminController()),
        ChangeNotifierProxyProvider<Auth, PublicadorList>(
          create: (_) => PublicadorList('', '', []),
          update: (ctx, auth, previous) {
            return PublicadorList(
              auth.token ?? '',
              auth.email ?? '',
              previous?.items ?? [],
            );
          },
        ),
        ChangeNotifierProxyProvider<Auth, GruposList>(
          create: (_) => GruposList('', []),
          update: (ctx, auth, previous) {
            return GruposList(
              auth.token ?? '',
              previous?.items ?? [],
            );
          },
        ),
        ChangeNotifierProxyProvider<Auth, ReuniaoPublicaList>(
          create: (_) => ReuniaoPublicaList('', []),
          update: (ctx, auth, previous) {
            return ReuniaoPublicaList(
              auth.token ?? '',
              previous?.items ?? [],
            );
          },
        ),
        ChangeNotifierProxyProvider<Auth, ReuniaoRvmcList>(
          create: (_) => ReuniaoRvmcList('', []),
          update: (ctx, auth, previous) {
            return ReuniaoRvmcList(
              auth.token ?? '',
              previous?.items ?? [],
            );
          },
        ),
        ChangeNotifierProxyProvider<Auth, LimpezaList>(
          create: (_) => LimpezaList('', []),
          update: (ctx, auth, previous) {
            return LimpezaList(
              auth.token ?? '',
              previous?.items ?? [],
            );
          },
        ),
        ChangeNotifierProxyProvider<Auth, AnunciosLocaisList>(
          create: (_) => AnunciosLocaisList('', []),
          update: (ctx, auth, previous) {
            return AnunciosLocaisList(
              auth.token ?? '',
              previous?.items ?? [],
            );
          },
        ),
        ChangeNotifierProxyProvider<Auth, CampoList>(
          create: (_) => CampoList('', []),
          update: (ctx, auth, previous) {
            return CampoList(
              auth.token ?? '',
              previous?.items ?? [],
            );
          },
        ),
        ChangeNotifierProxyProvider<Auth, UserList>(
          create: (_) => UserList('', []),
          update: (ctx, auth, previous) {
            return UserList(
              auth.token ?? '',
              previous?.items ?? [],
            );
          },
        ),
        ChangeNotifierProxyProvider<Auth, TerritoriesList>(
          create: (_) => TerritoriesList('', []),
          update: (ctx, auth, previous) {
            return TerritoriesList(
              auth.token ?? '',
              previous?.items ?? [],
            );
          },
        ),
        ChangeNotifierProxyProvider<Auth, PublisherCartList>(
          create: (_) => PublisherCartList('', []),
          update: (ctx, auth, previous) {
            return PublisherCartList(
              auth.token ?? '',
              previous?.items ?? [],
            );
          },
        ),
      ],
      child: ValueListenableBuilder(
          valueListenable: AppController.instance.themeSwitch,
          builder: (context, isDark, child) {
            return MaterialApp(
              title: 'Parque Cambuí',
              theme: ThemeData(
                brightness: isDark ? Brightness.dark : Brightness.light,
                primarySwatch: Colors.blueGrey,
                scaffoldBackgroundColor: Colors.grey[300],
              ),
              localizationsDelegates: const [
                GlobalMaterialLocalizations.delegate,
                GlobalCupertinoLocalizations.delegate,
                GlobalWidgetsLocalizations.delegate,
              ],
              supportedLocales: const [Locale('pt', 'BR')],

              routes: {
                AppRoutes.authOrHome: (ctx) => const AuthOrHomePage(),
                AppRoutes.baseScreen: (ctx) => const BaseScreen(),
                AppRoutes.signInPage: (ctx) => const SignInScreen(),
                AppRoutes.campoForm: (ctx) => const ServicoCampoForm(),
                AppRoutes.reuniaoPubForm: (ctx) => const ReuniaoPublicaForm(),
                AppRoutes.reuniaoRvmcForm: (ctx) => const ReuniaoRvmcForm(),
                AppRoutes.territoriesForm: (ctx) => const TerritoriesFormPage(),
                AppRoutes.territoriesSend: (ctx) => const TerritorieSendPage(),
                AppRoutes.territoriesBack: (ctx) => const TerritoriesBackPage(),
                AppRoutes.publisherCartForm: (ctx) =>
                    const PublisherCartFormPage(),
                AppRoutes.publisherCartSend: (ctx) =>
                    const PublisherCartSendPage(),
                AppRoutes.publisherCartBack: (ctx) => const PublisherCartBack(),
                AppRoutes.userForm: (ctx) => const UserForm(),
                AppRoutes.limpezaForm: (ctx) => const LimpezaForm(),
                AppRoutes.anunciosLocaisForm: (ctx) =>
                    const AnunciosLocaisForm(),
              },
              debugShowCheckedModeBanner: false,
              // builder: (context, child) {
              //   final test = context.findAncestorWidgetOfExactType<MyApp>();
              //   return const SignInScreen();
              // },
            );
          }),
    );
  }
}
