import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shape_wise_map_forecast/screens/map_screen.dart';
import 'providers/map_provider.dart';
import 'providers/forecast_provider.dart';

void main() {
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (context) => MapProvider()),
        ChangeNotifierProvider(create: (context) => ForecastProvider()),
      ],
      child: WeatherForecastApp(),
    ),
  );
}

class WeatherForecastApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Weather Forecast App',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: MapScreen(),
    );
  }
}