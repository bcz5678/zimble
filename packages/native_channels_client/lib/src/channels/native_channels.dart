import 'package:equatable/equatable.dart';
import 'package:flutter/services.dart';


class NativeChannels{
  NativeChannels();

  MethodChannel bluetoothMethod = MethodChannel("mtg_rfid_method/device/bt_devices");
  EventChannel bluetoothEventStream = EventChannel('mtg_rfid_event/device/bt_stream');


}