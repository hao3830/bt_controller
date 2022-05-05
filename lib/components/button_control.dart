import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

enum ButtonControlType {
  lrtb,
  arrow,
}

class ButtonControlData {
  final String? left;
  final String? right;
  final String? up;
  final String? down;

  ButtonControlData({
    this.left = "None",
    this.right = "None",
    this.up = "None",
    this.down = "None",
  });
}

class ButtonControl extends StatelessWidget {
  final ButtonControlType type;
  final void Function(String)? onPress;
  final ButtonControlData? buttonControlData;

  const ButtonControl({
    Key? key,
    this.type = ButtonControlType.lrtb,
    required this.onPress,
    this.buttonControlData,
  }) : super(key: key);

  Widget _buildButton({required IconData icon, void Function()? onPress}) {
    return GestureDetector(
      onTap: onPress,
      child: Container(
        decoration: BoxDecoration(
          color: Colors.blueGrey.shade300,
          shape: BoxShape.circle,
          border: Border.all(
            color: Colors.grey.shade300,
            width: 1.0,
          ),
        ),
        padding: const EdgeInsets.all(20),
        child: FaIcon(
          icon,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Expanded(
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              _buildButton(
                icon: FontAwesomeIcons.angleUp,
                onPress: () {
                  if (onPress != null) {
                    onPress!(
                      (type == ButtonControlType.lrtb
                              ? buttonControlData!.up
                              : 'up')
                          .toString(),
                    );
                  }
                },
              )
            ],
          ),
        ),
        Expanded(
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              _buildButton(
                icon: FontAwesomeIcons.angleLeft,
                onPress: () {
                  if (onPress != null) {
                    onPress!(
                      (type == ButtonControlType.lrtb
                              ? buttonControlData!.left
                              : 'left')
                          .toString(),
                    );
                  }
                },
              ),
              Container(),
              _buildButton(
                icon: FontAwesomeIcons.angleRight,
                onPress: () {
                  if (onPress != null) {
                    onPress!(
                      (type == ButtonControlType.lrtb
                              ? buttonControlData!.right
                              : 'right')
                          .toString(),
                    );
                  }
                },
              ),
            ],
          ),
        ),
        Expanded(
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              _buildButton(
                  icon: FontAwesomeIcons.angleDown,
                  onPress: () {
                    if (onPress != null) {
                      onPress!(
                        (type == ButtonControlType.lrtb
                                ? buttonControlData!.down
                                : 'down')
                            .toString(),
                      );
                    }
                  })
            ],
          ),
        ),
      ],
    );
  }
}
