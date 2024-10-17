import 'package:flutter/material.dart';
import 'package:weather/service/weather_service.dart';
import 'package:weather/models/weather_modal.dart';
import 'package:lottie/lottie.dart';


class WeatherPage extends StatefulWidget {
  const WeatherPage({super.key});

  @override
  State<WeatherPage> createState() => _WeatherPageState();
}

class _WeatherPageState extends State<WeatherPage> {

  final _weatherService = WeatherService(apiKey: 'YOUR_API_KEY');
  Weather? _weather;

  _fetchWeather() async {
    final city = await _weatherService.getCurrentCity();
    
    try {
      final weather = await _weatherService.getWeather(city);
      setState(() {
        _weather = weather;
      });
    } catch (e) {
      print(e);
    }
  }

  String getWeatherAnimation(String? mainCondition){
    if (mainCondition == null) return 'assets/sol.json';

    switch (mainCondition.toLowerCase()){
      case 'thunderstorm':
        return 'assets/tempestade.json';
      case 'clear':
        return 'assets/sol.json';
      case 'clouds':
        return 'assets/nublado.json';
      case 'smoke':
        return 'assets/nublado.json';
      case ' rain':
        return 'assets/sol-chuva.json';
      case 'fog':
        return 'assets/nublado.json';
      default:
        return 'assets/sol.json';
    }
  }


  @override
  void initState() {
    super.initState();
    _fetchWeather();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [

            // REMOVE THIS TEXT BELOW, BECAUSE IT'S A STATIC TEXT FOR UI
            Text('São Paulo, SP - Brasil'),

          // USE THIS COMMENT BELOW
          // Text(_weather?.cityName ?? 'carregando cidade...'),

          Lottie.asset(getWeatherAnimation(_weather?.mainCondition),),

          // REMOVE THIS TEXT BELOW, BECAUSE IT'S A STATIC TEXT FOR UI
          Text('24ºC')

          // USE THIS COMMENT BELOW
          // Text('${_weather?.temperature.round()}ºC'),
        
        ],
      ),
      ),
    );
  }
}