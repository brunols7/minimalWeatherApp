import 'dart:convert';
import 'package:weather/models/weather_modal.dart';
import 'package:geolocator/geolocator.dart';
import 'package:geocoding/geocoding.dart';
import 'package:http/http.dart' as http;

class WeatherService {

  static const BASE_URL = 'https://api.openweathermap.org/data/2.5/weather';
  final String apiKey;

  WeatherService({required this.apiKey});

  Future<Weather> getWeather(String cityName) async{
    final response = await http.get(Uri.parse('$BASE_URL?q=$cityName&appid=$apiKey&units=metric'));
    print('Request URL: ${response.request?.url}');

    if(response.statusCode == 200){
      return Weather.fromJson(jsonDecode((response.body)));
    }else{
      throw Exception('Error fetching weather');
    }
  }

  Future<String> getCurrentCity() async {

  LocationPermission permission = await Geolocator.checkPermission();
  if (permission == LocationPermission.denied) {
    permission = await Geolocator.requestPermission();
    if (permission != LocationPermission.whileInUse && permission != LocationPermission.always) {
      return 'Permissão de localização negada'; 
    }
  }

  try {
    
    Position position = await Geolocator.getCurrentPosition(desiredAccuracy: LocationAccuracy.high);
    print('Coordenadas: Latitude ${position.latitude}, Longitude ${position.longitude}'); 

    
    List<Placemark> placemarks = await placemarkFromCoordinates(position.latitude, position.longitude);

    if (placemarks.isNotEmpty) {
      
      String? city = placemarks[0].locality ?? placemarks[0].administrativeArea ?? placemarks[0].subAdministrativeArea;
      print('Cidade encontrada: $city'); 
      return city ?? "Cidade não encontrada"; 
    } else {
      return "Cidade não encontrada"; 
    }
  } catch (e) {
    print('Erro ao obter a cidade: $e'); 
    return "Erro ao obter a cidade";
  }
}
}