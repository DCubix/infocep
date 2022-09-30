import 'package:flutter/material.dart';
import 'package:infocep/models/endereco.dart';

class InfoEndereco extends StatelessWidget {
  const InfoEndereco({ required this.endereco, super.key });

  final Endereco endereco;

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        ListTile(
          visualDensity: VisualDensity.compact,
          title: const Text('CEP'),
          subtitle: Text(endereco.cep.isEmpty ? '- - -' : endereco.cep),
        ),
        const Divider(),
        Row(
          children: [
            Expanded(
              child: ListTile(
                visualDensity: VisualDensity.compact,
                title: const Text('Cidade/Estado'),
                subtitle: Text(endereco.cidade.isEmpty ? '- - -' : '${endereco.cidade} - ${endereco.estado}'),
              ),
            ),
            Expanded(
              child: ListTile(
                visualDensity: VisualDensity.compact,
                title: const Text('Bairro'),
                subtitle: Text(endereco.bairro.isEmpty ? '- - -' : endereco.bairro),
              ),
            ),
          ],
        ),
        const Divider(),
        ListTile(
          visualDensity: VisualDensity.compact,
          title: const Text('Rua'),
          subtitle: Text(endereco.rua.isEmpty ? '- - -' : endereco.rua),
        ),
      ],
    );
  }
}