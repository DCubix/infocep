import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:get/get.dart';
import 'package:infocep/controllers/endereco_controller.dart';
import 'package:infocep/models/endereco.dart';
import 'package:infocep/repositories/endereco_repository.dart';
import 'package:infocep/utils.dart';
import 'package:infocep/widgets/app_title.dart';
import 'package:infocep/widgets/busca_field.dart';
import 'package:latlong2/latlong.dart';
import 'package:sweetsheet/sweetsheet.dart';

class BuscarEnderecoPage extends StatefulWidget {
  const BuscarEnderecoPage({super.key});

  @override
  State<BuscarEnderecoPage> createState() => _BuscarEnderecoPageState();
}

class _BuscarEnderecoPageState extends State<BuscarEnderecoPage> {

  final _ctrl = MapController();

  final SweetSheet _sweetSheet = SweetSheet();

  Marker? _marker;

  _updateMarker(LatLng point) {
    setState(() {
      _marker = Marker(
        point: point,
        width: 40.0,
        height: 40.0,
        anchorPos: AnchorPos.exactly(Anchor(26.2, 3.4)),
        builder: (_) => Image.asset('assets/pin.png'),
        rotate: false,
      );
    });
  }

  _mostraInfoEndereco(Endereco endereco) {
    final theme = Theme.of(context);
    _sweetSheet.show(
      context: context,
      title: Text(endereco.titulo, style: const TextStyle(fontSize: 22.0, color: Colors.black, fontWeight: FontWeight.w400)),
      description: Text(endereco.subtitulo, style: TextStyle(fontSize: 16.0, color: Colors.grey[600])),
      color: CustomSheetColor(
        main: Colors.white,
        accent: theme.primaryColor,
        icon: theme.primaryColor,
      ),
      positive: SweetSheetAction(
        title: 'Salvar',
        icon: Icons.save_alt_rounded,
        onPressed: () {
          final ctrl = Get.find<EnderecoController>();
          ctrl.salvar(endereco);
          Navigator.pop(context);
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: const AppTitle(title: 'Buscar',),
      ),
      backgroundColor: Colors.grey[200],
      body: Stack(
        children: [
          FlutterMap(
            mapController: _ctrl,
            options: MapOptions(
              center: LatLng(-14.4086569, -51.31668),
              zoom: 4,
              rotation: 0.0,
              rotationThreshold: 0,

              onTap: (tapPosition, point) async {
                _updateMarker(point);

                final res = await EnderecoRepository.buscaReversa(point);
                if (res.type == ResultType.success) {
                  _mostraInfoEndereco(res.data!);
                }
              },
            ),
            children: [
              TileLayer(
                urlTemplate: 'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
                userAgentPackageName: 'com.diegolopes.infocep',
              ),

              MarkerLayer(
                rotate: false,
                markers: [
                  if (_marker != null) _marker!,
                ],
              ),
            ],
          ),

          BuscaField(
            onSelected: (e) {
              if (e.possuiCoordenadas) {
                final pos = LatLng(e.latitude, e.longitude);
                _updateMarker(pos);
                _ctrl.move(pos, 12.0);
              }
              _mostraInfoEndereco(e);
            },
          ),
        ],
      ),
    );
  }
}
