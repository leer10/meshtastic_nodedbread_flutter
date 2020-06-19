import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart' as Foundation;
import 'package:flutter_blue/flutter_blue.dart';
import 'package:meshtastic_nodedbread_flutter/provider/provider.dart';
import 'package:provider/provider.dart';

import 'fakeimplementation.dart';
import 'interface.dart';

enum BluetoothLogicState { off, on, unset, unavailable }

class BluetoothLogic with ChangeNotifier {
  BluetoothInterface flutterBlue;
  BluetoothLogicState bluetoothState = BluetoothLogicState.unset;
  var scanResults;

  BluetoothLogic() {
    const isFake = true; //change to false/true to get in and out of fake
    if (Foundation.kDebugMode && isFake) {
      flutterBlue = FakeInterface();
    } else {
      flutterBlue = FlutterBlueInterface();
    }
    checkForBluetooth();
  }

  void searchBluetooth() {
    notifyListeners();
  }

  void scanBluetooth() {
    flutterBlue.startScan();

    var subscription = flutterBlue.scanResults.listen((results) {
      scanResults = results;
      print(results);
      notifyListeners();
    });
  }

  void checkForBluetooth() async {
    if (!await flutterBlue.isAvailable) {
      bluetoothState = BluetoothLogicState.unavailable;
      print("bt unavailable");
      notifyListeners();
    }
    if (!await flutterBlue.isOn) {
      bluetoothState = BluetoothLogicState.off;
      print("bt off");
      notifyListeners();
    }
    if (await flutterBlue.isOn) {
      bluetoothState = BluetoothLogicState.on;
      print("bt on");
      notifyListeners();
      scanBluetooth();
    }
  }
}
