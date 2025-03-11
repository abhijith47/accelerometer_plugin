// File: lib/accelerometer_plugin.dart

import 'dart:async';
import 'package:flutter/services.dart';

class AccelerometerPlugin {
  static const MethodChannel _channel = MethodChannel('com.example/accelerometer');
  static const EventChannel _eventChannel = EventChannel('com.example/accelerometer_events');
  
  static Stream<AccelerometerData>? _accelerometerStream;
  
  /// Starts the accelerometer readings and returns a stream of data
  static Stream<AccelerometerData> startAccelerometerUpdates() {
    if (_accelerometerStream == null) {
      _channel.invokeMethod('startAccelerometerUpdates');
      _accelerometerStream = _eventChannel
          .receiveBroadcastStream()
          .map((dynamic event) => AccelerometerData.fromMap(event));
    }
    
    return _accelerometerStream!;
  }
  
  /// Stops the accelerometer updates
  static Future<void> stopAccelerometerUpdates() async {
    await _channel.invokeMethod('stopAccelerometerUpdates');
    _accelerometerStream = null;
  }
}

/// Class to hold accelerometer data
class AccelerometerData {
  final double x;
  final double y;
  final double z;
  final DateTime timestamp;
  
  AccelerometerData({
    required this.x,
    required this.y,
    required this.z,
    required this.timestamp,
  });
  
  factory AccelerometerData.fromMap(Map<dynamic, dynamic> map) {
    return AccelerometerData(
      x: map['x'],
      y: map['y'],
      z: map['z'],
      timestamp: DateTime.fromMillisecondsSinceEpoch(map['timestamp']),
    );
  }
  
  @override
  String toString() => 'AccelerometerData(x: $x, y: $y, z: $z, timestamp: $timestamp)';
}
