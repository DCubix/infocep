import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:infocep/widgets/app_title.dart';
import 'package:latlong2/latlong.dart';

class BuscarEnderecoPage extends StatefulWidget {
  const BuscarEnderecoPage({super.key});

  @override
  State<BuscarEnderecoPage> createState() => _BuscarEnderecoPageState();
}

class _BuscarEnderecoPageState extends State<BuscarEnderecoPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: const AppTitle(title: 'Buscar CEP',),
      ),
      backgroundColor: Colors.grey[200],
      body: FlutterMap(
        options: MapOptions(
          center: LatLng(51.509364, -0.128928),
          zoom: 9.2,
        ),
        children: [
          TileLayer(
            urlTemplate: 'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
            userAgentPackageName: 'com.diegolopes.infocep',
          ),
        ],
      ),
    );
  }
}