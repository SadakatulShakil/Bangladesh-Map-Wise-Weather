import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../providers/map_provider.dart';
import '../utils/color_utils.dart';
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
    // Load shapes when the screen opens
    _loadShapes();
  }

  // Function to load the shapes data
  Future<void> _loadShapes() async {
    final mapProvider = Provider.of<MapProvider>(context, listen: false);
    await mapProvider.loadShapes();
  }

  @override
  Widget build(BuildContext context) {
    final mapProvider = Provider.of<MapProvider>(context);

    return Scaffold(
      appBar: AppBar(title: const Text('Map Visualization')),
      body: mapProvider.isLoading
          ? const Center(child: CircularProgressIndicator())
          : mapProvider.shapes == null || mapProvider.shapes!.result.features.isEmpty
          ? Center(
        child: ElevatedButton(
          onPressed: _loadShapes, // Button to load data if it's null
          child: const Text('Load Map Data'),
        ),
      )
          : ListView.builder(
        itemCount: mapProvider.shapes!.result.features.length,
        itemBuilder: (context, index) {
          final feature = mapProvider.shapes!.result.features[index];
          final geometry = feature.geometry;
          final properties = feature.properties;

          // Use specific property to determine the color
          // For now, just a placeholder for color logic.
          return Card(
            margin: const EdgeInsets.all(8.0),
            child: ListTile(
              title: Text(
                properties.admin3Name,
                style: const TextStyle(fontWeight: FontWeight.bold),
              ),
              subtitle: Text('Code: ${properties.admin3Pcod}'),
              //tileColor: getAlertColor(temperature), // Example color mapping
              onTap: () {
                // Navigate to ForecastScreen with admin3Pcod as the upazilaId
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => ForecastScreen(
                      upazilaId: int.tryParse('1') ?? 0,
                    ),
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
