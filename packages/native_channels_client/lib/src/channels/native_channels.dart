import 'package:flutter/services.dart';


class NativeChannels{
  NativeChannels();

  MethodChannel bluetoothMethod = MethodChannel("mtg_rfid_method/device/bt_devices");
  EventChannel bluetoothEventStream = EventChannel('mtg_rfid_event/device/bt_stream');

  MethodChannel sensorMethod = MethodChannel('mtg_rfid_method/reader/sensor_method');
  EventChannel  sensorAccelerometerStream = EventChannel('mtg_rfid_event/reader/sensor_stream_accelerometer');
  EventChannel  sensorGyroscopeStream = EventChannel('mtg_rfid_event/reader/sensor_stream_gyroscope');
  EventChannel  sensorLinearAccelerationStream = EventChannel('mtg_rfid_event/reader/sensor_stream_linear_acceleration');
  EventChannel  sensorRotationVectorStream = EventChannel('mtg_rfid_event/reader/sensor_stream_rotation_vector');

  MethodChannel tagScanMethod = MethodChannel('mtg_rfid_method/reader/tag_scan_method');
  EventChannel  tagScanStream = EventChannel('mtg_rfid_event/reader/tag_scan_stream');
}