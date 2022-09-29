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

  static Future<Result<Endereco>> buscaPorEndereco(String busca) async {
    // faz uma busca usando a API Nominatim de Forward Geocoding
    final url = Uri.parse('https://nominatim.openstreetmap.org/search?country=BR&format=json&addressdetails=1&polygon_geojson=1&accept-language=pt-BR&q=$busca');
    final res = await http.get(url);
    if (res.statusCode == 200) {
      final obj = json.decode(res.body) as List;
      if (obj.isEmpty) {
        // Faz o fallback para busca por CEP
        return buscaPorCEP(busca);
      }

      // Múltiplos resultados são gerados
      // logo, devemos buscar o que mais se encaixa na busca.
      // Para isso, usamos um cálculo de similaridade.
      final enderecosRetornados = obj.map((e) => e['display_name'] as String).toList();
      final melhorResultado = busca.bestMatch(enderecosRetornados);

      // Precisamos agora obter o objeto referente a este endereço.
      final enderecoObject = obj.firstWhere((e) => e['display_name'] == melhorResultado);
      return Result.success(Endereco.fromNominatimAPI(enderecoObject));
    }
    return Result.error(message: 'Erro ao buscar endereço. Por favor, tente novamente.');
  }

}