import 'dart:convert';
import 'package:http/http.dart' as http;

Future<List<String>> fetchCountries() async {
  try {
    final response = await http.get(
      Uri.parse('https://restcountries.com/v3.1/all?fields=name'),
    ).timeout(const Duration(seconds: 10));

    if (response.statusCode == 200) {
      final List data = jsonDecode(response.body);
      final countries = data
          .map((e) => e['name']['common'] as String)
          .toList();
      countries.sort();
      print('Loaded ${countries.length} countries');
      return countries;
    } else {
      throw Exception('Status: ${response.statusCode}');
    }
  } catch (e) {
    print('fetchCountries error: $e');
    rethrow;
  }
}