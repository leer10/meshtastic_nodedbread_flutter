import 'package:flutter/cupertino.dart';
import 'package:flutter_blue/flutter_blue.dart';
import 'package:meshtastic_nodedbread_flutter/provider/provider.dart';
import 'package:provider/provider.dart';

enum BluetoothLogicState { off, on, unset, unavailable }

class BluetoothLogic with ChangeNotifier {
  BluetoothDevice bluetoothDevice;
  FlutterBlue flutterBlue;
  BluetoothLogicState bluetoothState = BluetoothLogicState.unset;
  var scanResults;

  BluetoothLogic() {
    flutterBlue = FlutterBlue.instance;
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
