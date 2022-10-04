import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:get/get.dart';
import 'package:infocep/pages/home.dart';
import 'package:infocep/widgets/loading.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:rive/rive.dart';

class SplashPage extends StatefulWidget {
  const SplashPage({super.key});

  @override
  State<SplashPage> createState() => _SplashPageState();
}

class _SplashPageState extends State<SplashPage> {

  @override
  void initState() {
    super.initState();
    SchedulerBinding.instance.addPostFrameCallback((timeStamp) async {
      await Future.delayed(const Duration(milliseconds: 2500));
      Get.off(() => const HomePage());
    });
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Scaffold(
      backgroundColor: theme.primaryColor,
      body: Stack(
        children: [
          const Align(
            alignment: Alignment.center,
            child: SizedBox(
              width: 250.0,
              child: RiveAnimation.asset('assets/infocep.riv', fit: BoxFit.contain),
            ),
          ),

          Align(
            alignment: Alignment.bottomCenter,
            child: FutureBuilder<PackageInfo>(
              future: PackageInfo.fromPlatform(),
              builder: (_, snapshot) {
                if (snapshot.connectionState != ConnectionState.done) {
                  return const Loading(color: Colors.white,);
                }

                return Padding(
                  padding: const EdgeInsets.all(24.0),
                  child: Text(
                    'InfoCEP v${snapshot.data!.version} - Diego Lopes',
                    style: const TextStyle(fontSize: 14.0, color: Colors.white)
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}