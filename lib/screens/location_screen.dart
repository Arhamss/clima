import 'package:clima/screens/city_screen.dart';
import 'package:flutter/material.dart';
import 'package:clima/utilities/constants.dart';
import 'package:clima/services/weather.dart';
import 'package:intl/intl.dart';
import 'package:clima/utilities/card.dart';
import 'dart:math';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:gradient_colored_slider/gradient_colored_slider.dart';

double roundDouble(double value, int places) {
  num mod = pow(10.0, places);
  return ((value * mod).round().toDouble() / mod);
}

extension StringCasingExtension on String {
  String toCapitalized() =>
      length > 0 ? '${this[0].toUpperCase()}${substring(1).toLowerCase()}' : '';
  String toTitleCase() => replaceAll(RegExp(' +'), ' ')
      .split(' ')
      .map((str) => str.toCapitalized())
      .join(' ');
}

final List<Color> _colors = [
  const Color.fromARGB(255, 0, 255, 0),
  const Color.fromARGB(255, 183, 255, 0),
  const Color.fromARGB(255, 255, 255, 0),
  const Color.fromARGB(255, 255, 128, 0),
  const Color.fromARGB(255, 255, 0, 0),
];

String readTimestamp(int timestamp) {
  var now = DateTime.now();
  var format = DateFormat('jm');
  var date = DateTime.fromMillisecondsSinceEpoch(timestamp * 1000);
  var diff = now.difference(date);
  var time = '';

  if (diff.inSeconds <= 0 ||
      diff.inSeconds > 0 && diff.inMinutes == 0 ||
      diff.inMinutes > 0 && diff.inHours == 0 ||
      diff.inHours > 0 && diff.inDays == 0) {
    time = format.format(date);
  } else if (diff.inDays > 0 && diff.inDays < 7) {
    if (diff.inDays == 1) {
      time = diff.inDays.toString() + ' DAY AGO';
    } else {
      time = diff.inDays.toString() + ' DAYS AGO';
    }
  } else {
    if (diff.inDays == 7) {
      time = (diff.inDays / 7).floor().toString() + ' WEEK AGO';
    } else {
      time = (diff.inDays / 7).floor().toString() + ' WEEKS AGO';
    }
  }

  return time;
}

class LocationScreen extends StatefulWidget {
  @override
  _LocationScreenState createState() => _LocationScreenState();

  LocationScreen({this.locationWeather, this.airWeather, this.forecastData});
  final airWeather;
  final locationWeather;
  final forecastData;
}

class _LocationScreenState extends State<LocationScreen> {
  WeatherModel wm = WeatherModel();

  int Temperature = 0;
  String weatherID = '';
  String city = '';
  String msg = '';
  String iconURL = '';
  String currday = DateFormat('EEEE').format(DateTime.now());
  String currdate = DateFormat('d').format(DateTime.now());
  String currmonth = DateFormat('LLLL').format(DateTime.now());
  String WeatherMessage = '';
  String minTemp = '';
  String maxTemp = '';
  String Humidity = '';
  String Wind = '';
  int airIndex = 0;
  List<String> timeframe = [];
  List<String> minimumTemp = [];
  List<String> maximumTemp = [];
  List<String> iconList = [];

