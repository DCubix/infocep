import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:infocep/controllers/binding.dart';
import 'package:infocep/pages/buscar_endereco.dart';
import 'package:infocep/pages/endereco_view.dart';
import 'package:infocep/pages/home.dart';
import 'package:infocep/pages/splash.dart';

void main() {
  runApp(const InfoCEPRoot());
}

class InfoCEPRoot extends StatelessWidget {
  const InfoCEPRoot({super.key});

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      title: 'InfoCEP',
      defaultTransition: Transition.cupertino,
      theme: ThemeData(
        primarySwatch: Colors.indigo,
      ),
      initialRoute: '/',
      getPages: [
        GetPage(name: '/', page: () => const SplashPage()),
        GetPage(name: '/home', page: () => HomePage()),
        GetPage(name: '/buscar', page: () => const BuscarEnderecoPage()),
        GetPage(name: '/visualizar', page: () => const EnderecoViewPage()),
      ],
      initialBinding: StoreBinding(),
      home: const SplashPage(),
    );
  }
}
