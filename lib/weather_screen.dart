import 'dart:ui' show FontWeight, ImageFilter;

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:weather_app/additional_info.dart';
import 'package:weather_app/hourly_forecast.dart';
import 'package:weather_app/weather_service.dart';

class WeatherScreen extends StatefulWidget {
  const WeatherScreen({super.key});

  @override
  State<WeatherScreen> createState() => _WeatherScreenState();
}

class _WeatherScreenState extends State<WeatherScreen> {
  // Future<Map<String, dynamic>> getCurrentWeather() async {
  //   String cityName = 'ladwa';
  //   try {
  //     final url = Uri.parse(
  //       'http://api.openweathermap.org/data/2.5/forecast?q=$cityName&APPID=$openWeatherAPIKey',
  //     );
  //     final res = await http.get(url);
  //     final data = jsonDecode(res.body);
  //
  //     if (data['cod'] != '200') {
  //       throw 'An unexpected error occurred';
  //     }
  //     return data;
  //   } catch (e, stackTrace) {
  //     print('The Error: $e');
  //     print('The stackTrace: $stackTrace');
  //     throw Exception(e);
  //   }
  // }
  final weather = WeatherService();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Weather App',
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),
        centerTitle: true,
        actions: [
          IconButton(
              onPressed: () {
                setState(() {});
              },
              icon: const Icon(Icons.refresh)),
        ],
      ),
      body: FutureBuilder(
        future: weather.getCurrentWeather('ladwa'),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(
              child: CircularProgressIndicator.adaptive(),
            );
          }
          if (snapshot.hasError) {
            return Center(
              child: Text(snapshot.error.toString()),
            );
          }
          final data = snapshot.data!;
          final currentWeatherData = data['list'][0];

          final currentTemp = (currentWeatherData['main']['temp']);
          final currentSky = (currentWeatherData['weather'][0]['main']);
          final currentPressure = (currentWeatherData['main']['pressure']);
          final currentWindSpeed = (currentWeatherData['wind']['speed']);
          final currentHumidity = (currentWeatherData['main']['humidity']);

          return Padding(
            padding: const EdgeInsets.all(12.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(
                  width: double.infinity,
                  child: Card(
                    elevation: 10,
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(16.0)),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(16.0),
                      child: BackdropFilter(
                        filter: ImageFilter.blur(sigmaY: 10, sigmaX: 10),
                        child: Padding(
                          padding: const EdgeInsets.all(16.0),
                          child: Column(
                            children: [
                              Text(
                                '$currentTemp°K',
                                style: const TextStyle(
                                  fontSize: 40,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              const SizedBox(
                                height: 10,
                              ),
                              Icon(
                                currentSky == 'Clouds' || currentSky == 'Rain'
                                    ? Icons.cloud
                                    : Icons.sunny,
                                size: 60,
                              ),
                              const SizedBox(
                                height: 10,
                              ),
                              Text(
                                currentSky,
                                style: const TextStyle(fontSize: 16),
                              )
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
                const SizedBox(
                  height: 28,
                ),
                const Text(
                  'Hourly Forecasting',
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                // const SingleChildScrollView(
                //   scrollDirection: Axis.horizontal,
                //   child: Row(
                //     children: [
                //       HourlyForecast('03:10', Icons.cloud, '10k'),
                //       HourlyForecast('04:10', Icons.cloud, '12k'),
                //       HourlyForecast('05:10', Icons.cloud, '13k'),
                //       HourlyForecast('06:10', Icons.cloud, '15'),
                //       HourlyForecast('07:10', Icons.cloud, '16')
                //     ],
                //   ),
                // ),
                const SizedBox(
                  height: 8.0,
                ),
                SizedBox(
                  height: 105.0,
                  child: ListView.builder(
                    scrollDirection: Axis.horizontal,
                    itemCount: 5,
                    itemBuilder: (context, index) {
                      final hourlyForecastItem = data['list'][index + 1];
                      final hourlySky =
                          data['list'][index + 1]['weather'][0]['main'];
                      final hourlyTemp =
                          hourlyForecastItem['main']['temp'].toString();
                      final time = DateTime.parse(hourlyForecastItem['dt_txt']);
                      return HourlyForecast(
                          DateFormat.j().format(time),
                          hourlySky == 'Clouds' || hourlySky == 'Rain'
                              ? Icons.cloud
                              : Icons.sunny,
                          hourlyTemp);
                    },
                  ),
                ),
                const SizedBox(
                  height: 20.0,
                ),
                const Text(
                  'Additional Info',
                  style: TextStyle(fontSize: 25, fontWeight: FontWeight.bold),
                ),
                const SizedBox(
                  height: 16.0,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    AdditionalInfo(Icons.water_drop, 'Humidity',
                        currentHumidity.toString()),
                    AdditionalInfo(
                        Icons.air, 'Pressure', currentPressure.toString()),
                    AdditionalInfo(Icons.beach_access, 'Wind Speed',
                        currentWindSpeed.toString()),
                  ],
                )
              ],
            ),
          );
        },
      ),
    );
  }
}
