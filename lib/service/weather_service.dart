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
  // Verificar e solicitar permissão para acessar a localização
  LocationPermission permission = await Geolocator.checkPermission();
  if (permission == LocationPermission.denied) {
    permission = await Geolocator.requestPermission();
    if (permission != LocationPermission.whileInUse && permission != LocationPermission.always) {
      return 'Permissão de localização negada'; // Retorna se a permissão for negada
    }
  }

  try {
    // Obter a posição atual do usuário
    Position position = await Geolocator.getCurrentPosition(desiredAccuracy: LocationAccuracy.high);
    print('Coordenadas: Latitude ${position.latitude}, Longitude ${position.longitude}'); // Imprime as coordenadas

    // Usar a API de geocodificação para obter o nome da cidade
    List<Placemark> placemarks = await placemarkFromCoordinates(position.latitude, position.longitude);

    if (placemarks.isNotEmpty) {
      // Tente obter a cidade ou um dos outros nomes se a cidade estiver vazia
      String? city = placemarks[0].locality ?? placemarks[0].administrativeArea ?? placemarks[0].subAdministrativeArea;
      print('Cidade encontrada: $city'); // Imprime a cidade encontrada
      return city ?? "Cidade não encontrada"; // Retorna a cidade ou uma mensagem
    } else {
      return "Cidade não encontrada"; // Se a lista de placemarks estiver vazia
    }
  } catch (e) {
    print('Erro ao obter a cidade: $e'); // Captura e imprime qualquer erro
    return "Erro ao obter a cidade";
  }
}
}