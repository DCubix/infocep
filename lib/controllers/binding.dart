import 'package:get/get.dart';
import 'package:infocep/controllers/endereco_controller.dart';
import 'package:infocep/storage/dao.dart';

class StoreBinding implements Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => DAO('enderecos'), tag: 'enderecos');
    Get.lazyPut(() => EnderecoController());
  }

}