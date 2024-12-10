import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import 'package:provider/provider.dart';

import '../providers/map_provider.dart';
import '../providers/forecast_provider.dart';
import '../utils/error_handler.dart';
import '../models/shape_model.dart';
import 'forecast_screen.dart';

class MapScreen extends StatefulWidget {
  @override
  _MapScreenState createState() => _MapScreenState();
}

class _MapScreenState extends State<MapScreen> {
  final MapController _mapController = MapController();

  @override
  void initState() {
    super.initState();
    // Fetch map data when screen initializes
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Provider.of<MapProvider>(context, listen: false).fetchMapData();
    });
  }

  void _handleMapTap(ShapeModel selectedLocation) {
    // Navigate to forecast screen when a location is tapped
    Provider.of<ForecastProvider>(context, listen: false)
        .setSelectedUpazila(selectedLocation.id);

    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => ForecastScreen(
          selectedLocation: selectedLocation,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Weather Forecast Map'),
        centerTitle: true,
      ),
      body: Consumer<MapProvider>(
        builder: (context, mapProvider, child) {
          // Handle loading state
          if (mapProvider.isLoading) {
            return Center(
              child: CircularProgressIndicator(),
            );
          }

          // Handle error state
          if (mapProvider.error != null) {
            return ErrorHandler.buildErrorWidget(
              mapProvider.error!.toString(),
            );
          }

          // Main map view
          return FlutterMap(
            mapController: _mapController,
            options: MapOptions(
              initialCenter: LatLng(23.8103, 90.4125), // Bangladesh center
              initialZoom: 7.0,
              minZoom: 5.0,
              maxZoom: 10.0,
            ),
            children: [
              // Base map tile layer
              TileLayer(
                urlTemplate:
                "https://{s}.tile.openstreetmap.org/{z}/{x}/{y}.png",
                subdomains: ['a', 'b', 'c'],
              ),

              // Marker layer for shape locations
              MarkerLayer(
                markers: mapProvider.shapeData.map((location) {
                  return Marker(
                    width: 40.0,
                    height: 40.0,
                    point: LatLng(location.latitude, location.longitude),
                    child: GestureDetector(
                      onTap: () => _handleMapTap(location),
                      child: Container(
                        decoration: BoxDecoration(
                          color: _getLocationColor(location, mapProvider),
                          shape: BoxShape.circle,
                          border: Border.all(
                            color: Colors.white,
                            width: 2,
                          ),
                        ),
                        child: Icon(
                          Icons.location_on,
                          color: Colors.white,
                          size: 30,
                        ),
                      ),
                    ),
                  );
                }).toList(),
              ),
            ],
          );
        },
      ),
    );
  }

  // Determine marker color based on alert data
  Color _getLocationColor(ShapeModel location, MapProvider mapProvider) {
    try {
      final alert = mapProvider.alertData.firstWhere(
            (alert) => alert.id == location.id,
      );
      return mapProvider.getColorForAlert(alert.value);
    } catch (e) {
      return Colors.blue; // Default color if no matching alert found
    }
  }
}