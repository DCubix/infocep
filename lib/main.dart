import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:infocep/pages/home.dart';
import 'package:infocep/storage/dao.dart';

void main() {
  runApp(const InfoCEPRoot());
}

class InfoCEPRoot extends StatelessWidget {
  const InfoCEPRoot({super.key});

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      title: 'Flutter Demo',
      defaultTransition: Transition.cupertino,
      theme: ThemeData(
        primarySwatch: Colors.indigo,
      ),
      builder: (context, child) {
        // Instancia dos Stores de dados internos.
        Get.put(DAO('enderecos'), tag: 'enderecos');

        return child!;
      },
      home: const HomePage(),
    );
  }
}
