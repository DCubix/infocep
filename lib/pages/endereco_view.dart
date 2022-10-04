import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter/services.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:infocep/models/endereco.dart';
import 'package:infocep/widgets/app_title.dart';
import 'package:infocep/widgets/info_endereco.dart';
import 'package:latlong2/latlong.dart';
import 'package:url_launcher/url_launcher.dart';

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
    final theme = Theme.of(context);
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: const AppTitle(title: 'Visualizar'),
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

          Align(
            alignment: Alignment.bottomCenter,
            child: Card(
              margin: const EdgeInsets.all(16.0),
              elevation: 6.0,
              clipBehavior: Clip.antiAlias,
              shape: const RoundedRectangleBorder(
                borderRadius: BorderRadius.all(Radius.circular(12)),
              ),
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 12.0),
                decoration: BoxDecoration(
                  border: Border(
                    left: BorderSide(
                      color: theme.primaryColor,
                      width: 12.0,
                    ),
                  ),
                ),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    InfoEndereco(endereco: widget.endereco),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        IconButton(
                          color: theme.primaryColor,
                          visualDensity: VisualDensity.compact,
                          onPressed: () async {
                            final e = widget.endereco;
                            await Clipboard.setData(ClipboardData(
                              text: 'https://www.google.com/maps/?t=k&q=${e.latitude},${e.longitude}'
                            ));
                          },
                          icon: const Icon(Icons.copy_rounded),
                          tooltip: 'Copiar Link',
                        ),
                        IconButton(
                          color: theme.primaryColor,
                          visualDensity: VisualDensity.compact,
                          onPressed: () async {
                            final e = widget.endereco;
                            final url = Uri.parse('https://www.google.com/maps/dir/?api=1&destination=${e.latitude},${e.longitude}&travelmode=driving&dir_action=navigate');
                            if (await canLaunchUrl(url)) {
                              await launchUrl(url);
                            }
                          },
                          icon: const Icon(Icons.navigation_rounded),
                          tooltip: 'Ir Para Navegação',
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
