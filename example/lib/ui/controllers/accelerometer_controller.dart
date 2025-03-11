import 'dart:async';
import 'package:get/get.dart';
import 'package:flutter/material.dart';
import 'package:accelerometer_plugin/accelerometer_plugin.dart';

class AccelerometerController extends GetxController
    with GetSingleTickerProviderStateMixin {
  Rx<AccelerometerData?> lastReading = Rx<AccelerometerData?>(null);
  RxBool isMonitoring = false.obs;

  late AnimationController animationController;

  StreamSubscription<AccelerometerData>? streamSubscription;

  @override
  void onInit() {
    super.onInit();
    animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 300),
    );
  }

  @override
  void onClose() {
    stopMonitoring();
    animationController.dispose();
    super.onClose();
  }

  void startMonitoring() {
    if (!isMonitoring.value) {
      try {
        streamSubscription =
            AccelerometerPlugin.startAccelerometerUpdates().listen(
          (data) {
            lastReading.value = data;
          },
          onError: (error) {
            debugPrint("Error from accelerometer: $error");
            stopMonitoring();
          },
        );
        isMonitoring.value = true;
        animationController.forward();
      } catch (e) {
        debugPrint("Failed to start accelerometer: $e");
        Get.snackbar(
          'Error',
          'Failed to start accelerometer: $e',
          snackPosition: SnackPosition.BOTTOM,
        );
      }
    }
  }

  void stopMonitoring() {
    if (isMonitoring.value) {
      streamSubscription?.cancel();
      AccelerometerPlugin.stopAccelerometerUpdates();
      isMonitoring.value = false;
      animationController.reverse();
    }
  }
}
