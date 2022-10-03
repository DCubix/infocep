import 'package:flutter/material.dart';
import 'package:infocep/models/endereco.dart';

class ItemEndereco extends StatelessWidget {
  const ItemEndereco({ required this.endereco, this.onDelete, super.key});

  final Endereco endereco;
  final Function()? onDelete;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Card(
      elevation: 5.0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12.0),
      ),
      clipBehavior: Clip.antiAlias,
      child: InkWell(
        onTap: () {

        },
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
            trailing: onDelete != null ? IconButton(
              visualDensity: VisualDensity.compact,
              color: Colors.red[700],
              icon: const Icon(Icons.close),
              onPressed: onDelete,
            ) : null,
          ),
        ),
      ),
    );
  }
}