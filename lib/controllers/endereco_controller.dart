import 'package:get/get.dart';
import 'package:infocep/models/endereco.dart';
import 'package:infocep/storage/dao.dart';
import 'package:sembast/sembast.dart';

class EnderecoController extends GetxController with StateMixin<List<Endereco>> {

  @override
  void onInit() {
    super.onInit();
    change([], status: RxStatus.success());
  }

  salvar(Endereco endereco) async {
    change(state, status: RxStatus.loading());

    final dao = Get.find<DAO>(tag: 'enderecos');
    await dao.insert(endereco.toInternal());

    change(state, status: RxStatus.success());
  }

  buscar(String busca, [int start = 0]) async {
    change(state, status: RxStatus.loading());

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

    change(list.map((e) => Endereco.fromInternal(e)).toList(), status: RxStatus.success());
  }

}