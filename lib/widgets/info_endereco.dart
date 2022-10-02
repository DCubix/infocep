import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:infocep/controllers/endereco_controller.dart';
import 'package:infocep/models/endereco.dart';

class InfoEndereco extends StatelessWidget {
  const InfoEndereco({ required this.endereco, super.key });

  final Endereco endereco;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final ctrl = Get.find<EnderecoController>();
    return ListTile(
      contentPadding: const EdgeInsets.all(0),
      title: Text(endereco.titulo, style: const TextStyle(fontSize: 23.0, color: Colors.black, fontWeight: FontWeight.w400)),
      subtitle: Text(endereco.subtitulo, style: TextStyle(fontSize: 15.0, color: Colors.grey[600])),
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
    );
  }
}