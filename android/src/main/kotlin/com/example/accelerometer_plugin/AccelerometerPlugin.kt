// File: android/src/main/kotlin/com/example/accelerometer/AccelerometerPlugin.kt

package com.example.accelerometer_plugin

import android.content.Context
import android.hardware.Sensor
import android.hardware.SensorEvent
import android.hardware.SensorEventListener
import android.hardware.SensorManager
import androidx.annotation.NonNull
import io.flutter.embedding.engine.plugins.FlutterPlugin
import io.flutter.plugin.common.EventChannel
import io.flutter.plugin.common.MethodCall
import io.flutter.plugin.common.MethodChannel
import io.flutter.plugin.common.MethodChannel.MethodCallHandler
import io.flutter.plugin.common.MethodChannel.Result

class AccelerometerPlugin: FlutterPlugin, MethodCallHandler, EventChannel.StreamHandler {
  private lateinit var methodChannel: MethodChannel
  private lateinit var eventChannel: EventChannel
  private lateinit var context: Context
  
  private var sensorManager: SensorManager? = null
  private var accelerometer: Sensor? = null
  private var sensorEventListener: SensorEventListener? = null
  private var eventSink: EventChannel.EventSink? = null
  
  override fun onAttachedToEngine(@NonNull flutterPluginBinding: FlutterPlugin.FlutterPluginBinding) {
    context = flutterPluginBinding.applicationContext
    methodChannel = MethodChannel(flutterPluginBinding.binaryMessenger, "com.example/accelerometer")
    eventChannel = EventChannel(flutterPluginBinding.binaryMessenger, "com.example/accelerometer_events")
    
    methodChannel.setMethodCallHandler(this)
    eventChannel.setStreamHandler(this)
    
    sensorManager = context.getSystemService(Context.SENSOR_SERVICE) as SensorManager
    accelerometer = sensorManager?.getDefaultSensor(Sensor.TYPE_ACCELEROMETER)
  }

  override fun onMethodCall(@NonNull call: MethodCall, @NonNull result: Result) {
    when (call.method) {
      "startAccelerometerUpdates" -> {
        result.success(null)
      }
      "stopAccelerometerUpdates" -> {
        stopListener()
        result.success(null)
      }
      else -> {
        result.notImplemented()
      }
    }
  }

  override fun onListen(arguments: Any?, events: EventChannel.EventSink?) {
    eventSink = events
    startListener()
  }

  override fun onCancel(arguments: Any?) {
    stopListener()
  }

  private fun startListener() {
    if (sensorManager == null || accelerometer == null) {
      eventSink?.error("UNAVAILABLE", "Accelerometer not available on this device", null)
      return
    }
    
    sensorEventListener = object : SensorEventListener {
      override fun onAccuracyChanged(sensor: Sensor?, accuracy: Int) {}
      
      override fun onSensorChanged(event: SensorEvent?) {
        event ?: return
        
        if (event.sensor.type == Sensor.TYPE_ACCELEROMETER) {
          val data = HashMap<String, Any>()
          data["x"] = event.values[0].toDouble()
          data["y"] = event.values[1].toDouble()
          data["z"] = event.values[2].toDouble()
          data["timestamp"] = System.currentTimeMillis()
          
          eventSink?.success(data)
        }
      }
    }
    
    sensorManager?.registerListener(
      sensorEventListener,
      accelerometer,
      SensorManager.SENSOR_DELAY_NORMAL
    )
  }
  
  private fun stopListener() {
    sensorManager?.unregisterListener(sensorEventListener)
    sensorEventListener = null
  }

  override fun onDetachedFromEngine(@NonNull binding: FlutterPlugin.FlutterPluginBinding) {
    methodChannel.setMethodCallHandler(null)
    eventChannel.setStreamHandler(null)
    stopListener()
  }
}