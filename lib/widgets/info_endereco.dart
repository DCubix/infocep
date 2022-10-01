import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:infocep/controllers/endereco_controller.dart';
import 'package:infocep/models/endereco.dart';
import 'package:infocep/storage/dao.dart';
import 'package:sembast/sembast.dart';

class InfoEndereco extends StatelessWidget {
  const InfoEndereco({ required this.endereco, super.key });

  final Endereco endereco;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final ctrl = Get.find<EnderecoController>();
    final dao = Get.find<DAO>(tag: 'enderecos');
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      mainAxisSize: MainAxisSize.min,
      children: [
        const SizedBox(height: 12.0),
        ListTile(
          title: Text(endereco.titulo, style: Theme.of(context).textTheme.headline5),
          subtitle: Text(endereco.subtitulo, style: TextStyle(fontSize: 17.0, color: Colors.grey[600])),
          trailing: ctrl.obx(
            (state) => IconButton(
              color: theme.primaryColor,
              iconSize: 32.0,
              onPressed: () async {
                ctrl.salvar(endereco);
              },
              icon: const Icon(Icons.save_outlined),
            ),
            onLoading: const SizedBox(width: 24, height: 24, child: CircularProgressIndicator())
          ),
        ),
      ],
    );
  }
}