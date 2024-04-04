import 'dart:async';
import 'package:sensors_plus/sensors_plus.dart';

class AccelerometerPatternDetector {
  late StreamSubscription<AccelerometerEvent> _subscription;
  late StreamController<String> _patternController;

  Stream<String> get patternStream => _patternController.stream;

  void startDetection(Stream<AccelerometerEvent> accelerometerStream) {
    _patternController = StreamController<String>();
    _subscription = accelerometerStream.listen((event) {
      _detectPattern(event);
    });
  }

  void stopDetection() {
    _subscription.cancel();
    _patternController.close();
  }

  void _detectPattern(AccelerometerEvent event) {
    double z = event.z;
    double threshold1 = 12;
    double threshold2 = 5;

    if (z <= -threshold2) {
      _patternController
          .add('Pattern detected: -$threshold2 < z <= -$threshold1');
    }
  }
}
