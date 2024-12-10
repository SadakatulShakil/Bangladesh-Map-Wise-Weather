import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shape_wise_map_forecast/providers/alert_provider.dart';
import 'package:shape_wise_map_forecast/providers/forecast_provider.dart';
import 'package:shape_wise_map_forecast/providers/map_provider.dart';
import 'package:shape_wise_map_forecast/screens/map_screen.dart';

void main() {
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => MapProvider()),
        ChangeNotifierProvider(create: (_) => ForecastProvider()),
        ChangeNotifierProvider(create: (_) => AlertProvider()),
      ],
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Weather Forecast App',
      theme: ThemeData(primarySwatch: Colors.blue),
      home: const MapScreen(),
    );
  }
}
