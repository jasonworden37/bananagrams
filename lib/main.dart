import 'package:bananagrams/target.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'Tile.dart';

void main() {
  runApp(const Home());
}

class TileController {
  late void Function() setVis;
}

class TargetController {
  late void Function() clearLetter;
  late void Function() setColor;
}

class Home extends StatelessWidget {
  const Home({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      home: CheckerBoard(),
    );
  }
}

class CheckerBoard extends StatefulWidget {
  const CheckerBoard({Key? key}) : super(key: key);

  @override
  _CheckerBoardState createState() => _CheckerBoardState();
}

class _CheckerBoardState extends State<CheckerBoard> {
  DateTime now = DateTime.now();

  Future<String> loadAsset(String str) async {
    String ret = await rootBundle.loadString('assets/boards.txt');
    List<String> boards = ret.split(":");
    for (int i = 0; i < boards.length; i++) {
      if (boards[i].contains(str)) ret = boards[i];
    }
    return ret;
  }

  List<TileController> tileControllers = [];
  List<TargetController> targetControllers = [];
  List<Target> targets = [];
  List<String> letters = [];
  List<Tile> tiles = [];
  List<String> words = [];
  String date = "";
  List<List<String>> list = [];
  int width = 10;
  int height = 10;

  Future<List<Target>> loadTargets() async {
    return Future<List<Target>>(() {
      List<Target> temp = [];
      for (var x = 0; x < height; x++) {
        for (var y = 0; y < width; y++) {
          int index = getIndex(x, y);
          targetControllers.add(TargetController());
          temp.add(Target(
              x: x,
              y: y,
              c: list[x][y],
              onVisibilitySelect: () {
                doVisibility();
              },
              controller: targetControllers[index]));
        }
      }
      targets = temp;
      return temp;
    });
  }

  Future<List<List<String>>> loadList() async {
    String month = now.month.toString();
    if(month.length  == 1) month = "0" + month;
    date = now.year.toString() +  "-" + month + "-" + now.day.toString();
    String str = await loadAsset(date);
    int xCount = 0;
    int yCount = 0;
    return Future<List<List<String>>>(() {
      List<List<String>> temp = [
        ["-", "-", "-", "-", "-", "-", "-", "-", "-", "-", "-", "-", "-"],
        ["-", "-", "-", "-", "-", "-", "-", "-", "-", "-", "-", "-", "-"],
        ["-", "-", "-", "-", "-", "-", "-", "-", "-", "-", "-", "-", "-"],
        ["-", "-", "-", "-", "-", "-", "-", "-", "-", "-", "-", "-", "-"],
        ["-", "-", "-", "-", "-", "-", "-", "-", "-", "-", "-", "-", "-"],
        ["-", "-", "-", "-", "-", "-", "-", "-", "-", "-", "-", "-", "-"],
        ["-", "-", "-", "-", "-", "-", "-", "-", "-", "-", "-", "-", "-"],
        ["-", "-", "-", "-", "-", "-", "-", "-", "-", "-", "-", "-", "-"],
        ["-", "-", "-", "-", "-", "-", "-", "-", "-", "-", "-", "-", "-"],
        ["-", "-", "-", "-", "-", "-", "-", "-", "-", "-", "-", "-", "-"],
        ["-", "-", "-", "-", "-", "-", "-", "-", "-", "-", "-", "-", "-"],
        ["-", "-", "-", "-", "-", "-", "-", "-", "-", "-", "-", "-", "-"],
        ["-", "-", "-", "-", "-", "-", "-", "-", "-", "-", "-", "-", "-"],
      ];
      List<String> split = str.split(',');

      for (int i = 0; i < split.length; i++) {
        if (i == 0) {
        } else if (i <= 3) {
          words.add(split[i]);
        } else {
          if (xCount < height) {
            temp[xCount][yCount++] = split[i];
            if (yCount == width) {
              yCount = 0;
              xCount++;
            }
          }
        }
      }

      setState(() {
        list = temp;
      });
      shrink();
      return temp;
    });
  }

  Future<List<Tile>> loadLetters() async {
    return Future<List<Tile>>(() {
      List<Tile> temp = [];
      List<String> lettersTemp = [];
      for (int i = 0; i < height; i++) {
        for (int j = 0; j < width; j++) {
          if (list[i][j] != '-') lettersTemp.add(list[i][j]);
        }
      }

      for (int i = 0; i < lettersTemp.length; i++) {
        tileControllers.add(TileController());
        temp.add(Tile(
            letter: lettersTemp[i],
            vis: true,
            controller: tileControllers[i],
            hash: i));
      }

      tiles = temp;
      letters = lettersTemp;

      return temp;
    });
  }

  String getWeekday(int day) {
    String str = "";
    switch (day) {
      case 1:
        {
          str = "Monday";
        }
        break;
      case 2:
        {
          str = "Tuesday";
        }
        break;
      case 3:
        {
          str = "Wednesday";
        }
        break;
      case 4:
        {
          str = "Thursday";
        }
        break;
      case 5:
        {
          str = "Friday";
        }
        break;
      case 6:
        {
          str = "Saturday";
        }
        break;
      case 7:
        {
          str = "Sunday";
        }
        break;
    }
    return str;
  }

