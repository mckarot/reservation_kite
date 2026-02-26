import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';

class Weather {
  final DateTime date;
  final int weatherCode;
  final double maxTemperature;
  final double windSpeed;

  Weather({
    required this.date,
    required this.weatherCode,
    required this.maxTemperature,
    required this.windSpeed,
  });

  factory Weather.fromJson(Map<String, dynamic> json, int index) {
    return Weather(
      date: DateTime.parse(json['daily']['time'][index]),
      weatherCode: (json['daily']['weathercode'][index] as num).toInt(),
      maxTemperature: (json['daily']['temperature_2m_max'][index] as num).toDouble(),
      windSpeed: (json['daily']['windspeed_10m_max'][index] as num).toDouble(),
    );
  }
}

class WeatherService {
  static const String _baseUrl = 'https://api.open-meteo.com/v1/forecast';
  static const double _latitude = 14.54;
  static const double _longitude = -60.83;

  Future<Weather> getWeatherForDate(DateTime date) async {
    final formattedDate = DateFormat('yyyy-MM-dd').format(date);
    final url = Uri.parse(
        '$_baseUrl?latitude=$_latitude&longitude=$_longitude&daily=weathercode,temperature_2m_max,windspeed_10m_max&start_date=$formattedDate&end_date=$formattedDate&timezone=auto');

    final response = await http.get(url);

    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      return Weather.fromJson(data, 0);
    } else {
      throw Exception('Failed to load weather data');
    }
  }
}
