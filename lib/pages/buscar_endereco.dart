import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:infocep/models/endereco.dart';
import 'package:infocep/repositories/endereco_repository.dart';
import 'package:infocep/utils.dart';
import 'package:infocep/widgets/app_title.dart';
import 'package:infocep/widgets/bottom_dialog.dart';
import 'package:infocep/widgets/busca_field.dart';
import 'package:infocep/widgets/info_endereco.dart';
import 'package:latlong2/latlong.dart';

class BuscarEnderecoPage extends StatefulWidget {
  const BuscarEnderecoPage({super.key});

  @override
  State<BuscarEnderecoPage> createState() => _BuscarEnderecoPageState();
}

class _BuscarEnderecoPageState extends State<BuscarEnderecoPage> {

  final _bottomSheetKey = GlobalKey<ScaffoldState>();
  final _ctrl = MapController();
  late PersistentBottomSheetController _sheetCtrl;

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
    _sheetCtrl = _bottomSheetKey.currentState!.showBottomSheet(
      (context) => Card(
        margin: const EdgeInsets.all(16.0),
        elevation: 6.0,
        clipBehavior: Clip.antiAlias,
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(24)),
        ),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 12.0),
          child: InfoEndereco(endereco: endereco),
        ),
      ),
      backgroundColor: Colors.transparent,
      elevation: 0.0,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _bottomSheetKey,
      appBar: AppBar(
        centerTitle: true,
        title: const AppTitle(title: 'Buscar CEP',),
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
              rotationThreshold: 180,

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
