import 'package:http/http.dart' as http;
import 'dart:convert';

class MetalService {
  static Future<Map<String, double>> fetchMetalPrices() async {
    final response = await http.get(
      Uri.parse(
          'https://api.metalpriceapi.com/v1/latest?api_key=39f2dc490c217c60570b4255b896c67f&base=USD&currencies=EUR,USD,PHP'),
    );

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body)['rates'];
      final Map<String, double> prices = {};
      data.forEach((key, value) {
        prices[key] = value.toDouble();
      });
      return prices;
    } else {
      throw Exception('Failed to load metal prices');
    }
  }
}
