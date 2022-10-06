import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:implicitly_animated_list/implicitly_animated_list.dart';
import 'package:infocep/controllers/endereco_controller.dart';
import 'package:infocep/models/endereco.dart';
import 'package:infocep/widgets/app_title.dart';
import 'package:infocep/widgets/empty.dart';
import 'package:infocep/widgets/item_endereco.dart';
import 'package:infocep/widgets/loading.dart';
import 'package:open_filex/open_filex.dart';
import 'package:sweetsheet/sweetsheet.dart';

class HomePage extends GetView<EnderecoController> {
  HomePage({super.key});

  final SweetSheet _sweetSheet = SweetSheet();
  final _buscaCtrl = TextEditingController();

  _buscarEnderecoAction() async {
    await Get.toNamed('/buscar');
  }

  _deletarEndereco(BuildContext context, Endereco endereco) async {
    _sweetSheet.show(
      context: context,
      title: Text('Deletar Endereço', style: TextStyle(fontSize: 22.0, color: Colors.red[700]!, fontWeight: FontWeight.w400)),
      description: Text('Tem certeza que deseja deletar o endereço "${endereco.titulo} ${endereco.subtitulo}"?', style: const TextStyle(fontSize: 16.0, color: Colors.black)),
      color: CustomSheetColor(
        main: Colors.white,
        accent: Colors.red[700]!,
        icon: Colors.red[700]!,
      ),
      negative: SweetSheetAction(
        title: 'Não',
        icon: Icons.close,
        onPressed: () async {
          Navigator.pop(context);
        },
      ),
      positive: SweetSheetAction(
        title: 'Sim',
        icon: Icons.check_rounded,
        onPressed: () async {
          Navigator.pop(context);
          await controller.deletar(endereco);
        },
      ),
    );
  }

  _exportar(BuildContext context) async {
    final theme = Theme.of(context);

    final ctrl = Get.find<EnderecoController>();
    final file = await ctrl.gerarPdf();

    _sweetSheet.show(
      context: context,
      title: const Text('Relatório Exportado', style: TextStyle(fontSize: 22.0, color: Colors.black, fontWeight: FontWeight.w400)),
      description: Text('Seu relatório foi exportado com sucesso.', style: TextStyle(fontSize: 16.0, color: Colors.grey[600])),
      color: CustomSheetColor(
        main: Colors.white,
        accent: theme.primaryColor,
        icon: theme.primaryColor,
      ),
      positive: SweetSheetAction(
        title: 'Abrir',
        icon: Icons.file_open_rounded,
        onPressed: () {
          OpenFilex.open(file.path);
        },
      ),
      negative: SweetSheetAction(
        title: 'Fechar',
        icon: Icons.close,
        onPressed: () {
          Navigator.pop(context);
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: const AppTitle(),
        actions: [
          controller.obx(
            (state) => TextButton.icon(
              style: TextButton.styleFrom(
                foregroundColor: Colors.white,
              ),
              onPressed: () => _exportar(context),
              icon: const Icon(Icons.file_present_rounded),
              label: const Text('Exportar'),
            ),
            onLoading: const SizedBox(),
            onEmpty: const SizedBox(),
          ),
        ]
      ),
      backgroundColor: Colors.grey[200],
      body: Column(
        children: [
          controller.obx(
            (state) => Container(
              margin: const EdgeInsets.all(12.0).copyWith(bottom: 6),
              decoration: BoxDecoration(
                color: Colors.grey[350],
                borderRadius: BorderRadius.circular(32.0),
              ),
              child: TextFormField(
                controller: _buscaCtrl,
                decoration: const InputDecoration(
                  border: InputBorder.none,
                  errorBorder: InputBorder.none,
                  enabledBorder: InputBorder.none,
                  focusedBorder: InputBorder.none,
                  disabledBorder: InputBorder.none,
                  focusedErrorBorder: InputBorder.none,
                  isDense: true,
                  contentPadding: EdgeInsets.symmetric(horizontal: 16.0, vertical: 12.0),
                  hintText: 'Busca',
                ),
                style: const TextStyle(fontSize: 20.0),
                onChanged: (s) async {
                  controller.busca.value = s;
                  controller.loadData();
                },
              ),
            ),
            onLoading: const SizedBox(),
            onEmpty: const SizedBox(),
          ),

          Expanded(
            child: controller.obx(
              (state) => ImplicitlyAnimatedList(
                padding: const EdgeInsets.all(12.0).copyWith(bottom: 70.0, top: 6),
                itemData: controller.state ?? [],
                itemBuilder: (_, e) => ItemEndereco(endereco: e, onDelete: () => _deletarEndereco(context, e)),
              ),
              onEmpty: Empty(
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
              ),
              onError: (error) => const Empty(
                state: EmptyState.empty,
                message: [
                  TextSpan(
                    text: 'Falha ao recuperar os dados.'
                  ),
                ],
              ),
              onLoading: const Loading(),
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: _buscarEnderecoAction,
        icon: const Icon(Icons.add),
        label: const Text('Novo'),
      ),
    );
  }
}
