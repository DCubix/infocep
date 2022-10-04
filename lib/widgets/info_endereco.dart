import 'package:flutter/material.dart';
import 'package:infocep/models/endereco.dart';

class InfoEndereco extends StatelessWidget {
  const InfoEndereco({ required this.endereco, super.key });

  final Endereco endereco;

  @override
  Widget build(BuildContext context) {
    return ListTile(
      contentPadding: const EdgeInsets.all(0),
      title: Text(endereco.titulo, style: const TextStyle(fontSize: 23.0, color: Colors.black, fontWeight: FontWeight.w400)),
      subtitle: Text(endereco.subtitulo, style: TextStyle(fontSize: 15.0, color: Colors.grey[600])),
    );
  }
}