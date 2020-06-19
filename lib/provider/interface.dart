import 'package:flutter_blue/flutter_blue.dart';

abstract class BluetoothInterface {
  Future<bool> get isOn;

  Future<bool> get isAvailable;

  Stream<List<ScanResult>> get scanResults;

  void startScan();
}

class FlutterBlueInterface implements BluetoothInterface {
  FlutterBlue flutterBlue;
  FlutterBlueInterface() {
    flutterBlue = FlutterBlue.instance;
  }

  @override
  Future<bool> get isAvailable => flutterBlue.isAvailable;

  @override
  Future<bool> get isOn => flutterBlue.isOn;

  @override
  Stream<List<ScanResult>> get scanResults => flutterBlue.scanResults;

  @override
  void startScan() => flutterBlue.startScan();
}
