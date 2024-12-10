import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/alert_model.dart';
import '../providers/alert_provider.dart';
import '../providers/map_provider.dart';
import 'forecast_screen.dart';

class MapScreen extends StatefulWidget {
  const MapScreen({Key? key}) : super(key: key);

  @override
  _MapScreenState createState() => _MapScreenState();
}

class _MapScreenState extends State<MapScreen> {
  @override
  void initState() {
    super.initState();
    _loadData();
  }

  // Function to load both shapes and alerts data
  Future<void> _loadData() async {
    final mapProvider = Provider.of<MapProvider>(context, listen: false);
    final alertProvider = Provider.of<AlertProvider>(context, listen: false);

    // Load shapes and alerts concurrently
    await Future.wait([
      mapProvider.loadShapes(),
      alertProvider.loadAlerts(),
    ]);
  }

  @override
  Widget build(BuildContext context) {
    final mapProvider = Provider.of<MapProvider>(context);
    final alertProvider = Provider.of<AlertProvider>(context);

    return Scaffold(
      appBar: AppBar(title: const Text('Map Visualization')),
      body: mapProvider.isLoading || alertProvider.isLoading
          ? const Center(child: CircularProgressIndicator())
          : mapProvider.shapes == null || mapProvider.shapes!.result.features.isEmpty
          ? Center(
        child: ElevatedButton(
          onPressed: _loadData, // Button to load data if it's null
          child: const Text('Load Map and Alert Data'),
        ),
      )
          : ListView.builder(
        itemCount: mapProvider.shapes!.result.features.length,
        itemBuilder: (context, index) {
          final feature = mapProvider.shapes!.result.features[index];
          final properties = feature.properties;

          return Card(
            margin: const EdgeInsets.all(8.0),
            child: ListTile(
              title: Text(
                properties.admin3Name,
                style: const TextStyle(fontWeight: FontWeight.bold),
              ),
              subtitle: Text('Code: ${properties.admin3Pcod}'),
              onTap: () {
                // Find the upazilaId by matching admin3Pcod with adm3Pcode
                final matchingAlert = alertProvider.alerts.firstWhere(
                      (alert) => alert.adm3Pcode == int.tryParse(properties.admin3Pcod),
                  orElse: () => Result(
                    parameterId: 0,
                    upazilaId: 0,
                    adm3Pcode: 0,
                    adm2Pcode: 0,
                    district: '',
                    name: '',
                    forecastDate: DateTime.now(),
                    stepStart: DateTime.now(),
                    stepEnd: DateTime.now(),
                    valMin: 0,
                    valAvg: 0,
                    valMax: 0,
                  ),
                );

                final upazilaId = matchingAlert.upazilaId;

                if (upazilaId == 0) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('No matching upazilaId found!')),
                  );
                  return;
                }

                // Navigate to ForecastScreen with the upazilaId
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => ForecastScreen(upazilaId: upazilaId),
                  ),
                );
              },
            ),
          );
        },
      ),
    );
  }
}
