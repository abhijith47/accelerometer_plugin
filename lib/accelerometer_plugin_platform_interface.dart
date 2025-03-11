import 'package:plugin_platform_interface/plugin_platform_interface.dart';

import 'accelerometer_plugin_method_channel.dart';

abstract class AccelerometerPluginPlatform extends PlatformInterface {
  /// Constructs a AccelerometerPluginPlatform.
  AccelerometerPluginPlatform() : super(token: _token);

  static final Object _token = Object();

  static AccelerometerPluginPlatform _instance = MethodChannelAccelerometerPlugin();

  /// The default instance of [AccelerometerPluginPlatform] to use.
  ///
  /// Defaults to [MethodChannelAccelerometerPlugin].
  static AccelerometerPluginPlatform get instance => _instance;

  /// Platform-specific implementations should set this with their own
  /// platform-specific class that extends [AccelerometerPluginPlatform] when
  /// they register themselves.
  static set instance(AccelerometerPluginPlatform instance) {
    PlatformInterface.verifyToken(instance, _token);
    _instance = instance;
  }

  Future<String?> getPlatformVersion() {
    throw UnimplementedError('platformVersion() has not been implemented.');
  }
}
