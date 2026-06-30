import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Map extends StatefulWidget {
  const Map({super.key});

  @override
  State<Map> createState() => _MapState();
}

class _MapState extends State<Map> {
  late MapController _mapController;
  bool _isLoading = true;
  late LatLng _initialCenter;
  late double _initialZoom;
  final String _latKey = 'map_lat';
  final String _lngKey = 'map_lng';
  final String _zoomKey = 'map_zoom';

  @override
  void initState() {
    super.initState();
    _mapController = MapController();
    _loadSavedPosition();
  }

  Future<void> _loadSavedPosition() async {
    final prefs = await SharedPreferences.getInstance();
    
    final lat = prefs.getDouble(_latKey);
    final lng = prefs.getDouble(_lngKey);
    final zoom = prefs.getDouble(_zoomKey);

    if (lat != null && lng != null && zoom != null) {
      _initialCenter = LatLng(lat, lng);
      _initialZoom = zoom;
    } else {
      _initialCenter = const LatLng(55.7558, 37.6173);
      _initialZoom = 12;
    }

    setState(() {
      _isLoading = false;
    });
    
    _mapController.move(_initialCenter, _initialZoom);
  }

  Future<void> _savePosition(LatLng center, double zoom) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setDouble(_latKey, center.latitude);
    await prefs.setDouble(_lngKey, center.longitude);
    await prefs.setDouble(_zoomKey, zoom);
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      body: Stack(
        children: [
          if (_isLoading)
            Container(
              color: isDark ? Colors.black : Colors.white,
              child: Center(
                child: CircularProgressIndicator(
                  valueColor: AlwaysStoppedAnimation<Color>(
                    Colors.amber[700]!,
                  ),
                ),
              ),
            )
          else
            FlutterMap(
              mapController: _mapController,
              options: MapOptions(
                initialCenter: _initialCenter,
                initialZoom: _initialZoom,
                minZoom: 3,
                maxZoom: 18,
                interactionOptions: const InteractionOptions(
                  flags: InteractiveFlag.all,
                ),
                onPositionChanged: (MapPosition position, bool hasGesture) {
                  if (position.center != null && position.zoom != null) {
                    _savePosition(position.center!, position.zoom!);
                  }
                },
              ),
              children: [
                TileLayer(
                  urlTemplate: isDark
                      ? 'https://{s}.basemaps.cartocdn.com/dark_all/{z}/{x}/{y}{r}.png'
                      : 'https://{s}.basemaps.cartocdn.com/light_all/{z}/{x}/{y}{r}.png',
                  subdomains: const ['a', 'b', 'c'],
                  userAgentPackageName: 'com.example.map_navigator',
                  tileProvider: NetworkTileProvider(),
                ),
              ],
            ),
          Positioned(
            bottom: 20,
            right: 20,
            child: Column(
              children: [
                Container(
                  decoration: BoxDecoration(
                    color: isDark ? Colors.grey[900] : Colors.white,
                    borderRadius: BorderRadius.circular(12),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.1),
                        blurRadius: 10,
                      ),
                    ],
                  ),
                  child: Column(
                    children: [
                      IconButton(
                        icon: Icon(
                          Icons.add,
                          color: isDark ? Colors.white : Colors.black87,
                        ),
                        onPressed: () {
                          final center = _mapController.center;
                          final zoom = _mapController.zoom;
                          _mapController.move(center, zoom + 1);
                        },
                      ),
                      Container(
                        height: 1,
                        width: 30,
                        color: isDark ? Colors.grey[800] : Colors.grey[300],
                      ),
                      IconButton(
                        icon: Icon(
                          Icons.remove,
                          color: isDark ? Colors.white : Colors.black87,
                        ),
                        onPressed: () {
                          final center = _mapController.center;
                          final zoom = _mapController.zoom;
                          _mapController.move(center, zoom - 1);
                        },
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 12),
                Container(
                  decoration: BoxDecoration(
                    color: isDark ? Colors.grey[900] : Colors.white,
                    borderRadius: BorderRadius.circular(12),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.1),
                        blurRadius: 10,
                      ),
                    ],
                  ),
                  child: IconButton(
                    icon: Icon(
                      Icons.my_location,
                      color: isDark ? Colors.white : Colors.black87,
                    ),
                    onPressed: () async {
                      const position = LatLng(55.7558, 37.6173);
                      _mapController.move(position, 14);
                      await _savePosition(position, 14);
                    },
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}