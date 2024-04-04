// accelerometer_service.dart

import 'dart:async';
import 'package:sensors_plus/sensors_plus.dart';

class AccelerometerService {
  late StreamSubscription<AccelerometerEvent> _accelerometerSubscription;

  // Stream controller to broadcast accelerometer events
  StreamController<AccelerometerEvent> _accelerometerStreamController =
      StreamController.broadcast();

  // Getter for accessing accelerometer stream
  Stream<AccelerometerEvent> get accelerometerStream =>
      _accelerometerStreamController.stream;

  // Method to start listening for accelerometer events
  void startListening() {
    _accelerometerSubscription =
        accelerometerEvents.listen((AccelerometerEvent event) {
      // Add accelerometer event to the stream
      _accelerometerStreamController.add(event);
    });
  }

  // Method to stop listening for accelerometer events
  void stopListening() {
    _accelerometerSubscription.cancel();
    _accelerometerStreamController.close();
  }
}
