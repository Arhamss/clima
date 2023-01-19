import 'package:http/http.dart';
import 'dart:convert';

class NetworkHelper {
  NetworkHelper.copy(this.url1, this.url2, this.cityName, this.apiKey);
  NetworkHelper(this.url1, this.url2, this.lat, this.long, this.apiKey);
  final String url1, url2, apiKey;
  String? cityName;
  double? long;
  double? lat;

  Future GetForecastData() async {
    try {
      var url = Uri.https(url1, url2, {
        'lat': lat.toString(),
        'lon': long.toString(),
        'appid': apiKey,
        'units': 'metric',
      });
      var response = await get(url);
      if (response.statusCode == 200) {
        String data = response.body;
        return jsonDecode(data);
      }
    } catch (e) {
      print(e.toString());
    }
  }

  Future GetAirData() async {
    try {
      var url = Uri.https(url1, url2, {
        'lat': lat.toString(),
        'lon': long.toString(),
        'appid': apiKey,
      });
      var response = await get(url);
      if (response.statusCode == 200) {
        String data = response.body;
        return jsonDecode(data);
      }
    } catch (e) {
      print(e.toString());
    }
  }

  Future GetNewData() async {
    var url = Uri.https(url1, url2, {
      'q': cityName,
      'appid': apiKey,
      'units': 'metric',
    });
    var response = await get(url);
    if (response.statusCode == 200) {
      String data = response.body;
      return jsonDecode(data);
    } else {
      print(response.statusCode);
    }
  }

  Future GetData() async {
    try {
      var url = Uri.https(url1, url2, {
        'lat': lat.toString(),
        'lon': long.toString(),
        'appid': apiKey,
        'units': 'metric',
      });
      var response = await get(url);
      if (response.statusCode == 200) {
        String data = response.body;
        return jsonDecode(data);
      }
    } catch (e) {
      print(e.toString());
    }
  }
}
