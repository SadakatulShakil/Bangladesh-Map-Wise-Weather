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
  final List<Map<String, dynamic>> _polygonsWithData = [];

  @override
  void initState() {
    super.initState();
    _loadData();
  }

  Future<void> _loadData() async {
    final mapProvider = Provider.of<MapProvider>(context, listen: false);
    final alertProvider = Provider.of<AlertProvider>(context, listen: false);

    await Future.wait([
      mapProvider.loadShapes(),
      alertProvider.loadAlerts(),
    ]);

    _buildPolygons(mapProvider, alertProvider);
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
              _handleMapTap(point);
            },
          ),
          children: [
            TileLayer(
              urlTemplate: 'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
              userAgentPackageName: 'com.example.app',
            ),
            PolygonLayer(
              polygons: _polygonsWithData.map((data) => data['polygon'] as Polygon).toList(),
            ),
          ],
        ),
      ),
    );
  }

  void _handleMapTap(LatLng point) {
    for (final data in _polygonsWithData) {
      final polygon = data['polygon'] as Polygon;
      if (_isPointInPolygon(point, polygon.points)) {
        final upazilaId = data['upazilaId'];
        final upazila = data['upazilaName'];
        final district = data['districtName'];
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => ForecastScreen(upazilaId: upazilaId, district: district, upazila: upazila),
          ),
        );
        return;
      }
    }
    debugPrint('No polygon found at tapped location.');
  }

  void _buildPolygons(MapProvider mapProvider, AlertProvider alertProvider) {
    _polygonsWithData.clear();

    for (var feature in mapProvider.shapes!.result.features) {
      final coordinates = feature.geometry.coordinates;

      try {
        final latLngList = coordinates.expand((polygon) {
          return polygon.map((point) {
            if (point.length == 2) {
              return LatLng(point[1], point[0]); // Latitude, Longitude
            } else {
              throw Exception('Invalid point format: $point');
            }
          });
        }).toList();

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

        final color = _getAlertColor(matchingAlert.valAvg);

        _polygonsWithData.add({
          'polygon': Polygon(
            points: latLngList,
            borderColor: Colors.black,
            color: color.withOpacity(.3),
            isFilled: true,
            borderStrokeWidth: 2.0,
          ),
          'upazilaId': matchingAlert.upazilaId, // Store upazilaId
          'upazilaName': matchingAlert.name, // Store upazilaName
          'districtName': matchingAlert.district, // Store districtName
        });
      } catch (e) {
        debugPrint('Error processing feature: ${feature.properties.admin3Name}, $e');
      }
    }
  }

  bool _isPointInPolygon(LatLng point, List<LatLng> polygon) {
    bool inside = false;

    for (int i = 0, j = polygon.length - 1; i < polygon.length; j = i++) {
      if ((polygon[i].latitude > point.latitude) !=
          (polygon[j].latitude > point.latitude) &&
          point.longitude <
              (polygon[j].longitude - polygon[i].longitude) *
                  (point.latitude - polygon[i].latitude) /
                  (polygon[j].latitude - polygon[i].latitude) +
                  polygon[i].longitude) {
        inside = !inside;
      }
    }

    return inside;
  }

  Color _getAlertColor(double value) {
    if (value > 10) return const Color(0xFF008000);
    if (value > 8) return const Color(0xFF7BB31A);
    if (value > 6) return const Color(0xFFEEDB00);
    if (value > 4) return const Color(0xFFFFA500);
    return const Color(0xFFB22222);
  }
}

