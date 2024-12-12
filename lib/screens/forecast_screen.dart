import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/forecast_provider.dart';

class ForecastScreen extends StatefulWidget {
  final int upazilaId;
  final String upazila;
  final String district;

  const ForecastScreen({Key? key, required this.upazilaId, required this.upazila, required this.district}) : super(key: key);

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
      appBar: AppBar(
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text('Weather Forecast', style: TextStyle(color: Colors.white),),
            Text(
              "${widget.district}, ${widget.upazila} ⛳",
              style: const TextStyle(fontSize: 12, color: Colors.white),
            ),
          ],
        ),
        backgroundColor: Colors.green,
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      body: forecastProvider.isLoading
          ? const Center(child: CircularProgressIndicator())
          : forecastProvider.forecasts.isEmpty
          ? const Center(child: Text('No forecast data available.'))
          : ListView.builder(
        itemCount: forecastProvider.forecasts.length,
        itemBuilder: (context, index) {
          final forecast = forecastProvider.forecasts[index];

          return Card(
            margin: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12.0),
              side: const BorderSide(color: Colors.green, width: 1.0),
            ),
            color: Colors.green.shade50,
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            forecast.weekday,
                            style: const TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          Text(
                            forecast.date,
                            style: const TextStyle(
                              fontSize: 14,
                              color: Colors.grey,
                            ),
                          ),
                        ],
                      ),
                      Column(
                        children: [
                          Icon(
                            _getWeatherIcon(forecast.type),
                            size: 30,
                            color: Colors.orange,
                          ),
                          Text(
                            forecast.type,
                            style: const TextStyle(fontSize: 14),
                          ),
                        ],
                      ),
                    ],
                  ),
                  const SizedBox(height: 12.0),
                  const Divider(),
                  const SizedBox(height: 8.0),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      _buildForecastDetail(
                        icon: Icons.thermostat,
                        label: 'Temperature',
                        value: "${forecast.temp.valMin}-${forecast.temp.valMax}${forecast.tempUnit}",
                      ),
                      _buildForecastDetail(
                        icon: Icons.water_drop,
                        label: 'Precipitation',
                        value: "${forecast.rf.valAvg}${forecast.rfUnit}",
                      ),
                      _buildForecastDetail(
                        icon: Icons.opacity,
                        label: 'Humidity',
                        value: "${forecast.rh.valAvg}${forecast.rhUnit}",
                      ),
                      _buildForecastDetail(
                        icon: Icons.air,
                        label: 'Wind Speed',
                        value: "${forecast.windspd.valAvg}${forecast.windspdUnit}",
                      ),
                    ],
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildForecastDetail({required IconData icon, required String label, required String value}) {
    return Column(
      children: [
        Icon(
          icon,
          size: 24,
          color: Colors.green,
        ),
        const SizedBox(height: 4.0),
        Text(
          label,
          style: const TextStyle(fontSize: 12, color: Colors.black54),
        ),
        Text(
          value,
          style: const TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
        ),
      ],
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
