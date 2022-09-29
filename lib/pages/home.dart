import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:infocep/models/endereco.dart';
import 'package:infocep/storage/dao.dart';
import 'package:infocep/widgets/app_title.dart';
import 'package:infocep/widgets/empty.dart';
import 'package:infocep/widgets/loading.dart';
import 'package:sembast/sembast.dart';

const perPageCount = 20;

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {

  final TextEditingController _buscaCtrl = TextEditingController();

  int _start = 0;

  Future<List<Endereco>> _listarSalvos(String busca, int start) async {
    final dao = Get.find<DAO>(tag: 'enderecos');

    final regexp = RegExp(busca, caseSensitive: false);
    final filter = busca.trim().isNotEmpty ?
      Filter.or([
        Filter.matchesRegExp('cep', regexp),
        Filter.matchesRegExp('estado', regexp),
        Filter.matchesRegExp('cidade', regexp),
        Filter.matchesRegExp('bairro', regexp),
        Filter.matchesRegExp('rua', regexp),
      ]) 
      : null;

    final list = await dao.query(
      finder: Finder(
        filter: filter,
        offset: start,
        limit: 20,
        sortOrders: [ SortOrder('dataRegistro', false) ],
      ),
    );

    if (list.isEmpty) {
      return [];
    }

    return list.map((e) => Endereco.fromInternal(e)).toList();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const AppTitle(),
      ),
      backgroundColor: Colors.grey[200],
      body: FutureBuilder<List<Endereco>>(
        future: _listarSalvos(_buscaCtrl.text, _start),
        builder: (_, snap) {
          if (snap.connectionState != ConnectionState.done) {
            return const Loading();
          }

          final data = snap.data ?? [];
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
                    onPressed: () {},
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
          );
        },
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {},
        icon: const Icon(Icons.add),
        label: const Text('Novo'),
      ),
    );
  }
}
