import 'package:flutter/material.dart';
import 'package:infocep/models/endereco.dart';
import 'package:intl/intl.dart';

class ItemEndereco extends StatelessWidget {
  const ItemEndereco({ required this.endereco, super.key});

  final Endereco endereco;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Card(
      elevation: 5.0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12.0),
      ),
      clipBehavior: Clip.antiAlias,
      child: Container(
        decoration: BoxDecoration(
          border: Border(
            left: BorderSide(
              color: theme.primaryColor,
              width: 12.0,
            ),
          ),
        ),
        padding: const EdgeInsets.all(12),
        child: ListTile(
          contentPadding: const EdgeInsets.all(0.0),
          visualDensity: VisualDensity.compact,
          dense: true,
          isThreeLine: true,
          title: Text(endereco.titulo, style: Theme.of(context).textTheme.headline5),
          subtitle: Text(endereco.subtitulo, style: TextStyle(fontSize: 17.0, color: Colors.grey[600])),
          trailing: IconButton(
            visualDensity: VisualDensity.compact,
            color: Colors.red[700],
            icon: const Icon(Icons.close),
            onPressed: () {

            },
          ),
          onTap: () {
            
          }
        ),
      ),
    );
  }
}