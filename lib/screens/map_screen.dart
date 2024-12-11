import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import 'package:provider/provider.dart';
import '../models/alert_model.dart';
import '../providers/map_provider.dart';
import '../providers/alert_provider.dart';
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

  // Load shapes and alerts data
  Future<void> _loadData() async {
    final mapProvider = Provider.of<MapProvider>(context, listen: false);
    final alertProvider = Provider.of<AlertProvider>(context, listen: false);

    await Future.wait([
      mapProvider.loadShapes(),
      alertProvider.loadAlerts(),
    ]);
  }

  @override
  Widget build(BuildContext context) {
    final mapProvider = Provider.of<MapProvider>(context);
    final alertProvider = Provider.of<AlertProvider>(context);

    if (mapProvider.isLoading || alertProvider.isLoading) {
      return Scaffold(
        appBar: AppBar(title: const Text('Bangladesh Map')),
        body: const Center(child: CircularProgressIndicator()),
      );
    }

    if (mapProvider.shapes == null || mapProvider.shapes!.result.features.isEmpty) {
      return Scaffold(
        appBar: AppBar(title: const Text('Bangladesh Map')),
        body: Center(
          child: ElevatedButton(
            onPressed: _loadData,
            child: const Text('Load Map Data'),
          ),
        ),
      );
    }

    return Scaffold(
      appBar: AppBar(title: const Text('Bangladesh Map')),
      body: Padding(
        padding: const EdgeInsets.all(18.0),
        child: FlutterMap(
          options: MapOptions(
            initialCenter: LatLng(23.6850, 90.3563), // Approximate center of Bangladesh
            initialZoom: 7.0,
            minZoom: 6.5,
            maxZoom: 10.0,
            onTap: (tapPosition, point) {
              _handleMapTap(point, mapProvider, alertProvider);
            },
          ),
          children: [
            TileLayer(
              urlTemplate: 'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
              userAgentPackageName: 'com.example.app',
            ),
            PolygonLayer(
              polygons: _buildPolygons(mapProvider, alertProvider),
            ),
          ],
        ),
      ),
    );
  }

  // Handle map taps to check for polygon intersection
  void _handleMapTap(LatLng point, MapProvider mapProvider, AlertProvider alertProvider) {
    for (var feature in mapProvider.shapes!.result.features) {
      final coordinates = feature.geometry.coordinates;

      // Flatten coordinates into LatLng list
      final latLngList = coordinates.expand((polygon) {
        return polygon.map((point) => LatLng(point[1], point[0]));
      }).toList();

      // Check if tapped point is inside the polygon
      if (_isPointInPolygon(point, latLngList)) {
        // Find corresponding alert
        final matchingAlert = alertProvider.alerts.firstWhere(
              (alert) => alert.adm3Pcode == int.tryParse(feature.properties.admin3Pcod),
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

        if (matchingAlert.upazilaId != 0) {
          // Navigate to ForecastScreen with upazilaId
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => ForecastScreen(upazilaId: matchingAlert.upazilaId),
            ),
          );
        } else {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('No forecast available for ${feature.properties.admin3Name}')),
          );
        }
        return;
      }
    }

    // If no polygon was tapped
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('No region found at tapped location.')),
    );
  }

  // Check if a point is inside a polygon
  bool _isPointInPolygon(LatLng point, List<LatLng> polygon) {
    int i, j;
    bool inside = false;

    // Iterate through all the points of the polygon
    for(i = 0; i<polygon.length; i++){
      for (j = polygon.length - 1; j < polygon.length; j++) {
        // Check if the point is inside the polygon using the ray-casting algorithm
        if ((polygon[i].latitude > point.latitude) != (polygon[j].latitude > point.latitude) &&
            point.longitude < (polygon[j].longitude - polygon[i].longitude) *
                (point.latitude - polygon[i].latitude) /
                (polygon[j].latitude - polygon[i].latitude) +
                polygon[i].longitude) {
          inside = !inside;
        }
      }
    }
    return inside;
  }


  List<Polygon> _buildPolygons(MapProvider mapProvider, AlertProvider alertProvider) {
    final polygons = <Polygon>[];

    for (var feature in mapProvider.shapes!.result.features) {
      final coordinates = feature.geometry.coordinates;

      try {
        // Flatten coordinates and convert to LatLng
        final latLngList = coordinates.expand((polygon) {
          return polygon.map((point) {
            // Ensure each point is a List with exactly two elements (longitude, latitude)
            if (point.length == 2) {
              return LatLng(point[1], point[0]); // Latitude, Longitude
            } else {
              throw Exception('Invalid point format: $point');
            }
          });
                }).toList();

        // Match alert data for coloring and details
        final matchingAlert = alertProvider.alerts.firstWhere(
              (alert) => alert.adm3Pcode == int.tryParse(feature.properties.admin3Pcod),
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

        // Assign color based on alert
        final color = _getAlertColor(matchingAlert.valAvg);

        // Add polygon to the list
        polygons.add(
          Polygon(
            points: latLngList,
            borderColor: Colors.black,
            color: color.withOpacity(.3),
            isFilled: true,
            borderStrokeWidth: 2.0,
          ),
        );
      } catch (e) {
        debugPrint('Error processing feature: ${feature.properties.admin3Name}, $e');
      }
    }

    return polygons;
  }


  Color _getAlertColor(double value) {
    if (value > 10) return const Color(0xFF008000); // No Alert (Green)
    if (value > 8) return const Color(0xFF7BB31A); // Mild (Light Green)
    if (value > 6) return const Color(0xFFEEDB00); // Moderate (Yellow)
    if (value > 4) return const Color(0xFFFFA500); // Severe (Orange)
    return const Color(0xFFB22222); // Extreme (Red)
  }
}
