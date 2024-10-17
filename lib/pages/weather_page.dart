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

  final _weatherService = WeatherService(apiKey: '1166f8029099d6af11a96ed832e610c1');
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

            Text('São Paulo, SP - Brasil'),
          // Text(_weather?.cityName ?? 'carregando cidade...'),

          Lottie.asset('assets/nublado.json', width: 100, height: 100),

          Text('24ºC')

          // Text('${_weather?.temperature.round()}ºC'),
        
        ],
      ),
      ),
    );
  }
}