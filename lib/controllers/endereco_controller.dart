import 'dart:io';

import 'package:get/get.dart';
import 'package:infocep/models/endereco.dart';
import 'package:infocep/storage/dao.dart';
import 'package:intl/intl.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:printing/printing.dart';
import 'package:sembast/sembast.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:path/path.dart' as path;

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

  deletar(Endereco endereco) async {
    change(state, status: RxStatus.loading());

    final dao = Get.find<DAO>(tag: 'enderecos');
    await dao.delete(Filter.equals('key', endereco.key));

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
        limit: 10,
        sortOrders: [ SortOrder('dataRegistro', false) ],
      ),
    );

    change(list.map((e) => Endereco.fromInternal(e)).toList(), status: RxStatus.success());
  }

  Future<File> gerarPdf() async {
    await buscar('');

    final logo = await imageFromAssetBundle('assets/logopdf.png');
    final pdf = pw.Document();
    pdf.addPage(pw.MultiPage(
      pageFormat: PdfPageFormat.a4,
      header: (pw.Context context) => pw.Column(
        mainAxisSize: pw.MainAxisSize.min,
        children: [
          pw.Row(
            mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
            children: [
              pw.Text('CEPs/Endereços Salvos', style: const pw.TextStyle(fontSize: 22.0, color: PdfColors.black)),
              pw.Image(logo, width: 100.0, fit: pw.BoxFit.contain),
            ]
          ),
          pw.Divider(),
          pw.SizedBox(height: 16.0),
        ]
      ),
      build: (pw.Context context) {
        return [
          ...state!.map((e) => pw.Container(
            margin: const pw.EdgeInsets.all(16.0).copyWith(top: 0.0),
            padding: const pw.EdgeInsets.symmetric(vertical: 8.0, horizontal: 12.0),
            decoration: const pw.BoxDecoration(
              border: pw.Border(
                left: pw.BorderSide(
                  color: PdfColors.indigo,
                  width: 6.0,
                )
              ),
            ),
            child: pw.Column(
              crossAxisAlignment: pw.CrossAxisAlignment.start,
              mainAxisSize: pw.MainAxisSize.min,
              children: [
                pw.Text(e.titulo, style: const pw.TextStyle(fontSize: 18.0, color: PdfColors.black)),
                pw.Text(e.subtitulo, style: const pw.TextStyle(fontSize: 13.0, color: PdfColors.grey600)),
                pw.SizedBox(height: 6.0),
                pw.Text(DateFormat('dd/MM/yyyy HH:mm').format(e.dataRegistro.toDateTime()), style: const pw.TextStyle(fontSize: 10.0, color: PdfColors.grey600)),
              ]
            ),
          )),
        ];
      }
    ));

    if (!(await Permission.manageExternalStorage.isGranted)) {
      await Permission.manageExternalStorage.request();
    }

    final directories = await getExternalStorageDirectories(type: StorageDirectory.downloads);
    final dir = directories != null ? directories.first : (await getApplicationDocumentsDirectory());
    final infoCEPdir = Directory(path.join(dir.path, 'InfoCEP'));
    final fmt = DateFormat('dd_MM_yyyy_HH_mm_ss');

    if (!infoCEPdir.existsSync()) {
      await infoCEPdir.create(recursive: true);
    }

    final file = File(path.join(infoCEPdir.path, 'relatorio_${fmt.format(DateTime.now())}.pdf'));
    await file.writeAsBytes(await pdf.save());

    return file;
  }

}