import 'dart:convert';
import 'dart:developer';

import 'package:bluetooth_control_path/components/lever/left_lever.dart';
import 'package:bluetooth_control_path/components/lever/right_lever.dart';
import 'package:bluetooth_control_path/constants/constant.dart';
import 'package:bluetooth_control_path/constants/function.dart';
import 'package:bluetooth_control_path/screens/control_pad_page.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_blue/flutter_blue.dart';

class LeverControl extends StatefulWidget {
  static const String name = 'lever_control';
  final BluetoothDevice device;
  const LeverControl({Key? key, required this.device}) : super(key: key);
  @override
  _LeverControl createState() => _LeverControl();
}

class _LeverControl extends State<LeverControl> {
  BluetoothCharacteristic? writeChar;

  void _setup() {
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.landscapeLeft,
      DeviceOrientation.landscapeRight,
    ]);
    SystemChrome.setEnabledSystemUIMode(
      SystemUiMode.immersiveSticky,
    );
  }

  void _connectBluetooth() async {
    await for (BluetoothDeviceState state in widget.device.state) {
      if (state != BluetoothDeviceState.connected) {
        await widget.device.connect();
      }
      var services = await widget.device.discoverServices();
      for (var blueService in services) {
        if (writeChar != null) break;
        for (var blueChar in blueService.characteristics) {
          if (blueChar.properties.write) {
            setState(() {
              writeChar = blueChar;
            });
            _showSnackBarMessage('Device connected!');
            break;
          }
        }
      }
    }
  }

  void _showSnackBarMessage(String msg) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(msg),
      ),
    );
  }

  @override
  void initState() {
    super.initState();
    _setup();
    _connectBluetooth();
  }

  void onUpdate(String data) async {
    print(data);
    if (!AppConstants.writing) {
      print(data);
      try {
        AppConstants.writing = true;
        await writeChar!.write(utf8.encode(data));
        AppConstants.writing = false;
      } catch (e) {
        log(e.toString());
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Expanded(
              child: LeftLever(
            iconSize: 50,
            onUpdate: (String data) => onUpdate(data),
          )),
          Expanded(
              child: RightLever(
            iconSize: 50,
            onUpdate: (String data) => onUpdate(data),
          ))
        ],
      ),
      drawer: drawerBar(context),
    );
  }
}
