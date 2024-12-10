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
    // Load forecast data when the screen opens
    _loadForecastData();
  }

  // Function to load forecast data
  Future<void> _loadForecastData() async {
    print("upazilaId: "+ widget.upazilaId.toString());
    final forecastProvider = Provider.of<ForecastProvider>(context, listen: false);
    await forecastProvider.loadForecasts(widget.upazilaId); // Use upazilaId passed to the screen
  }

  @override
  Widget build(BuildContext context) {
    final forecastProvider = Provider.of<ForecastProvider>(context);

    return Scaffold(
      appBar: AppBar(title: Text('10-Day Weather Forecast')),
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
              title: Text(forecast.date, style: const TextStyle(fontWeight: FontWeight.bold)),
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

  IconData _getWeatherIcon(String iconCode) {
    // Return icon based on the weather icon code
    switch (iconCode) {
      case 'Sunny':
        return Icons.wb_sunny;
      case 'cloudy':
        return Icons.cloud;
      case 'rain':
        return Icons.beach_access;
      case 'windy':
        return Icons.air;
      default:
        return Icons.help_outline;
    }
  }
}
