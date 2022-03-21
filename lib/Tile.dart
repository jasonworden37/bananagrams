import 'package:flutter/material.dart';

import 'main.dart';

class Tile extends StatefulWidget {
  String letter;
  bool vis;
  int hash;
  final TileController controller;

  Tile(
      {Key? key,
      required this.letter,
      required this.vis,
      required this.controller,
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
              height: 50,
              width: 50,
              decoration: const BoxDecoration(
                color: Colors.amberAccent,
                borderRadius: BorderRadius.all(Radius.circular(15.0)),
              ),
              child: Center(
                  child: Text(widget.letter,
                      style: const TextStyle(fontSize: 36))))),
      feedback: Container(
          height: 50,
          width: 50,
          decoration: const BoxDecoration(
            color: Colors.amberAccent,
            borderRadius: BorderRadius.all(Radius.circular(15.0)),
          ),
          child: Center(
              child: Text(widget.letter,
                  style: const TextStyle(
                    decoration: TextDecoration.none,
                    fontSize: 36,
                    color: Colors.black,
                  )))),
      childWhenDragging: Container(),
      onDragCompleted: () {
        setState(() {
          widget.vis = false;
        });
      },
    );
  }
}
