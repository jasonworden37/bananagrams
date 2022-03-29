import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'colour.dart';
import 'main.dart';

class Target extends StatefulWidget {
  int x;
  int y;
  String c;
  int hash = -1;
  Color col = Colors.transparent;
  bool isRed = false;
  String l = "";
  bool isLocked = false;
  List<String> triedLetters = [];
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
    controller.setR = setR;
    controller.shake = shake;
  }

  Color getColor() {
    if (widget.isLocked) {
      widget.col = Colour.lightGreen;
    } else if (widget.c != "-") {
      widget.col = Colour.gray;
    } else {
      widget.col = Colors.transparent;
    }
    return widget.col;
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
  void shake(){
   //perfrom shake
  }

  void setR() {
    if (widget.isRed) {
      setState(() {
        widget.isRed = false;
      });
    } else if (!widget.isLocked) {
      setState(() {
        widget.isRed = true;
      });
    }
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
            child: AnimatedSwitcher(
                duration: const Duration(milliseconds: 600),
                child: Container(
                  decoration: BoxDecoration(
                    color: (widget.isRed) ? Colors.red : getColor(),
                  ),

                  height: 100.0,
                  width: 100.0,
                  child: Center(
                    child: Text(widget.l, style: GoogleFonts.grandstander(fontSize: 42,fontWeight: FontWeight.w900, color: Colors.white)),
                  ),
                )));
      },
      onAccept: (data) {
        setState(() {
          //widget.isRed = false;
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