  void updateUI(var weatherD, var airdata, var forecast) {
    setState(() {
      if (weatherD == null) {
        Temperature = 0;
        city = '';
        msg = 'Unable to fetch weather data';
        weatherID = 'Error';
        return;
      }
      for (int i = 0; i < 7; i++) {
        int time = forecast['list'][i]['dt'];
        String a = readTimestamp(time);
        timeframe.add(a);
      }
      for (int i = 0; i < 7; i++) {
        double temp = forecast['list'][i]['main']['temp_min'];
        minimumTemp.add(temp.toString());
      }
      for (int i = 0; i < 7; i++) {
        double temp = forecast['list'][i]['main']['temp_max'];
        maximumTemp.add(temp.toString());
      }
      for (int i = 0; i < 7; i++) {
        String ic = weatherD['weather'][0]['icon'];
        ic = 'http://openweathermap.org/img/wn/$ic@2x.png';
        iconList.add(ic);
      }
      airIndex = airdata['list'][0]['main']['aqi'];
      Temperature = weatherD['main']['temp'].toInt();
      int WID = weatherD['weather'][0]['id'];
      String cloudIcon = weatherD['weather'][0]['icon'];
      iconURL = 'http://openweathermap.org/img/wn/$cloudIcon@2x.png';
      weatherID = wm.getWeatherIcon(WID);
      city = weatherD['name'];
      String fn = weatherD['weather'][0]['description'];
      WeatherMessage = fn.toTitleCase();
      msg = wm.getMessage(Temperature);
      minTemp = roundDouble(weatherD['main']['temp_min'], 1).toString();
      maxTemp = roundDouble(weatherD['main']['temp_max'], 1).toString();
      Humidity = weatherD['main']['humidity'].toString();
      Wind = weatherD['wind']['speed'].toString();
    });
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    updateUI(widget.locationWeather, widget.airWeather, widget.forecastData);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          image: DecorationImage(
            image: const AssetImage('images/location_background.jpg'),
            fit: BoxFit.cover,
            colorFilter: ColorFilter.mode(
                Colors.white.withOpacity(0.8), BlendMode.dstATop),
          ),
        ),
        constraints: const BoxConstraints.expand(),
        child: SafeArea(
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: <Widget>[
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    TextButton(
                      onPressed: () async {
                        var weatherD = await wm.getLocationWeather();
                        var airdata = await wm.getAirWeather();
                        var forecastD = await wm.getForecastWeather();
                        updateUI(weatherD, airdata, forecastD);
                      },
                      child: const Icon(
                        Icons.near_me,
                        size: 50.0,
                      ),
                    ),
                    Text(
                      '$currday, $currdate $currmonth',
                      style: const TextStyle(
                        fontSize: 20,
                        fontFamily: 'Montserrat',
                      ),
                    ),
                    TextButton(
                      onPressed: () async {
                        var typedCity = await Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) {
                              return CityScreen();
                            },
                          ),
                        );
                        if (typedCity != null) {
                          var newWeatherData =
                              await wm.getNewCityWeather(typedCity);
                          var newAirdata = await wm.getNewAirWeather();
                          var newForecastD = await wm.getNewForecastWeather();
                          print(newForecastD);
                          updateUI(newWeatherData, newAirdata, newForecastD);
                        }
                      },
                      child: const Icon(
                        Icons.location_city,
                        size: 50.0,
                      ),
                    ),
                  ],
                ),
                ItemCard(
                  card: Padding(
                    padding: const EdgeInsets.all(25.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                          children: <Widget>[
                            Column(
                              children: <Widget>[
                                Text(
                                  city,
                                  style: kCityTextStyle,
                                ),
                                const SizedBox(
                                  height: 5,
                                ),
                                Text(
                                  '$Temperature°C',
                                  style: kTempTextStyle,
                                ),
                              ],
                            ),
                            Column(
                              children: <Widget>[
                                Image.network(
                                  iconURL,
                                  height: 100,
                                  width: 100,
                                ),
                                SizedBox(
                                  width:
                                      MediaQuery.of(context).size.width * 0.22,
                                  child: Text(
                                    WeatherMessage,
                                    style: kCityTextStyle,
                                    softWrap: true,
                                    maxLines: 5,
                                  ),
                                ),
                              ],
                            )
                          ],
                        ),
                        const SizedBox(
                          height: 40,
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                          children: <Widget>[
                            Column(
                              children: <Widget>[
                                Text(
                                  '$minTemp°C',
                                  style: kCityTextStyle,
                                ),
                                const SizedBox(
                                  height: 8,
                                ),
                                const Icon(
                                  FontAwesomeIcons.temperatureArrowDown,
                                  size: 25, //Icon Size
                                  color: Colors.white, //Color Of Icon
                                ),
                              ],
                            ),
                            Column(
                              children: <Widget>[
                                Text(
                                  '$maxTemp°C',
                                  style: kCityTextStyle,
                                ),
                                const SizedBox(
                                  height: 8,
                                ),
                                const Icon(
                                  FontAwesomeIcons.temperatureArrowUp,
                                  size: 25, //Icon Size
                                  color: Colors.white, //Color Of Icon
                                ),
                              ],
                            ),
                          ],
                        ),
                        const SizedBox(
                          height: 20,
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                          children: <Widget>[
                            Column(
                              children: <Widget>[
                                Text(
                                  '$Wind m/s',
                                  style: kCityTextStyle,
                                ),
                                const SizedBox(
                                  height: 8,
                                ),
                                const Icon(
                                  FontAwesomeIcons.wind,
                                  size: 25, //Icon Size
                                  color: Colors.white, //Color Of Icon
                                ),
                              ],
                            ),
                            Column(
                              children: <Widget>[
                                Text(
                                  '$Humidity gm³',
                                  style: kCityTextStyle,
                                ),
                                const SizedBox(
                                  height: 8,
                                ),
                                const Icon(
                                  FontAwesomeIcons.droplet,
                                  size: 25, //Icon Size
                                  color: Colors.white, //Color Of Icon
                                ),
                              ],
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
                ItemCard(
                  card: Padding(
                    padding: const EdgeInsets.all(15.0),
                    child: Column(
                      children: <Widget>[
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                          children: <Widget>[
                            SizedBox(
                              width: MediaQuery.of(context).size.width * 0.37,
                            ),
                            Row(
                              children: <Widget>[
                                Text(
                                  'Min',
                                  style: kCityTextStyleB,
                                ),
                                SizedBox(
                                  width:
                                      MediaQuery.of(context).size.width * 0.027,
                                ),
                                const Icon(
                                  FontAwesomeIcons.temperatureArrowDown,
                                  size: 20, //Icon Size
                                  color: Colors.white, //Color Of Icon
                                ),
                              ],
                            ),
                            Row(
                              children: <Widget>[
                                Text(
                                  'Max',
                                  style: kCityTextStyleB,
                                ),
                                SizedBox(
                                  width:
                                      MediaQuery.of(context).size.width * 0.027,
                                ),
                                const Icon(
                                  FontAwesomeIcons.temperatureArrowUp,
                                  size: 20, //Icon Size
                                  color: Colors.white, //Color Of Icon
                                ),
                              ],
                            ),
                          ],
                        ),
                        ListView.builder(
                            itemCount: 5,
                            shrinkWrap: true,
                            itemBuilder: (context, index) {
                              return forecastedRow(
                                  timeframe: timeframe,
                                  minimumTemp: minimumTemp,
                                  maximumTemp: maximumTemp,
                                  i: index,
                                  iconList: iconList);
                            }),
                      ],
                    ),
                  ),
                ),
                ItemCard(
                  card: Padding(
                    padding: const EdgeInsets.all(15.0),
                    child: Column(
                      children: <Widget>[
                        Column(
                          children: <Widget>[
                            Text(
                              'Air Quality',
                              style: kCityTextStyle,
                            ),
                            const SizedBox(
                              height: 8,
                            ),
                            Text(
                              '$airIndex',
                              style: kCityTextStyle,
                            ),
                            const SizedBox(
                              height: 8,
                            ),
                            GradientColoredSlider(
                              value:
                                  airIndex == 1 ? 0.0 : airIndex.toDouble() / 5,
                              barWidth: 4,
                              barSpace: 1,
                              onChangeStart: (double value) {},
                              onChanged: (double value) {
                                setState(() {});
                              },
                              gradientColors: _colors,
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class forecastedRow extends StatelessWidget {
  const forecastedRow({
    Key? key,
    required this.timeframe,
    required this.minimumTemp,
    required this.maximumTemp,
    required this.i,
    required this.iconList,
  }) : super(key: key);

  final List<String> timeframe;
  final List<String> minimumTemp;
  final List<String> maximumTemp;
  final int i;
  final iconList;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(0, 0, 0, 10),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: <Widget>[
          Text(
            timeframe[i],
            style: kCityTextStyle,
          ),
          Image.network(
            iconList[i],
            height: 50,
          ),
          Container(
            child: Text(
              '${minimumTemp[i]}°C',
              style: kCityTextStyle,
            ),
            width: 80,
          ),
          Text(
            '${maximumTemp[i]}°C',
            style: kCityTextStyle,
          ),
        ],
      ),
    );
  }
}
