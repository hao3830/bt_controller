import 'dart:math';

import 'package:bluetooth_control_path/constants/constant.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class RightLever extends StatefulWidget {
  final double iconSize;
  final double boundary;
  final void Function(String) onUpdate;

  const RightLever({
    Key? key,
    this.iconSize = 100,
    this.boundary = 255,
    required this.onUpdate,
  }) : super(key: key);

  @override
  _RightLeverState createState() => _RightLeverState();
}

class _RightLeverState extends State<RightLever> {
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
            image: AssetImage(r'./imgs/arrow.png'), fit: BoxFit.fill),
      ),
      width: 240,
      height: 100,
      child: Center(
          child: Draggable(
        axis: Axis.horizontal,
        dragAnchorStrategy: childDragAnchorStrategy,
        onDragUpdate: (details) {
          Offset offset = _calculateOffset(details.localPosition);
          String x = offset.dx.toStringAsFixed(1);
          AppConstants.x = double.parse(x);
          widget.onUpdate('${AppConstants.x} ${AppConstants.y}');
        },
        onDragEnd: (details) {
          AppConstants.x = 0;
          Future.delayed(
            const Duration(milliseconds: 200),
            () => widget.onUpdate('0.0 ${AppConstants.y}'),
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
      )),
    ));
  }
}
