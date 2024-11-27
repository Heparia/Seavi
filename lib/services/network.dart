import 'package:http/http.dart' as http;
import 'dart:convert';

class NetworkHelper {
  NetworkHelper({required this.url});

  final String url;
  final apiKey = 'AIzaSyAHFRGzsB38YMwWyKunU94YZJ2Wtaksm3I';

  Future getData() async {
    String urlApi = '$url&key=$apiKey';
    http.Response response = await http.get(Uri.parse(urlApi));

    if (response.statusCode == 200) {
      String data = response.body;
      return jsonDecode(data);
    } else {
      print(response.statusCode);
    }
  }
}