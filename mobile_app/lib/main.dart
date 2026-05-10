import 'dart:math';
import 'package:flutter/material.dart';

void main() {
  runApp(const GeofenceApp());
}

class GeofenceApp extends StatelessWidget {
  const GeofenceApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Geofence Demo',
      theme: ThemeData.from(colorScheme: ColorScheme.fromSeed(seedColor: Colors.blue)),
      home: const GeofencePage(),
    );
  }
}

class GeofencePage extends StatefulWidget {
  const GeofencePage({super.key});

  @override
  State<GeofencePage> createState() => _GeofencePageState();
}

class _GeofencePageState extends State<GeofencePage> {
  final _centerLatCtrl = TextEditingController(text: '17.3850');
  final _centerLngCtrl = TextEditingController(text: '78.4867');
  final _radiusCtrl = TextEditingController(text: '500'); // meters

  final _pointLatCtrl = TextEditingController(text: '17.3890');
  final _pointLngCtrl = TextEditingController(text: '78.4867');

  String _resultText = 'Enter values and tap Check Fence';
  Color _resultColor = Colors.grey;

  double _parseOrThrow(String s) {
    final v = double.tryParse(s.trim());
    if (v == null) {
      throw FormatException('Invalid number: "$s"');
    }
    return v;
  }

  // Haversine distance
  double getDistanceMeters(
    double lat1,
    double lon1,
    double lat2,
    double lon2,
  ) {
    const r = 6371.0; // km
    final phi1 = lat1 * pi / 180.0;
    final phi2 = lat2 * pi / 180.0;
    final dphi = (lat2 - lat1) * pi / 180.0;
    final dlambda = (lon2 - lon1) * pi / 180.0;

    final a = pow(sin(dphi / 2), 2).toDouble() +
        cos(phi1) * cos(phi2) * pow(sin(dlambda / 2), 2).toDouble();
    final c = 2 * atan2(sqrt(a), sqrt(1 - a));
    final distanceKm = r * c;
    return distanceKm * 1000.0;
  }

  void _checkFence() {
    setState(() {
      try {
        final centerLat = _parseOrThrow(_centerLatCtrl.text);
        final centerLng = _parseOrThrow(_centerLngCtrl.text);
        final radiusM = _parseOrThrow(_radiusCtrl.text);

        final pointLat = _parseOrThrow(_pointLatCtrl.text);
        final pointLng = _parseOrThrow(_pointLngCtrl.text);

        if (radiusM < 0) {
          throw ArgumentError.value(radiusM, 'radiusM', 'radius must be >= 0');
        }

        final distM = getDistanceMeters(centerLat, centerLng, pointLat, pointLng);
        final inside = distM <= radiusM;

        _resultColor = inside ? Colors.green : Colors.red;
        _resultText = inside
            ? 'INSIDE ✅\nDistance: ${distM.toStringAsFixed(1)} m (radius ${radiusM.toStringAsFixed(1)} m)'
            : 'OUTSIDE ❌\nDistance: ${distM.toStringAsFixed(1)} m (radius ${radiusM.toStringAsFixed(1)} m)';
      } catch (e) {
        _resultColor = Colors.orange;
        _resultText = 'Error: $e';
      }
    });
  }

  Widget _field({
    required String label,
    required TextEditingController controller,
    required String hint,
  }) {
    return TextField(
      controller: controller,
      keyboardType: TextInputType.number,
      decoration: InputDecoration(
        labelText: label,
        hintText: hint,
        border: const OutlineInputBorder(),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Circular Geofence Checker'),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const Text(
                'Geofence definition',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 10),
              _field(label: 'Center Latitude', controller: _centerLatCtrl, hint: 'e.g. 17.3850'),
              const SizedBox(height: 10),
              _field(label: 'Center Longitude', controller: _centerLngCtrl, hint: 'e.g. 78.4867'),
              const SizedBox(height: 10),
              _field(label: 'Radius (meters)', controller: _radiusCtrl, hint: 'e.g. 500'),
              const SizedBox(height: 20),
              const Text(
                'Point to test',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 10),
              _field(label: 'Point Latitude', controller: _pointLatCtrl, hint: 'e.g. 17.3890'),
              const SizedBox(height: 10),
              _field(label: 'Point Longitude', controller: _pointLngCtrl, hint: 'e.g. 78.4867'),
              const SizedBox(height: 20),
              ElevatedButton.icon(
                onPressed: _checkFence,
                icon: const Icon(Icons.safety_check_outlined),
                label: const Text('Check Fence'),
              ),
              const SizedBox(height: 16),
              Container(
                padding: const EdgeInsets.all(14),
                decoration: BoxDecoration(
                  color: _resultColor.withOpacity(0.12),
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: _resultColor),
                ),
                child: Text(
                  _resultText,
                  style: TextStyle(
                    color: _resultColor,
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
              const SizedBox(height: 10),
              const Text(
                'Note: This UI currently uses manual latitude/longitude inputs (no device GPS).',
                style: TextStyle(color: Colors.black54, fontSize: 12),
              ),
            ],
          ),
        ),
      ),
    );
  }
}


