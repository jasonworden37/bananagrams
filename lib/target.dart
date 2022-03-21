import 'package:flutter/material.dart';
import 'main.dart';

class Target extends StatefulWidget {
  int x;
  int y;
  String c;
  int hash = -1;
  String l = "";
  bool isLocked = false;
  TargetController controller;
  final VisibilityCallback onVisibilitySelect;

  Target(
      {Key? key,
      required this.x,
      required this.y,
      required this.c,
      required this.onVisibilitySelect,
      required this.controller})
      : super(key: key);

  @override
  _Target createState() => _Target(controller);
}

class _Target extends State<Target> {
  _Target(TargetController controller) {
    controller.clearLetter = clearLetter;
    controller.setColor = setColor;
  }

  Color getColor() {
    if (widget.isLocked) {
      return Colors.amberAccent;
    } else if (widget.c != "-") {
      return Colors.black12;
    }
    return Colors.white;
  }

  void clearLetter() {
    setState(() {
      widget.l = "";
    });
  }

  void setColor() {
    setState(() {
      getColor();
    });
  }

  @override
  Widget build(BuildContext context) {
    return DragTarget<Let>(
      builder: (
        BuildContext context,
        List<dynamic> accepted,
        List<dynamic> rejected,
      ) {
        return InkWell(
            onTap: () {
              if (!widget.isLocked) {
                setState(() {
                  widget.l = "";
                  widget.hash = -1;
                  widget.onVisibilitySelect();
                });
              }
            },
            child: Container(
              height: 100.0,
              width: 100.0,
              color: getColor(),
              child: Center(
                child: Text(widget.l, style: const TextStyle(fontSize: 36)),
              ),
            ));
      },
      onAccept: (data) {
        setState(() {
          widget.l = data.letter;
          widget.hash = data.id;
          widget.onVisibilitySelect();
        });
      },
      onWillAccept: (data) {
        return widget.c != "-" && !widget.isLocked;
      },
    );
  }
}
