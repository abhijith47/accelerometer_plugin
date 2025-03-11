// ignore_for_file: deprecated_member_use

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/accelerometer_controller.dart';
import '../widgets/accelerometer_widget.dart';

class AccelerometerScreen extends StatelessWidget {
  AccelerometerScreen({super.key});

  // Inject controller
  final AccelerometerController controller = Get.put(AccelerometerController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            children: <Widget>[
              Obx(() => AnimatedContainer(
                    duration: const Duration(milliseconds: 300),
                    padding:
                        const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
                    decoration: BoxDecoration(
                      color: controller.isMonitoring.value
                          ? Colors.green.withOpacity(0.2)
                          : Colors.red.withOpacity(0.2),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Container(
                          width: 12,
                          height: 12,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: controller.isMonitoring.value
                                ? Colors.green
                                : Colors.red,
                          ),
                        ),
                        const SizedBox(width: 8),
                        Text(
                          controller.isMonitoring.value
                              ? 'Monitoring Active'
                              : 'Monitoring Inactive',
                          style: TextStyle(
                            color: controller.isMonitoring.value
                                ? Colors.green
                                : Colors.red,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                  )),

              const SizedBox(height: 24),

              // Title
              const Text(
                'Accelerometer Readings',
                style: TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                'Monitor real-time device motion',
                style: TextStyle(
                  fontSize: 16,
                  color: Colors.grey[600],
                ),
              ),

              const SizedBox(height: 32),

              // Circular meter visualization
              Expanded(
                child: Obx(
                  () => controller.lastReading.value != null
                      ? AccelerometerMeterDisplay(
                          xValue: controller.lastReading.value!.x,
                          yValue: controller.lastReading.value!.y,
                          zValue: controller.lastReading.value!.z,
                          //timestamp: controller.lastReading.value!.timestamp,
                          isActive: controller.isMonitoring.value,
                        )
                      : const Center(
                          child: Text(
                            'No data available',
                            style: TextStyle(
                              fontSize: 18,
                              color: Colors.grey,
                            ),
                          ),
                        ),
                ),
              ),

              // Control buttons
              Container(
                margin: const EdgeInsets.symmetric(vertical: 24),
                child: Obx(() => Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        ElevatedButton.icon(
                          onPressed: controller.isMonitoring.value
                              ? null
                              : controller.startMonitoring,
                          icon: const Icon(Icons.play_arrow),
                          label: const Text('Start'),
                          style: ElevatedButton.styleFrom(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 24, vertical: 12),
                          ),
                        ),
                        ElevatedButton.icon(
                          onPressed: controller.isMonitoring.value
                              ? controller.stopMonitoring
                              : null,
                          icon: const Icon(Icons.stop),
                          label: const Text('Stop'),
                          style: ElevatedButton.styleFrom(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 24, vertical: 12),
                          ),
                        ),
                      ],
                    )),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
