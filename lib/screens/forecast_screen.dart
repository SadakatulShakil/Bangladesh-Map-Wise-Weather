import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/forecast_provider.dart';

class ForecastScreen extends StatefulWidget {
  final int upazilaId;

  const ForecastScreen({Key? key, required this.upazilaId}) : super(key: key);

  @override
  _ForecastScreenState createState() => _ForecastScreenState();
}

class _ForecastScreenState extends State<ForecastScreen> {
  @override
  void initState() {
    super.initState();
    _loadForecastData();
  }

  // Load forecast data based on the upazilaId
  Future<void> _loadForecastData() async {
    final forecastProvider = Provider.of<ForecastProvider>(context, listen: false);
    await forecastProvider.loadForecasts(widget.upazilaId);
  }

  @override
  Widget build(BuildContext context) {
    final forecastProvider = Provider.of<ForecastProvider>(context);

    return Scaffold(
      appBar: AppBar(title: const Text('Weather Forecast')),
      body: forecastProvider.isLoading
          ? const Center(child: CircularProgressIndicator())
          : forecastProvider.forecasts.isEmpty
          ? const Center(child: Text('No forecast data available.'))
          : ListView.builder(
        itemCount: forecastProvider.forecasts.length,
        itemBuilder: (context, index) {
          final forecast = forecastProvider.forecasts[index];

          return Card(
            margin: const EdgeInsets.all(8.0),
            child: ListTile(
              title: Text(
                'Date: ${forecast.date}',
                style: const TextStyle(fontWeight: FontWeight.bold),
              ),
              subtitle: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Day: ${forecast.weekday}'),
                  Text('Rainfall: ${forecast.rf.valAvg} ${forecast.rfUnit}'),
                  Text('Temperature: ${forecast.temp.valAvg} ${forecast.tempUnit}'),
                  Text('Humidity: ${forecast.rh.valAvg} ${forecast.rhUnit}'),
                  Text('Wind Speed: ${forecast.windspd.valAvg} ${forecast.windspdUnit}'),
                  Text('Cloud Cover: ${forecast.cldcvr.valAvg} ${forecast.cldcvrUnit}'),
                  Text('Wind Gust: ${forecast.windgust.valAvg} ${forecast.windgustUnit}'),
                ],
              ),
              leading: Icon(
                _getWeatherIcon(forecast.type),
                size: 40,
                color: Colors.blue,
              ),
            ),
          );
        },
      ),
    );
  }

  // Map weather type to icons
  IconData _getWeatherIcon(String weatherType) {
    switch (weatherType) {
      case 'Sunny':
        return Icons.wb_sunny;
      case 'Cloudy':
        return Icons.cloud;
      case 'Rainy':
        return Icons.beach_access;
      case 'Windy':
        return Icons.air;
      default:
        return Icons.help_outline;
    }
  }
}
