import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:no_more_waste/dto/product_description.dart';

class BarcodeService {
  static final _instance = BarcodeService._internal();

  BarcodeService._internal();

  static BarcodeService get instance {
    return _instance;
  }

  Future<ProductDescription> fetchProductDescription(String barcode) async {
    final response = await http.get(Uri.parse(
        'https://api.barcodelookup.com/v3/products?barcode=$barcode&formatted=y&key=ozody87k05yzbc4pm9kjly18z4hj9n'));
    if (response.statusCode == 200) {

      // If the server did return a 200 OK response,
      // then parse the JSON.
      ProductDescription productDescription = ProductDescription.fromJson(jsonDecode(response.body));
      return productDescription;
    } else {
      // If the server did not return a 200 OK response,
      // then throw an exception.
      throw Exception('Failed to load product name');
    }
  }

}
