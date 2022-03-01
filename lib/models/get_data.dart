import 'dart:convert';

import 'package:currency/models/currency.dart';
import 'package:http/http.dart' as http;

Future<List<Currency>> getData() async {
  List<Currency> currency = [];
  var url = "http://sasansafari.com/flutter/api.php?access_key=flutter123456";
  var response = await http.get(Uri.parse(url));
  List jsonData = jsonDecode(response.body);
  for (var item in jsonData) {
    currency.add(
      Currency(
        id: item['item'],
        title: item['title'],
        changes: item['changes'],
        price: item['price'],
        status: item['status'],
      ),
    );
  }

  return currency;
}
