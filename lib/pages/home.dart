import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:get/get.dart';
import 'package:infocep/controllers/endereco_controller.dart';
import 'package:infocep/models/endereco.dart';
import 'package:infocep/pages/buscar_endereco.dart';
import 'package:infocep/storage/dao.dart';
import 'package:infocep/widgets/app_title.dart';
import 'package:infocep/widgets/empty.dart';
import 'package:infocep/widgets/item_endereco.dart';
import 'package:infocep/widgets/loading.dart';
import 'package:sembast/sembast.dart';

const perPageCount = 20;

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {

  _buscarEnderecoAction() async {
    final ctrl = Get.find<EnderecoController>();
    await Get.to(() => const BuscarEnderecoPage());
    ctrl.buscar('');
  }

  @override
  void initState() {
    super.initState();
    SchedulerBinding.instance.addPostFrameCallback((timeStamp) {
      final ctrl = Get.find<EnderecoController>();
      ctrl.buscar('');
    });
  }

  @override
  Widget build(BuildContext context) {
    final ctrl = Get.find<EnderecoController>();

    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: const AppTitle(),
      ),
      backgroundColor: Colors.grey[200],
      body: ctrl.obx(
        onLoading: const Center(child: CircularProgressIndicator()),
        (state) {
          final data = state ?? [];
          if (data.isEmpty) {
            return Empty(
              state: EmptyState.empty,
              message: [
                const TextSpan(
                  text: 'Nenhum endereço encontrado. Clique em '
                ),
                WidgetSpan(
                  alignment: PlaceholderAlignment.middle,
                  child: ElevatedButton.icon(
                    style: ElevatedButton.styleFrom(
                      visualDensity: VisualDensity.compact,
                    ),
                    onPressed: _buscarEnderecoAction,
                    label: const Text('Novo'),
                    icon: const Icon(Icons.add),
                  ),
                ),
                const TextSpan(
                  text: ' para começar.'
                ),
              ],
            );
          }

          return ListView(
            padding: const EdgeInsets.all(12.0),
            children: [
              ...data.map((e) => ItemEndereco(endereco: e)),
            ],
          );
        },
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: _buscarEnderecoAction,
        icon: const Icon(Icons.add),
        label: const Text('Novo'),
      ),
    );
  }
}
