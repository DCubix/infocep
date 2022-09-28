import 'package:infocep/utils.dart';

class Endereco {

  String cep, estado, cidade, bairro, rua;
  double latitude, longitude;
  DateTime dataRegistro;
  final bool possuiCoordenadas;

  Endereco({
    required this.cep,
    required this.estado,
    required this.cidade,
    required this.bairro,
    required this.rua,
    required this.latitude,
    required this.longitude,
    required this.dataRegistro,
    this.possuiCoordenadas = true
  });

  factory Endereco.fromAPI(JSON ob) {
    final possuiCoordenadas = ((ob['location'] as JSON)['coordinates'] as JSON).containsKey('latitude'); 
    final obj = Endereco(
      cep: ob['cep'],
      estado: ob['state'],
      cidade: ob['city'],
      bairro: ob['neighborhood'],
      rua: ob['street'],
      latitude: 0,
      longitude: 0,
      possuiCoordenadas: possuiCoordenadas,
      dataRegistro: DateTime.now(),
    );

    if (possuiCoordenadas) {
      obj.latitude = ob['location']['coordinates']['latitude'];
      obj.longitude = ob['location']['coordinates']['longitude'];
    }

    return obj;
  }

  factory Endereco.fromInternal(JSON ob) => Endereco(
    cep: ob['cep'],
    estado: ob['estado'],
    cidade: ob['cidade'],
    bairro: ob['bairro'],
    rua: ob['rua'],
    latitude: ob['latitude'],
    longitude: ob['longitude'],
    possuiCoordenadas: ob['possuiCoordenadas'],
    dataRegistro: ob['dataRegistro'],
  );

  toInternal() => {
    'cep': cep,
    'estado': estado,
    'cidade': cidade,
    'bairro': bairro,
    'rua': rua,
    'latitude': latitude,
    'longitude': longitude,
    'possuiCoordenadas': possuiCoordenadas,
    'dataRegistro': dataRegistro
  };

}