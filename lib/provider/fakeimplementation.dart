import 'package:flutter_blue/flutter_blue.dart';

import 'interface.dart';

class FakeInterface implements BluetoothInterface {
  @override
  Future<bool> get isAvailable => Future.delayed(Duration(
        seconds: 1,
      )).then((value) => true);

  @override
  Future<bool> get isOn => Future.delayed(Duration(
        seconds: 1,
      )).then((value) => true);

  @override
  Stream<List<ScanResult>> get scanResults => _genFakeScanResults();

  Stream<List<ScanResult>> _genFakeScanResults() async* {
    int i = 0;
    while (i == 0) {
      await Future.delayed(Duration(seconds: 1));
      yield [FakeScanResult()];
      i = 1;
    }
  }

  @override
  void startScan() {
    // TODO: implement startScan
  }
}

class FakeScanResult implements ScanResult {
  @override
  AdvertisementData get advertisementData => FakeAdvertisementData();

  @override
  BluetoothDevice get device => FakeDevice();

  @override
  int get rssi => -90;
}

class FakeAdvertisementData implements AdvertisementData {
  @override
  bool get connectable => true;

  @override
  String get localName => "Meshtastic Device";

  @override
  // TODO: implement manufacturerData
  Map<int, List<int>> get manufacturerData => throw UnimplementedError();

  @override
  // TODO: implement serviceData
  Map<String, List<int>> get serviceData => throw UnimplementedError();

  @override
  List<String> get serviceUuids => ["6ba1b218-15a8-461f-9fa8-5dcae273eafd"];

  @override
  // TODO: implement txPowerLevel
  int get txPowerLevel => throw UnimplementedError();
}

class FakeDevice implements BluetoothDevice {
  @override
  // TODO: implement canSendWriteWithoutResponse
  Future<bool> get canSendWriteWithoutResponse => throw UnimplementedError();

  @override
  Future<void> connect({Duration timeout, bool autoConnect = true}) {
    // TODO: implement connect
    throw UnimplementedError();
  }

  @override
  Future disconnect() {
    // TODO: implement disconnect
    throw UnimplementedError();
  }

  @override
  Future<List<BluetoothService>> discoverServices() {
    // TODO: implement discoverServices
    throw UnimplementedError();
  }

  @override
  // TODO: implement id
  DeviceIdentifier get id => FakeDeviceIdentifier();

  @override
  // TODO: implement isDiscoveringServices
  Stream<bool> get isDiscoveringServices => throw UnimplementedError();

  @override
  // TODO: implement mtu
  Stream<int> get mtu => throw UnimplementedError();

  @override
  String get name => "Meshtastic Device";

  @override
  Future<void> requestMtu(int timeout) {
    // TODO: implement requestMtu
    throw UnimplementedError();
  }

  @override
  // TODO: implement services
  Stream<List<BluetoothService>> get services => throw UnimplementedError();

  @override
  // TODO: implement state
  Stream<BluetoothDeviceState> get state => throw UnimplementedError();

  @override
  // TODO: implement type
  BluetoothDeviceType get type => throw UnimplementedError();
}

class FakeDeviceIdentifier implements DeviceIdentifier {
  @override
  String get id => "fakeid";
}
