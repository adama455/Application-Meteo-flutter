import 'package:appmeteo/models/constants.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'dart:convert';
import 'dart:async';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';

import '../widgets/weather_items.dart';

class WeatherPage extends StatefulWidget {
  const WeatherPage({super.key});

  @override
  State<WeatherPage> createState() => _WeatherPageState();
}

class _WeatherPageState extends State<WeatherPage> {
  final String apiKey = '9fb391dbdcfd1d18d4a5cc0f63789377';
  final TextEditingController _cityController = TextEditingController();
  String _city = 'Dakar';
  Map<String, dynamic> _weatherData = {};

  Future<void> _fetchWeatherData(String city) async {
    final response = await http.get(Uri.parse(
        'https://api.openweathermap.org/data/2.5/weather?q=$city&uk&APPID=$apiKey'));
    if (response.statusCode == 200) {
      setState(() {
        _weatherData = json.decode(response.body);
        print("Mes donneee============<" + _weatherData.toString());
      });
    } else {
      throw Exception('Failed to load weather data');
    }
  }

  @override
  void initState() {
    super.initState();
    _fetchWeatherData(_city);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0.0,
        title: Center(child: Text('Application Météo')),
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            TextField(
              controller: _cityController,
              decoration: InputDecoration(
                labelText: 'Enter city',
                suffixIcon: IconButton(
                  icon: Icon(Icons.search),
                  onPressed: () async {
                    setState(() {
                      _city = _cityController.text;
                    });
                    await _fetchWeatherData(_city);
                  },
                ),
              ),
            ),
            SizedBox(height: 20.0),
            _weatherData.isNotEmpty
                ? WeatherInfo(weatherData: _weatherData)
                : CircularProgressIndicator(),
          ],
        ),
      ),
    );
  }
}

class WeatherInfo extends StatelessWidget {
  final Map<String, dynamic> weatherData;
  String currentDate = '';

  WeatherInfo({required this.weatherData});

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    Constants myConstants = Constants();

    //create a shader linear gradient
    // final Shader linearGradient = const LinearGradient(
    //   colors: <Color>[Color(0xff9AC6F3)],
    // ).createShader(const Rect.fromLTWH(0.0, 0.0, 200.0, 70.0));

    final weatherMain = weatherData['weather'][0]['main'];
    final description = weatherData['weather'][0]['description'];
    final temp = (weatherData['main']['temp'] - 273.15)
        .toStringAsFixed(1); // Convert temperature from Kelvin to Celsius
    final temp_min = (weatherData['main']['temp_min'] - 273.15)
        .toStringAsFixed(1); // Convert temperature from Kelvin to Celsius
    final temp_max = (weatherData['main']['temp_max'] - 273.15)
        .toStringAsFixed(1); // Convert temperature from Kelvin to Celsius
    final humidity = weatherData['main']['humidity'].toString();
    final windSpeed = weatherData['wind']['speed'].toString();
    final sunset = weatherData['sys']['sunset'].toString();
    final sunrise = weatherData['sys']['sunrise'].toString();
    final location = weatherData['name'];
    final datee = weatherData['dt'];

    DateTime date = DateTime.now();
    String currentDate = DateFormat('MMMMEEEEd').format(date);
    // final String cityName = weatherData['city']['name'];

