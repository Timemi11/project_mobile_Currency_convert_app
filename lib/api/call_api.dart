import 'package:dio/dio.dart';

import '../model/currency.dart';

class ApiCaller {
  Future<List<Currency>> fetchCurrencyData() async {
    final dio = Dio();

    try {
      final response = await dio.get(
        'http://localhost:3000/api',
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
