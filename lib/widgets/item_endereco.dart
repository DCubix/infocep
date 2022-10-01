import 'package:flutter/material.dart';
import 'package:infocep/models/endereco.dart';

class ItemEndereco extends StatelessWidget {
  const ItemEndereco({ required this.endereco, super.key});

  final Endereco endereco;

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 5.0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12.0),
      ),
      child: ListTile(
        contentPadding: const EdgeInsets.symmetric(vertical: 10.0, horizontal: 16.0),
        visualDensity: VisualDensity.compact,
        title: Text(endereco.titulo),
        subtitle: Text(endereco.subtitulo),
        trailing: const Icon(Icons.chevron_right),
      ),
    );
  }
}