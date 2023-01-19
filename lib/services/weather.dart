import 'package:clima/services/location.dart';
import 'package:clima/services/networking.dart';

const url1 = 'api.openweathermap.org';
const url2 = '/data/2.5/weather';
const urlF = '/data/2.5/forecast';
const urlAir = '/data/2.5/air_pollution';
const apiKey = '391579ed5c881ef514be57ccf95cbf1a';
// api.openweathermap.org/data/2.5/forecast?lat={lat}&lon={lon}&appid={API key}
double latitood = 0;
double longitood = 0;
var weatherD;

class WeatherModel {
  Future getForecastWeather() async {
    Locate obj = Locate();
    await obj.getCurrLocation();
    NetworkHelper Nh = NetworkHelper(url1, urlF, obj.lat, obj.long, apiKey);
    latitood = obj.lat;
    longitood = obj.long;
    var weatherData = await Nh.GetForecastData();
    return weatherData;
  }

  Future getNewForecastWeather() async {
    Locate obj = Locate();
    await obj.getCurrLocation();
    double airlong = longitood;
    double airlat = latitood;
    NetworkHelper Nhh = NetworkHelper(url1, urlF, airlat, airlong, apiKey);
    var weatherData = await Nhh.GetForecastData();
    return weatherData;
  }

  Future getNewCityWeather(String cn) async {
    Locate obj = Locate();
    await obj.getCurrLocation();
    NetworkHelper networkH = NetworkHelper.copy(url1, url2, cn, apiKey);
    weatherD = await networkH.GetNewData();
    double airlong = weatherD['coord']['lon'];
    double airlat = weatherD['coord']['lat'];
    NetworkHelper Networktwo =
        NetworkHelper(url1, urlAir, airlat, airlong, apiKey);
    var airData = await Networktwo.GetAirData();
    return weatherD;
  }

  Future getNewAirWeather() async {
    Locate obj = Locate();
    await obj.getCurrLocation();
    double airlong = weatherD['coord']['lon'];
    double airlat = weatherD['coord']['lat'];
    latitood = airlat;
    longitood = airlong;
    NetworkHelper Networktwo =
        NetworkHelper(url1, urlAir, airlat, airlong, apiKey);
    var airData = await Networktwo.GetAirData();
    return airData;
  }

  Future getAirWeather() async {
    Locate obj = Locate();
    await obj.getCurrLocation();
    NetworkHelper networkH =
        NetworkHelper(url1, urlAir, obj.lat, obj.long, apiKey);
    var weatherD = await networkH.GetAirData();
    return weatherD;
  }

  Future getLocationWeather() async {
    Locate obj = Locate();
    await obj.getCurrLocation();
    NetworkHelper Nh = NetworkHelper(url1, url2, obj.lat, obj.long, apiKey);
    latitood = obj.lat;
    longitood = obj.long;
    var weatherData = await Nh.GetData();
    return weatherData;
  }

  String getWeatherIcon(int condition) {
    if (condition < 300) {
      return '🌩';
    } else if (condition < 400) {
      return '🌧';
    } else if (condition < 600) {
      return '☔️';
    } else if (condition < 700) {
      return '☃️';
    } else if (condition < 800) {
      return '🌫';
    } else if (condition == 800) {
      return '☀️';
    } else if (condition <= 804) {
      return '☁️';
    } else {
      return '🤷‍';
    }
  }

  String getMessage(int temp) {
    if (temp > 25) {
      return 'It\'s 🍦 time';
    } else if (temp > 20) {
      return 'Time for shorts and 👕';
    } else if (temp < 10) {
      return 'You\'ll need 🧣 and 🧤';
    } else {
      return 'Bring a 🧥 just in case';
    }
  }
}
