import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
// ignore: unused_import
import 'package:sensors_plus/sensors_plus.dart';
import 'geolocation_service.dart';
import 'accelerometer_service.dart';
import 'accelerometer_pattern_detector.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(
        primarySwatch: Colors.green,
      ),
      debugShowCheckedModeBanner: false,
      home: AccelerometerExample(),
    );
  }
}

class AccelerometerExample extends StatefulWidget {
  const AccelerometerExample({Key? key}) : super(key: key);

  @override
  State<AccelerometerExample> createState() => _AccelerometerExampleState();
}

class _AccelerometerExampleState extends State<AccelerometerExample> {
  late AccelerometerService _accelerometerService;
  late AccelerometerPatternDetector _patternDetector;
  List<String> detectedPatterns = [];

  @override
  void initState() {
    super.initState();
    _accelerometerService = AccelerometerService();
    _patternDetector = AccelerometerPatternDetector();
    _accelerometerService.startListening();
    _patternDetector.startDetection(_accelerometerService.accelerometerStream);
    _patternDetector.patternStream.listen((pattern) {
      setState(() {
        detectedPatterns.add(pattern);
      });
    });
  }

  @override
  void dispose() {
    _accelerometerService.stopListening();
    _patternDetector.stopDetection();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Accelerometer Example'),
      ),
      body: ListView.builder(
        itemCount: detectedPatterns.length,
        itemBuilder: (context, index) {
          return ListTile(
            title: Text(detectedPatterns[index]),
            subtitle: FutureBuilder<Position?>(
              future: GeolocationService.getCurrentLocation(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return Text('Fetching GPS...');
                }
                if (snapshot.hasError) {
                  return Text('Error fetching GPS: ${snapshot.error}');
                }
                if (snapshot.hasData && snapshot.data != null) {
                  return Text(
                      'GPS: ${snapshot.data!.latitude}, ${snapshot.data!.longitude}');
                }
                return Text('Unknown GPS');
              },
            ),
          );
        },
      ),
    );
  }
}
