import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:weather_app/secret.dart';

class WeatherService {
  Future<Map<String, dynamic>?> getCurrentWeather(String cityName) async {
    try {
      final url = Uri.parse(
        'http://api.openweathermap.org/data/2.5/forecast?q=$cityName&APPID=$openWeatherAPIKey',
      );
      final res = await http.get(url);

      if (res.statusCode == 200 || res.statusCode == 201) {
        final data = jsonDecode(res.body);
        print(data);
        return data;
      } else {
        return null;
      }
    } catch (e, stackTrace) {
      print('Error Code: $e');
      print(('Stack Trace: $stackTrace'));
      return null;
    }
  }
}
