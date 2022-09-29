import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:infocep/pages/home.dart';
import 'package:infocep/storage/dao.dart';
import 'package:infocep/theme.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

void main() async {
  await dotenv.load(fileName: ".env");
  runApp(const InfoCEPRoot());
}

class InfoCEPRoot extends StatelessWidget {
  const InfoCEPRoot({super.key});

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      title: 'Flutter Demo',
      theme: appTheme,
      builder: (context, child) {
        // Instancia dos Stores de dados internos.
        Get.put(DAO('enderecos'), tag: 'enderecos');

        return child!;
      },
      home: const HomePage(),
    );
  }
}