    return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Text(
            location,
            style: const TextStyle(fontSize: 30.0, fontWeight: FontWeight.bold),
          ),
          Text(
            currentDate,
            style: TextStyle(fontSize: 16.0, color: Colors.grey),
          ),
          const SizedBox(height: 50.0),
          Container(
            width: size.width,
            height: 200,
            decoration: BoxDecoration(
                color: myConstants.primaryColor,
                borderRadius: BorderRadius.circular(15),
                boxShadow: [
                  BoxShadow(
                    color: myConstants.primaryColor.withOpacity(.5),
                    offset: const Offset(0, 25),
                    blurRadius: 10,
                    spreadRadius: -12,
                  )
                ]),
            child: Stack(
              clipBehavior: Clip.none,
              children: [
                Positioned(
                  top: -40,
                  left: 20,
                  child: Image.asset(
                    'assets/sunny.png',
                    width: 150,
                  ),
                ),
                Positioned(
                    bottom: 30,
                    left: 20,
                    child: Text(
                      weatherMain,
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 20,
                      ),
                    )),
                Positioned(
                    top: 20,
                    right: 20,
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Padding(
                          padding: EdgeInsets.only(top: 4.0),
                          child: Text(
                            temp,
                            style: const TextStyle(
                              fontSize: 60,
                              fontWeight: FontWeight.bold,
                              //foreground: Paint()..shader = linearGradient,
                            ),
                          ),
                        ),
                        const Text(
                          '°',
                          style: TextStyle(
                            fontSize: 40,
                            fontWeight: FontWeight.bold,
                            //foreground: Paint()..shader = linearGradient,
                          ),
                        ),
                      ],
                    ))
              ],
            ),
          ),
          const SizedBox(
            height: 50,
          ),
          Container(
            padding: EdgeInsets.symmetric(horizontal: 40),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                weatherItem(
                  text: 'wind Speed',
                  value: windSpeed,
                  unit: 'Km/h',
                  imageUrl: 'assets/windspeed.png',
                ),
                weatherItem(
                  text: 'humidity',
                  value: humidity,
                  unit: '%',
                  imageUrl: 'assets/humidity.png',
                ),
                weatherItem(
                  text: 'temp_min',
                  value: temp_min,
                  unit: '°C',
                  imageUrl: 'assets/fog.png',
                ),
              ],
            ),
          ),
          const SizedBox(
            height: 20,
          ),
          Container(
            padding: EdgeInsets.symmetric(horizontal: 40),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                weatherItem(
                  text: 'temp_max',
                  value: temp_max,
                  unit: '°C',
                  imageUrl: 'assets/fog.png',
                ),
                weatherItem(
                  text: 'sunrise',
                  value: sunrise,
                  unit: '',
                  imageUrl: 'assets/Sunrise.png',
                ),
                weatherItem(
                  text: 'sunset',
                  value: sunset,
                  unit: '',
                  imageUrl: 'assets/sunset.png',
                ),
              ],
            ),
          ),
          const SizedBox(height: 20),
          Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    'Today',
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
                  ),
                  Text(
                    'Next 5 Days',
                    style: TextStyle(
                        fontWeight: FontWeight.w600,
                        fontSize: 16,
                        color: myConstants.primaryColor),
                  )
                ],
              ),
              const SizedBox(height: 20),
              SizedBox(
                height: 110,
                child: ListView.builder(
                  scrollDirection: Axis.vertical,
                  itemCount: weatherData.length,
                  itemBuilder: (BuildContext context, int index) {
                    // String currentTime =
                    //     DateFormat('HH:mm:ss').format(DateTime.now());
                    // String currentHour = currentTime.substring(0, 2);
                    // String forecastTime =
                    //     weatherData[index]["time"].substring(11, 16);
                    // String forecastHour =
                    //     weatherData[index]["time"].substring(11, 13);

                    // String forecastTemperature =
                    //     weatherData[index]['main']['temp'].round().toString();
                    // final DateTime date = DateTime.fromMillisecondsSinceEpoch(
                    //     weatherData[index]['dt'] * 1000);
                    // final String formattedDate = '${date.day}/${date.month}';
                    return Container(
                      padding: const EdgeInsets.symmetric(vertical: 15),
                      margin: const EdgeInsets.only(right: 20),
                      width: 65,
                      decoration: BoxDecoration(
                          // color: currentHour == forecastHour
                          //     ? Colors.white
                          //     : myConstants.primaryColor,
                          borderRadius:
                              const BorderRadius.all(Radius.circular(50)),
                          boxShadow: [
                            BoxShadow(
                              offset: const Offset(0, 1),
                              blurRadius: 5,
                              color: myConstants.primaryColor.withOpacity(.2),
                            ),
                          ]),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            weatherData[index]['dt'].toString(),
                            // style: TextStyle(
                            //   fontSize: 17,
                            //   color: myConstants.greyColor,
                            //   fontWeight: FontWeight.w500,
                            // ),
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [],
                          )
                        ],
                      ),
                    );
                  },
                ),
              ),
            ],
          ),
        ]);
  }
}
