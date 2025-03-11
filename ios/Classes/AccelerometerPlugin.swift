// File: ios/Classes/SwiftAccelerometerPlugin.swift

import Flutter
import UIKit
import CoreMotion

public class SwiftAccelerometerPlugin: NSObject, FlutterPlugin, FlutterStreamHandler {
  private let motionManager = CMMotionManager()
  private var eventSink: FlutterEventSink?
  
  public static func register(with registrar: FlutterPluginRegistrar) {
    let channel = FlutterMethodChannel(name: "com.example/accelerometer", binaryMessenger: registrar.messenger())
    let eventChannel = FlutterEventChannel(name: "com.example/accelerometer_events", binaryMessenger: registrar.messenger())
    
    let instance = SwiftAccelerometerPlugin()
    registrar.addMethodCallDelegate(instance, channel: channel)
    eventChannel.setStreamHandler(instance)
  }
  
  public func handle(_ call: FlutterMethodCall, result: @escaping FlutterResult) {
    switch call.method {
    case "startAccelerometerUpdates":
      result(nil)
    case "stopAccelerometerUpdates":
      stopAccelerometerUpdates()
      result(nil)
    default:
      result(FlutterMethodNotImplemented)
    }
  }
  
  // FlutterStreamHandler protocol methods
  public func onListen(withArguments arguments: Any?, eventSink events: @escaping FlutterEventSink) -> FlutterError? {
    eventSink = events
    startAccelerometerUpdates()
    return nil
  }
  
  public func onCancel(withArguments arguments: Any?) -> FlutterError? {
    stopAccelerometerUpdates()
    eventSink = nil
    return nil
  }
  
  private func startAccelerometerUpdates() {
    if motionManager.isAccelerometerAvailable {
      motionManager.accelerometerUpdateInterval = 0.1 // 10 times per second
      motionManager.startAccelerometerUpdates(to: .main) { [weak self] (data, error) in
        guard let self = self, let data = data, error == nil else { return }
        
        let accelerometerData: [String: Any] = [
          "x": data.acceleration.x,
          "y": data.acceleration.y,
          "z": data.acceleration.z,
          "timestamp": Int(Date().timeIntervalSince1970 * 1000)
        ]
        
        self.eventSink?(accelerometerData)
      }
    } else {
      eventSink?(FlutterError(code: "UNAVAILABLE",
                             message: "Accelerometer not available on this device",
                             details: nil))
    }
  }
  
  private func stopAccelerometerUpdates() {
    if motionManager.isAccelerometerActive {
      motionManager.stopAccelerometerUpdates()
    }
  }
}