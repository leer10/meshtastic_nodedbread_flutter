import 'package:flutter/material.dart';
import 'package:flutter_blue/flutter_blue.dart';
import 'package:meshtastic_nodedbread_flutter/UI/ui.dart';
import 'package:meshtastic_nodedbread_flutter/provider/provider.dart';
import 'package:provider/provider.dart';

class BluetoothSearchView extends StatelessWidget {
  const BluetoothSearchView({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final btState = context.select((BluetoothLogic b) => b.bluetoothState);
    return Scaffold(
        appBar: AppBar(
          title: Text("Search for Devices"),
          actions: <Widget>[
            /*
            //I intended to have a button to manually start scanning on press, but it would raise an exception when it's already scanning. I couldn't figure out how to avoid scanning when already doing so
            if (context.watch<BluetoothLogic>().bluetoothState ==
                BluetoothLogicState.on)
              IconButton(
                icon: Icon(Icons.refresh),
                onPressed: () async {
                  context.read<BluetoothLogic>().scanBluetooth();
                },
              )*/
          ],
        ),
        body:
            (btState == BluetoothLogicState.on) ? SearchBody() : LoadingBody());
  }
}

class SearchBody extends StatelessWidget {
  const SearchBody({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Consumer<BluetoothLogic>(
        builder: (BuildContext context, bluetoothLogic, Widget child) {
          List<ScanResult> value = bluetoothLogic.scanResults;
          if (value != null) {
            return ListView.builder(
              itemCount: value.length,
              itemBuilder: (context, index) {
                final item = value[index];
                bool isMeshtasticDevice = (item.advertisementData.serviceUuids
                    .contains("6ba1b218-15a8-461f-9fa8-5dcae273eafd"));
                return Card(
                  color: isMeshtasticDevice ? Colors.grey[300] : null,
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Column(
                      children: <Widget>[
                        if (isMeshtasticDevice)
                          Text("I am a meshtastic device! 😁"),
                        if (item.device.name.isNotEmpty)
                          Text(item.device.name)
                        else
                          Text("Unnamed device"),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                          children: <Widget>[
                            Text(item.device.id.id),
                            Text(item.rssi.toString())
                          ],
                        ),
                        ...item.advertisementData.serviceUuids
                            .map((e) => Text(e)),
                        RaisedButton(
                          child: Text("Connect"),
                        )
                      ],
                    ),
                  ),
                );
              },
            );
          } else {
            return Center(child: CircularProgressIndicator());
          }
        },
      ),
    );
  }
}

class LoadingBody extends StatelessWidget {
  const LoadingBody({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Stack(
        children: <Widget>[
          Selector<BluetoothLogic, BluetoothLogicState>(
              selector: (_, bluetoothLogic) => bluetoothLogic.bluetoothState,
              builder: (context, value, child) {
                if (value == BluetoothLogicState.off ||
                    value == BluetoothLogicState.unavailable) {
                  WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
                    showDialog(
                        context: context,
                        barrierDismissible: false,
                        builder: (_) => BluetoothErrorDialog(state: value));
                  });
                }
                return SizedBox();
              }),
          Center(
            child: CircularProgressIndicator(),
          ),
        ],
      ),
    );
  }
}

class BluetoothErrorDialog extends StatelessWidget {
  BluetoothErrorDialog({Key key, @required this.state}) : super(key: key);
  final BluetoothLogicState state;
  @override
  Widget build(BuildContext context) {
    return AlertDialog(
        title: Text("Bluetooth Error"),
        content: SingleChildScrollView(
          child: ListBody(
            children: <Widget>[
              if (state == BluetoothLogicState.off) ...[
                Text("Your Bluetooth is turned off"),
                Text("Please turn on and restart")
              ],
              if (state == BluetoothLogicState.unavailable) ...[
                Text("Bluetooth is unavailable to the app")
              ]
            ],
          ),
        ));
  }
}