  String getMonth(int day) {
    String str = "";
    switch (day) {
      case 1:
        {
          str = "January";
        }
        break;
      case 2:
        {
          str = "February";
        }
        break;
      case 3:
        {
          str = "March";
        }
        break;
      case 4:
        {
          str = "April";
        }
        break;
      case 5:
        {
          str = "May";
        }
        break;
      case 6:
        {
          str = "June";
        }
        break;
      case 7:
        {
          str = "July";
        }
        break;
      case 8:
        {
          str = "August";
        }
        break;
      case 9:
        {
          str = "September";
        }
        break;
      case 10:
        {
          str = "October";
        }
        break;
      case 11:
        {
          str = "November";
        }
        break;
      case 12:
        {
          str = "December";
        }
        break;
    }
    return str;
  }

  int getIndex(int x, int y) {
    return (x * width) + y;
  }

  void doVisibility() {
    List<int> temp = [];
    for (var x = 0; x < height; x++) {
      for (var y = 0; y < width; y++) {
        if (list[x][y] != "-") {
          int index = (x * width) + y;
          if (targets[index].l != "") {
            temp.add(targets[index].hash);
          }
        }
      }
    }
    for (int i = 0; i < letters.length; i++) {
      if (!temp.contains(tiles[i].hash)) {
        tileControllers[i].setVis();
      }
    }
  }

  // void printBoard() {
  //   for (var x = 0; x < height; x++) {
  //     for (var y = 0; y < width; y++) {
  //       if (list[x][y] != "-") {
  //         int index = (x * width) + y;
  //         print(targets[index].l);
  //       }
  //     }
  //   }
  // }

  void shrink() {
    List<List<String>> temp = list;
    int l = -1, r = -1, b = -1, t = -1;
    for (var x = 0; x < height; x++) {
      for (var y = 0; y < width; y++) {
        if (temp[x][y] != "-") {
          //print(temp[x][y] + " is at " + x.toString() + " ," + y.toString());
          if (l == -1) {
            l = y;
          } else if (y < l) {
            l = y;
          }
          if (r == -1) {
            r = y;
          } else if (y > r) {
            r = y;
          }
          if (t == -1) t = x;
          if (b == -1) {
            b = x;
          } else if (x > b) {
            b = x;
          }
        }
      }
    }
    int size = 10;
    t -= 2;
    b += 2;
    r += 1;
    l -= 1;
    for (int i = size - 1; i > b; i--) {
      temp.removeAt(i);
    }
    while (t >= 0) {
      temp.removeAt(t);
      t--;
      size--;
    }
    height = size;

    for (int i = width - 1; i > r; i--) {
      for (int j = 0; j < height; j++) {
        list[j].removeAt(i);
      }
      width--;
    }
    while (l > 0) {
      for (int j = 0; j < height; j++) {
        list[j].removeAt(l);
      }
      l--;
      width--;
    }
    setState(() {
      width;
      height;
      list = temp;
    });
  }

  void checkLetters() {
    for (var x = 0; x < height; x++) {
      for (var y = 0; y < width; y++) {
        if (list[x][y] != "-") {
          int index = (x * width) + y;
          if (targets[index].l == list[x][y]) {
            targets[index].isLocked = true;
            targetControllers[index].setColor();
          } else {
            targetControllers[index].clearLetter();
            doVisibility();
          }
        }
      }
    }
  }

  // void printList() {
  //   for (int i = 0; i < height; i++) {
  //     print(list[i]);
  //   }
  // }

  @override
  void initState() {
    loadList();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(getWeekday(now.weekday) +
            ", " +
            getMonth(now.month) +
            " " +
            now.day.toString()),
        backgroundColor: Colors.amberAccent,
      ),
      body: Column(children: <Widget>[
        FutureBuilder<List<Target>>(
          future: loadTargets(),
          builder:
              (BuildContext context, AsyncSnapshot<List<Target>> snapshot) {
            if (snapshot.connectionState != ConnectionState.waiting &&
                !snapshot.hasError) {
              return Expanded(
                  flex: 2,
                  child: GridView.count(
                      physics: const NeverScrollableScrollPhysics(),
                      crossAxisCount: width,
                      children: targets));
            }
            return const Text("");
          },
        ),
        FutureBuilder<List<Tile>>(
          future: loadLetters(),
          builder: (BuildContext context, AsyncSnapshot<List<Tile>> snapshot) {
            if (snapshot.connectionState != ConnectionState.waiting &&
                !snapshot.hasError) {
              return Expanded(
                  child: GridView.count(
                      physics: const NeverScrollableScrollPhysics(),
                      crossAxisCount: 6,
                      children: tiles));
            }
            return const Text("");
          },
        ),
        FloatingActionButton(
          onPressed: () {
            checkLetters();
          },
          backgroundColor: Colors.amberAccent,
          child: const Icon(Icons.check),
        )
      ]),
    );
  }
}

class Let {
  String letter;
  int id;

  Let(this.letter, this.id);
}

typedef VisibilityCallback = void Function();
