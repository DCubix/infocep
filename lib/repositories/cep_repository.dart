import 'dart:convert';

import 'package:infocep/models/endereco.dart';
import 'package:http/http.dart' as http;
import 'package:infocep/utils.dart';
import 'package:string_similarity/string_similarity.dart';

class CEPRepository {

  static Future<Result<Endereco>> buscaPorCEP(String cep) async {
    final res = await http.get(Uri.parse('https://brasilapi.com.br/api/cep/v2/$cep'));
    if (res.statusCode == 200) {
      return Result.success(Endereco.fromBrasilAPI(json.decode(res.body)));
    } else if (res.statusCode == 404) {
      return Result.error(message: 'Endereço não encontrado.');
    }
    
    return Result.error(message: 'Erro desconhecido.');
  }

  static Future<Result<List<Endereco>>> buscaPorEndereco(String busca) async {
    // faz uma busca usando a API Nominatim de Forward Geocoding
    final url = Uri.parse('https://nominatim.openstreetmap.org/search?country=BR&format=json&addressdetails=1&limit=5&accept-language=pt-BR&q=$busca');
    final res = await http.get(url);
    if (res.statusCode == 200) {
      final obj = json.decode(res.body) as List;
      if (obj.isEmpty) {
        return Result.error(message: 'Endereço não encontrado.');
      }
      return Result.success(obj.map((e) => Endereco.fromNominatimAPI(e)).where((e) => e.cep.isNotEmpty).toList());
    }
    return Result.error(message: 'Erro ao buscar endereço. Por favor, tente novamente.');
  }

  static Future<Result<List<Endereco>>> buscaUnificada(String busca) async {
    final cepRegex = RegExp(r'([0-9]{8})|([0-9]{5}\-[0-9]{3})');
    if (cepRegex.hasMatch(busca)) {
      final cepRes = await buscaPorCEP(busca);
      if (cepRes.type == ResultType.success) {
        return Result.success([cepRes.data!]);
      } else {
        return Result.error(message: cepRes.message);
      }
    }
    return buscaPorEndereco(busca);
  }

}