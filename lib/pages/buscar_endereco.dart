import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:infocep/models/endereco.dart';
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

  final _ctrl = MapController();

  Marker? _marker;

  _updateMarker(LatLng point) {
    setState(() {
      _marker = Marker(
        point: point,
        width: 40.0,
        height: 40.0,
        anchorPos: AnchorPos.exactly(Anchor(26.2, 3.4)),
        builder: (_) => Image.asset('assets/pin.png'),
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
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

              onTap: (tapPosition, point) {
                _updateMarker(point);
              },
            ),
            children: [
              TileLayer(
                urlTemplate: 'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
                userAgentPackageName: 'com.diegolopes.infocep',
              ),

              MarkerLayer(
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

              // abre tela inferior com informações
              BottomDialog.show(
                context,
                title: 'Informações do Endereço',
                height: 300.0,
                content: InfoEndereco(endereco: e),
                actionsBuilder: (context) => [
                  ElevatedButton.icon(
                    onPressed: () {},
                    icon: const Icon(Icons.save),
                    label: const Text('Salvar'),
                  ),
                ],
              );
            },
          ),
        ],
      ),
    );
  }
}