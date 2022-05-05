import 'dart:math';

import 'package:bluetooth_control_path/constants/constant.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class LeftLever extends StatefulWidget {
  final double iconSize;

  final void Function(String) onUpdate;

  const LeftLever({
    Key? key,
    this.iconSize = 80,
    required this.onUpdate,
  }) : super(key: key);

  @override
  _LeftLeverState createState() => _LeftLeverState();
}

class _LeftLeverState extends State<LeftLever> {
  final GlobalKey _containerKey = GlobalKey();

  Offset _calculateOffset(Offset localPosition) {
    final renderBox =
        _containerKey.currentContext?.findRenderObject()! as RenderBox;
    Size size = renderBox.size;
    Offset boxOffset = renderBox.localToGlobal(
      Offset(size.width / 2, size.height / 2),
    );
    Offset offset = localPosition - boxOffset;
    offset = Offset(
      min(1.0, max(-1, offset.dx / (size.width / 2))),
      min(1.0, max(-1, offset.dy / (size.height / 2))),
    );
    return offset;
  }

  @override
  Widget build(BuildContext context) {
    return Center(
        child: Container(
            key: _containerKey,
            decoration: const BoxDecoration(
              image: DecorationImage(
                  image: AssetImage(r'./imgs/arrow_vertical.png'),
                  fit: BoxFit.fill),
            ),
            width: 100,
            height: 240,
            child: Center(
              child: Draggable(
                axis: Axis.vertical,
                dragAnchorStrategy: childDragAnchorStrategy,
                onDragUpdate: (details) {
                  Offset offset = _calculateOffset(details.localPosition);
                  String y = offset.dy.toStringAsFixed(1);
                  String x = offset.dx.toStringAsFixed(1);
                  print("x = $x, y = $y");
                  AppConstants.y = double.parse(y);
                  widget.onUpdate('${AppConstants.x} ${AppConstants.y}');
                },
                onDragEnd: (details) {
                  AppConstants.y = 0.0;
                  Future.delayed(
                    const Duration(milliseconds: 200),
                    () => widget.onUpdate('${AppConstants.x} 0.0'),
                  );
                },
                child: FaIcon(
                  FontAwesomeIcons.circleDot,
                  size: widget.iconSize,
                ),
                childWhenDragging: FaIcon(
                  FontAwesomeIcons.circleStop,
                  size: widget.iconSize,
                ),
                feedback: FaIcon(
                  FontAwesomeIcons.solidCircleDot,
                  size: widget.iconSize,
                ),
              ),
            )));
  }
}
