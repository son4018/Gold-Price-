import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: MyScreen(),
    );
  }
}

class MetalPriceWidget extends StatelessWidget {
  final String label;
  final double value;

  MetalPriceWidget({required this.label, required this.value});

  @override
  Widget build(BuildContext context) {
    return Text(
      '${label.toLowerCase()}: $value',
      style: TextStyle(
        fontSize: 18.0,
        fontWeight: FontWeight.bold,
        color: Colors.amber[600],
      ),
    );
  }
}

class MyScreen extends StatefulWidget {
  @override
  _MyScreenState createState() => _MyScreenState();
}

class _MyScreenState extends State<MyScreen> {
  double eurPrice = 0.0;
  double xauPrice = 0.0; // Gold price (XAU)
  double xagPrice = 0.0; // Silver price (XAG)

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        fit: StackFit.expand,
        children: [
          Image.asset(
            'images/222.jpg',
            fit: BoxFit.cover,
          ),
          Positioned(
            top: 180.0,
            left: 120.0,
            child: Image.asset(
              'images/33.png',
              width: 100.0,
              height: 100.0,
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(90),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                MetalPriceWidget(
                  label: 'EUR Price',
                  value: eurPrice,
                ),
                SizedBox(height: 10.0),
                MetalPriceWidget(
                  label: 'Gold (XAU) Price',
                  value: xauPrice,
                ),
                SizedBox(height: 10.0),
                MetalPriceWidget(
                  label: 'Silver (XAG) Price',
                  value: xagPrice,
                ),
                ElevatedButton(
                  onPressed: () {
                    fetchMetalPrices();
                  },
                  child: Text('Fetch Metal Prices'),
                ),
                SizedBox(height: 20.0),
              ],
            ),
          ),
        ],
      ),
    );
  } 

  void fetchMetalPrices() async {
    final apiKey = "39f2dc490c217c60570b4255b896c67f";
    final baseUrl = "https://api.metalpriceapi.com/v1/latest";
    final baseCurrency = "USD";
    final currencies = "EUR,XAU,XAG";

    final url = "$baseUrl?api_key=$apiKey&base=$baseCurrency&currencies=$currencies";

    try {
      final response = await http.get(Uri.parse(url));

      if (response.statusCode == 200) {
        final Map<String, dynamic> data = json.decode(response.body);
        if (data['success']) {
          setState(() {
            eurPrice = 1 / data['rates']['EUR'];
            xauPrice = 1 / (data['rates']['XAU'] ?? 1.0);
            xagPrice = 1 / (data['rates']['XAG'] ?? 1.0);
          });
        } else {
          print('Error: ${data['error']['info']}');
        }
      } else {
        print('Error: ${response.reasonPhrase}');
      }
    } catch (error) {
      print('Error: $error');
    }
  }
}
