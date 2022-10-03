import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:infocep/models/endereco.dart';
import 'package:infocep/widgets/app_title.dart';
import 'package:latlong2/latlong.dart';

class EnderecoViewPage extends StatefulWidget {
  const EnderecoViewPage({ required this.endereco, super.key});

  final Endereco endereco;

  @override
  State<EnderecoViewPage> createState() => _EnderecoViewPageState();
}

class _EnderecoViewPageState extends State<EnderecoViewPage> {

  final _ctrl = MapController();
  Marker? _marker;

  _updateMarker(LatLng point) {
    _ctrl.move(point, 14.0);
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

  @override
  void initState() {
    super.initState();
    SchedulerBinding.instance.addPostFrameCallback((timeStamp) async {
      _updateMarker(LatLng(widget.endereco.latitude, widget.endereco.longitude));
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: const AppTitle(title: 'Visualizar'),
      ),
      backgroundColor: Colors.grey[200],
      body: FlutterMap(
        mapController: _ctrl,
        options: MapOptions(
          center: LatLng(-14.4086569, -51.31668),
          zoom: 4,
          rotation: 0.0,
          rotationThreshold: 180,
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
    );
  }
}
