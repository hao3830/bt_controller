import 'dart:convert';
import 'dart:developer';

import 'package:bluetooth_control_path/components/button_control.dart';
import 'package:bluetooth_control_path/components/joystick_pad.dart';
import 'package:bluetooth_control_path/constants/constant.dart';
import 'package:bluetooth_control_path/constants/shared_prefs_keys.dart';
import 'package:bluetooth_control_path/constants/function.dart';
import 'package:bluetooth_control_path/screens/profile_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_blue/flutter_blue.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ControlPadPage extends StatefulWidget {
  static const String name = 'control_pad_page';
  Map? prefsKeys;
  final BluetoothDevice device;

  ControlPadPage({
    Key? key,
    prefsKeys,
    required this.device,
  }) : super(key: key) {
    AppConstants.device = device;
  }

  @override
  State<ControlPadPage> createState() => _ControlPadPageState();
}

class _ControlPadPageState extends State<ControlPadPage> {
  SharedPreferences? prefs;
  ButtonControlData? buttonControlData;
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

  // void _reset() {
  //   SystemChrome.setPreferredOrientations([
  //     DeviceOrientation.landscapeLeft,
  //     DeviceOrientation.landscapeRight,
  //     DeviceOrientation.portraitUp,
  //   ]);
  //   SystemChrome.setEnabledSystemUIMode(
  //     SystemUiMode.edgeToEdge,
  //   );
  // }

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

  Widget _buildControlPad() {
    return Column(
      children: [
        Align(
            alignment: Alignment.topRight,
            widthFactor: 7,
            child: ClipRRect(
                borderRadius: BorderRadius.circular(4),
                child: Stack(children: <Widget>[
                  Positioned.fill(
                    child: Container(
                      width: 100,
                      height: 100,
                      decoration: const BoxDecoration(
                        gradient: LinearGradient(
                          colors: <Color>[
                            Color(0xFF0D47A1),
                            Color(0xFF1976D2),
                            Color(0xFF42A5F5),
                          ],
                        ),
                      ),
                    ),
                  ),
                  TextButton(
                    style: TextButton.styleFrom(
                      padding: const EdgeInsets.all(16.0),
                      primary: Colors.white,
                      textStyle: const TextStyle(fontSize: 20),
                    ),
                    onPressed: () {
                      Navigator.pushAndRemoveUntil(
                        context,
                        MaterialPageRoute(
                            builder: (context) => const Profile()),
                        (Route<dynamic> route) => false,
                      );
                    },
                    child: const Text('Profile'),
                  ),
                ]))),
        Expanded(
            child: Row(
          children: [
            Expanded(
              child: JoystickPad(
                onUpdate: (String data) async {
                  print(data);
                  print(AppConstants.writing = false);
                  if (!AppConstants.writing) {
                    try {
                      AppConstants.writing = true;
                      await writeChar!.write(utf8.encode(data));
                      AppConstants.writing = false;
                    } catch (e) {
                      log(e.toString());
                    }
                  }
                },
              ),
            ),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.all(38.0),
                child: ButtonControl(
                  type: ButtonControlType.lrtb,
                  buttonControlData: buttonControlData,
                  onPress: (String data) async {
                    print(data);
                    if (!AppConstants.writing) {
                      try {
                        AppConstants.writing = true;
                        await writeChar!.write(utf8.encode(data));
                        AppConstants.writing = false;
                      } catch (e) {
                        log(e.toString());
                      }
                    }
                  },
                ),
              ),
            ),
          ],
        ))
      ],
    );
  }

  void _getPadSettings() async {
    buttonControlData = ButtonControlData(
        left: SharedPrefsKeys.left,
        right: SharedPrefsKeys.right,
        up: SharedPrefsKeys.up,
        down: SharedPrefsKeys.down);
  }

  @override
  void initState() {
    super.initState();
    _setup();

    _connectBluetooth();
  }

  @override
  Widget build(BuildContext context) {
    _getPadSettings();
    return Scaffold(
      body: StreamBuilder(
        stream: widget.device.state,
        builder: (context, snapshot) {
          if (snapshot.hasError) {
            _showSnackBarMessage('Cannot read bluetooth connection state');
            return Container();
          }
          if (snapshot.hasData) {
            if (snapshot.data == BluetoothDeviceState.connected) {
              return _buildControlPad();
            }
          }
          // return Center(
          //   child: Text('Connection state: ${snapshot.data.toString()}'),
          // );
          return _buildControlPad();
        },
      ),
      drawer: drawerBar(context),
    );
  }
}
