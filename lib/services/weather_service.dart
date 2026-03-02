import 'dart:convert';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';

class Weather {
  final DateTime date;
  final int weatherCode;
  final double maxTemperature;
  final double windSpeed;
  final double windDirection;

  Weather({
    required this.date,
    required this.weatherCode,
    required this.maxTemperature,
    required this.windSpeed,
    required this.windDirection,
  });

  factory Weather.fromJson(Map<String, dynamic> json, int index) {
    return Weather(
      date: DateTime.parse(json['daily']['time'][index]),
      weatherCode: (json['daily']['weathercode'][index] as num).toInt(),
      maxTemperature: (json['daily']['temperature_2m_max'][index] as num).toDouble(),
      windSpeed: (json['daily']['windspeed_10m_max'][index] as num).toDouble(),
      windDirection: (json['daily']['winddirection_10m_dominant'][index] as num).toDouble(),
    );
  }
}

class CurrentWeather {
  final double temperature;
  final double windSpeed;
  final double windDirection;
  final int weatherCode;

  CurrentWeather({
    required this.temperature,
    required this.windSpeed,
    required this.windDirection,
    required this.weatherCode,
  });

  factory CurrentWeather.fromJson(Map<String, dynamic> json) {
    final currentWeather = json['current_weather'];
    return CurrentWeather(
      temperature: (currentWeather['temperature'] as num).toDouble(),
      windSpeed: (currentWeather['windspeed'] as num).toDouble(),
      windDirection: (currentWeather['winddirection'] as num).toDouble(),
      weatherCode: (currentWeather['weathercode'] as num).toInt(),
    );
  }
}

class WeatherService {
  static const String _baseUrl = 'https://api.open-meteo.com/v1/forecast';
  
  // Coordonnées par défaut (fallback)
  static const double _defaultLatitude = 14.54;
  static const double _defaultLongitude = -60.83;
  
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  /// Récupère les coordonnées depuis Firestore
  Future<Map<String, double>> _getCoordinates() async {
    try {
      final doc = await _firestore
          .collection('settings')
          .doc('school_config')
          .get();

      if (doc.exists && doc.data() != null) {
        final data = doc.data()!;
        final latitude = data['weather_latitude'] as double?;
        final longitude = data['weather_longitude'] as double?;

        if (latitude != null && longitude != null) {
          return {'latitude': latitude, 'longitude': longitude};
        }
      }
    } catch (e) {
      // En cas d'erreur, utiliser les coordonnées par défaut
      print('Erreur lecture coordonnées: $e');
    }

    // Fallback aux coordonnées par défaut
    return {
      'latitude': _defaultLatitude,
      'longitude': _defaultLongitude,
    };
  }

  Future<Weather> getWeatherForDate(DateTime date) async {
    final coords = await _getCoordinates();
    final formattedDate = DateFormat('yyyy-MM-dd').format(date);
    final url = Uri.parse(
        '$_baseUrl?latitude=${coords['latitude']}&longitude=${coords['longitude']}&daily=weathercode,temperature_2m_max,windspeed_10m_max,winddirection_10m_dominant&start_date=$formattedDate&end_date=$formattedDate&timezone=auto');

    final response = await http.get(url);

    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      return Weather.fromJson(data, 0);
    } else {
      throw Exception('Failed to load weather data');
    }
  }

  Future<CurrentWeather> getCurrentWeather() async {
    final coords = await _getCoordinates();
    final url = Uri.parse(
        '$_baseUrl?latitude=${coords['latitude']}&longitude=${coords['longitude']}&current_weather=true&timezone=auto');

    final response = await http.get(url);

    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      return CurrentWeather.fromJson(data);
    } else {
      throw Exception('Failed to load current weather data');
    }
  }
}