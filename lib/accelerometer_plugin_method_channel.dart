import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';

import 'accelerometer_plugin_platform_interface.dart';

/// An implementation of [AccelerometerPluginPlatform] that uses method channels.
class MethodChannelAccelerometerPlugin extends AccelerometerPluginPlatform {
  /// The method channel used to interact with the native platform.
  @visibleForTesting
  final methodChannel = const MethodChannel('accelerometer_plugin');

  @override
  Future<String?> getPlatformVersion() async {
    final version = await methodChannel.invokeMethod<String>('getPlatformVersion');
    return version;
  }
}
