import 'package:bluetooth_control_path/constants/constant.dart';
import 'package:bluetooth_control_path/screens/control_pad_page.dart';
import 'package:bluetooth_control_path/screens/lever_control_pad.dart';
import 'package:flutter/material.dart';

Widget drawerBar(BuildContext context) {
  Widget create(IconData icon, String text, int index) {
    return Padding(
        padding: const EdgeInsets.fromLTRB(8.0, 8.0, 8.0, 8.0),
        child: InkWell(
            borderRadius: BorderRadius.circular(20),
            splashColor: Colors.lightBlue,
            onTap: () {
              Navigator.pushAndRemoveUntil(
                context,
                MaterialPageRoute(builder: (context) {
                  if (index == 1) {
                    return ControlPadPage(
                      device: AppConstants.device,
                    );
                  } else {
                    return LeverControl(
                      device: AppConstants.device,
                    );
                  }
                }),
                (Route<dynamic> route) => false,
              );
            },
            child: Row(children: [
              Icon(
                icon,
                size: 20,
                color: Colors.blue[700],
              ),
              const Padding(padding: EdgeInsets.only(left: 8.0)),
              Text(
                text,
                style:
                    const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
            ])));
  }

  return Drawer(
      child: ListView(
    padding: EdgeInsets.zero,
    children: <Widget>[
      const DrawerHeader(
        child: Text(
          'Control Pad',
          style: TextStyle(fontSize: 20),
        ),
        decoration: BoxDecoration(
          color: Colors.blue,
        ),
      ),
      create(
        Icons.album_outlined,
        "Joystick Pad",
        1,
      ),
      create(Icons.control_camera, "Lever Pad", 2),
    ],
  ));
}
