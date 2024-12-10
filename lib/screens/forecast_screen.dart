import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';

import '../models/shape_model.dart';
import '../models/forecast_model.dart';
import '../providers/forecast_provider.dart';
import '../utils/color_utils.dart';
import '../utils/error_handler.dart';

class ForecastScreen extends StatelessWidget {
  final ShapeModel selectedLocation;

  const ForecastScreen({Key? key, required this.selectedLocation})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('10 Day Forecast - ${selectedLocation.name}'),
        centerTitle: true,
      ),
      body: Consumer<ForecastProvider>(
        builder: (context, forecastProvider, child) {
          // Loading state
          if (forecastProvider.isLoading) {
            return Center(
              child: CircularProgressIndicator(),
            );
          }

          // Error state
          if (forecastProvider.error != null) {
            return ErrorHandler.buildErrorWidget(
              forecastProvider.error!.toString(),
            );
          }

          // No forecast data
          if (forecastProvider.forecastData.isEmpty) {
            return Center(
              child: Text('No forecast data available'),
            );
          }

          // Forecast list view
          return ListView.builder(
            itemCount: forecastProvider.forecastData.length,
            itemBuilder: (context, index) {
              final forecast = forecastProvider.forecastData[index];
              return _buildForecastCard(forecast);
            },
          );
        },
      ),
    );
  }

  Widget _buildForecastCard(ForecastModel forecast) {
    // Determine color based on temperature
    final backgroundColor = ColorUtils.getAlertColor(forecast.temperature);
    final textColor = ColorUtils.getContrastTextColor(backgroundColor);

    return Container(
      margin: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      decoration: BoxDecoration(
        gradient: ColorUtils.getAlertGradient(forecast.temperature),
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black26,
            blurRadius: 6,
            offset: Offset(0, 4),
          ),
        ],
      ),
      child: Padding(
        padding: EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Date
            Text(
              DateFormat('EEEE, MMM d').format(forecast.date),
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: textColor,
              ),
            ),
            SizedBox(height: 8),

            // Temperature details
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                // Current Temperature
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      '${forecast.temperature.toStringAsFixed(1)}°C',
                      style: TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.w600,
                        color: textColor,
                      ),
                    ),
                    Text(
                      'Current Temp',
                      style: TextStyle(
                        fontSize: 12,
                        color: textColor.withOpacity(0.8),
                      ),
                    ),
                  ],
                ),

                // Min and Max Temperature
                Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Text(
                      'High: ${forecast.maxTemperature.toStringAsFixed(1)}°C',
                      style: TextStyle(color: textColor),
                    ),
                    Text(
                      'Low: ${forecast.minTemperature.toStringAsFixed(1)}°C',
                      style: TextStyle(color: textColor),
                    ),
                  ],
                ),
              ],
            ),
            SizedBox(height: 12),

            // Additional Weather Details
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                _buildDetailItem(
                  Icons.water_drop_outlined,
                  '${forecast.humidity.toStringAsFixed(0)}%',
                  'Humidity',
                  textColor,
                ),
                _buildDetailItem(
                  Icons.air,
                  '${forecast.windSpeed.toStringAsFixed(1)} km/h',
                  'Wind',
                  textColor,
                ),
                _buildDetailItem(
                  Icons.text_snippet_outlined,
                  forecast.description,
                  'Condition',
                  textColor,
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  // Reusable method to build detail items
  Widget _buildDetailItem(
      IconData icon,
      String value,
      String label,
      Color textColor,
      ) {
    return Column(
      children: [
        Icon(icon, color: textColor, size: 20),
        SizedBox(height: 4),
        Text(
          value,
          style: TextStyle(
            color: textColor,
            fontSize: 12,
            fontWeight: FontWeight.w600,
          ),
        ),
        Text(
          label,
          style: TextStyle(
            color: textColor.withOpacity(0.8),
            fontSize: 10,
          ),
        ),
      ],
    );
  }
}