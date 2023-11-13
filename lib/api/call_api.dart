import 'package:dio/dio.dart';

import '../model/currency.dart';

class ApiCaller {
  Future<List<Currency>> fetchCurrencyData() async {
    final dio = Dio();

    try {
      final response = await dio.get(
        'https://api.currencyapi.com/v3/latest?apikey=cur_live_h9pU88fdw0y9PbFPy56BKp26Gj1bcKoGqY1ir6c0',
      );

      if (response.statusCode == 200) {
        dynamic responseData = response.data;

        if (responseData is List) {
          // If the response is a list, parse each item as a Currency
          List<Currency> currencyList = responseData
              .map((jsonData) => Currency.fromJson(jsonData))
              .toList();
          return currencyList;
        } else if (responseData is Map<String, dynamic>) {
          // If the response is a map, assume it's a single Currency
          Currency currency = Currency.fromJson(responseData);
          return [currency];
        } else {
          throw Exception('Invalid response format');
        }
      } else {
        throw Exception('Failed to load data: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Failed to load data: $e');
    }
  }
}
