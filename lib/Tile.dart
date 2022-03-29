import 'package:bananagrams/colour.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import 'main.dart';

class Tile extends StatefulWidget {
  String letter;
  bool vis;
  int hash;
  final TileController controller;
  final setRedCallback setRed;

  Tile(
      {Key? key,
      required this.letter,
      required this.vis,
      required this.controller,
        required this.setRed,
      required this.hash})
      : super(key: key);

  @override
  _Tile createState() => _Tile(controller);
}

class _Tile extends State<Tile> {
  _Tile(TileController _controller) {
    _controller.setVis = setVisa;
  }

  void setVisa() {
    setState(() {
      widget.vis = true;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Draggable<Let>(
      data: Let(widget.letter, widget.hash),
      child: Visibility(
          visible: widget.vis,
          maintainSize: true,
          maintainAnimation: true,
          maintainState: true,
          child: Container(
              height: 25,
              width: 25,
              decoration: const BoxDecoration(
                color: Colour.lightGreen,
                borderRadius: BorderRadius.all(Radius.circular(15.0)),
              ),
              child: Center(
                  child: Text(widget.letter,
                      style: GoogleFonts.grandstander(fontSize: 42,fontWeight: FontWeight.w900, color: Colors.white))))),
      feedback: Container(
          height: 50,
          width: 50,
          decoration: const BoxDecoration(
            color: Colour.lightGreen,
            borderRadius: BorderRadius.all(Radius.circular(15.0)),
          ),
          child: Center(
              child: Text(widget.letter,
                  style: GoogleFonts.grandstander(fontSize: 42,fontWeight: FontWeight.w900, color: Colors.white, decoration: TextDecoration.none)))),
      childWhenDragging: Container(),
      onDragCompleted: () {
        setState(() {
          widget.vis = false;
        });
      },
      onDragStarted: (){
        widget.setRed(widget.letter);
      },
      onDragEnd: (data){
        widget.setRed(widget.letter);
      },



    );
  }
}
