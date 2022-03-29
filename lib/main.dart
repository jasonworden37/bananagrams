

import 'package:bananagrams/target.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'dart:math';

import 'Tile.dart';
import 'colour.dart';

void main() {
  runApp(const Home());
}

class TileController {
  late void Function() setVis;
}

class TargetController {
  late void Function() clearLetter;
  late void Function() setColor;
  late void Function() setR;
  late void Function() shake;
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

  late Future<List<Target>> loadedTargets;
  late Future<List<List<String>>> loadedList;
  late Future<List<Tile>> loadedLetters;
  List<TileController> tileControllers = [];
  List<TargetController> targetControllers = [];
  List<Target> targets = [];
  List<String> letters = [];
  List<Tile> tiles = [];
  List<String> words = [];
  List<String> dictionary = [];
  Set<int> indexesToCheck = {};
  Set<int> indexesToShake = {};
  String date = "";
  List<List<String>> list = [];
  int width = 10;
  int height = 10;
  int numGuesses = 0;

  Future<List<Target>> loadTargets() async {
    await loadedList;
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

  void loadDict() async {
    String ret = await rootBundle.loadString('assets/engmix.txt');
    List<String> w = ret.split("\n");
    for (int i = 0; i < w.length; i++) {
      dictionary.add(w[i]);
    }
  }

  Future<List<List<String>>> loadList() async {
    String month = now.month.toString();
    if (month.length == 1) month = "0" + month;
    date = now.year.toString() + "-" + month + "-" + now.day.toString();
    date = "2022-03-23";
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
    await loadedList;
    return Future<List<Tile>>(() {
      List<Tile> temp = [];
      List<String> lettersTemp = [];
      for (int i = 0; i < height; i++) {
        for (int j = 0; j < width; j++) {
          if (list[i][j] != '-') lettersTemp.add(list[i][j]);
        }
      }
      lettersTemp.shuffle(Random());
      for (int i = 0; i < lettersTemp.length; i++) {
        tileControllers.add(TileController());
        temp.add(Tile(
            letter: lettersTemp[i],
            vis: true,
            controller: tileControllers[i],
            hash: i,
            setRed: (String s) {
              setRed(lettersTemp[i]);
            }));
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
    t -= 1;
    b += 1;
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

  void setRed(String s) {
    for (int i = 0; i < targets.length; i++) {
      if (targets[i].c != '-' && targets[i].triedLetters.contains(s)) {
        targetControllers[i].setR();
      }
    }
  }

  bool gatherIndexes() {
    indexesToShake.clear();
    indexesToCheck.clear();

    for (var x = 0; x < height; x++) {
      for (var y = 0; y < width; y++) {
        if (list[x][y] != '-' && list[x][y + 1] != '-') {
          List<int> temp = [];
          String str = '';
          bool isWord = true;
          int index = (x * width) + y;
          while (list[x][y] != '-') {
            if (targets[index].l == '') {
              isWord = false;
              str += ' ';
            } else {
              temp.add(index);
              str += targets[index].l;
            }
            index++;
            y++;
          }
          if (isWord) {
            for (int i = 0; i < temp.length; i++) {
              indexesToCheck.add(temp[i]);
            }
          } else {
            for (int i = 0; i < temp.length; i++) {
              indexesToShake.add(temp[i]);
            }
          }
        }
      }
    }

    for (var x = 0; x < width; x++) {
      for (var y = 0; y < height; y++) {
        if (list[y][x] != '-' && list[y + 1][x] != '-') {
          List<int> temp = [];
          String str = '';
          bool isWord = true;
          while (list[y][x] != '-') {
            int index = (y * width) + x;

            if (targets[index].l == '') {
              isWord = false;
              str += ' ';
            } else {
              temp.add(index);
              str += targets[index].l;
            }
            y++;
          }
          if ( isWord) {
            for (int i = 0; i < temp.length; i++) {
              indexesToCheck.add(temp[i]);
            }
          } else {
            for (int i = 0; i < temp.length; i++) {
              indexesToShake.add(temp[i]);
            }
          }
        }
      }
    }

    for (int i = indexesToShake.length - 1; i > -1; i--) {
      int element = indexesToShake.elementAt(i);
      if (indexesToCheck.contains(element) || targets[element].isLocked)
        indexesToShake.remove(element);
    }
    print('indexes to check - >' + indexesToCheck.toString());
    print('index to shake - > ' + indexesToShake.toString());
    return indexesToShake.isEmpty;
  }

  void shakeIndexes() {
    // for(int i = 0; i < indexesToShake.length; i++){
    //   int element = indexesToShake.elementAt(i);
    //   targetControllers[element].shake();
    // }
  }

  void checkLetters() {
    for (var x = 0; x < height; x++) {
      for (var y = 0; y < width; y++) {
        if (list[x][y] != "-") {
          int index = (x * width) + y;
          if (targets[index].l == list[x][y]) {
            setState(() {
              targets[index].isLocked = true;
              targetControllers[index].setColor();
            });

          } else {
            setState(() {
              targets[index].triedLetters.add(targets[index].l);
              targetControllers[index].clearLetter();
            });
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

  void pressedGuess(){
    if(emptyBoxes()){

    } else if (gatherIndexes()) {
      setState(() {
        numGuesses++;
      });
      checkLetters();
    } else {
      shakeIndexes();
    }
  }

  bool emptyBoxes() {

    for (var x = 0; x < height; x++) {
      for (var y = 0; y < width; y++) {
          if(list[x][y] != '-'){
            int index = (x * width) + y;
            if(targets[index].l != ''){
              return false;
            }
          }
        }
      }


    return true;
  }

  bool disable() {
    for (var x = 0; x < height; x++) {
      for (var y = 0; y < width; y++) {
        if(list[x][y] != '-'){
          int index = (x * width) + y;
          if(!targets[index].isLocked && numGuesses < 5){
            return false;
          }
        }
      }
    }

    return true;
  }

  @override
  void initState() {
    loadedList = loadList();
    loadDict();
    loadedTargets = loadTargets();
    loadedLetters = loadLetters();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
        height: 200,
        width: double.infinity,
        alignment: Alignment.topCenter,
        decoration: const BoxDecoration(
          image: DecorationImage(
              image: AssetImage("assets/Artboard.png"),
          fit: BoxFit.fill,),
        ),
        child:
        Scaffold(
          backgroundColor: Colors.transparent,
        body: Column(children: <Widget>[
          Spacer(),


          FutureBuilder<List<List<String>>>(
            future: loadedList,
            builder:
                (BuildContext context, AsyncSnapshot<List<List<String>>> snapshot) {
              return  Expanded(
                  child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                    primary: Colour.lightGreen,
                    fixedSize: const Size(300, 75),
                    textStyle: GoogleFonts.grandstander(
                        fontSize: 42,
                        fontWeight: FontWeight.w900,
                        color: Colors.white,
                        decoration: TextDecoration.none),
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20))),
                onPressed:(!disable())?pressedGuess :null,
                child: Text('$numGuesses/5'),
              ));

            },
          ),
          FutureBuilder<List<Target>>(
            future: loadedTargets,
            builder:
                (BuildContext context, AsyncSnapshot<List<Target>> snapshot) {
                return Expanded(
                  flex: 4,
                  child: GridView.count(
                      mainAxisSpacing: 5,
                      crossAxisSpacing: 5,
                      physics: const NeverScrollableScrollPhysics(),
                      crossAxisCount: width,
                      children: targets));

            },
          ),
          FutureBuilder<List<Tile>>(
            future: loadedLetters,
            builder: (BuildContext context, AsyncSnapshot<List<Tile>> snapshot) {
              return Expanded(
                  flex: 3,
                  child: GridView.count(
                      padding: const EdgeInsets.all(30),
                      mainAxisSpacing: 7,
                      crossAxisSpacing: 7,
                      physics: const NeverScrollableScrollPhysics(),
                      crossAxisCount: 5,
                      children: tiles));
            },
          ),
        ]),
      )
    );
    // return Scaffold(
    //   backgroundColor: Colors.white,
    //   body: Column(children: <Widget>[
    //     Spacer(),
    //     Text('Wordscram',
    //         style: GoogleFonts.grandstander(
    //             fontSize: 42,
    //             fontWeight: FontWeight.w900,
    //             color: Colors.black)),
    //     ElevatedButton(
    //       style: ElevatedButton.styleFrom(
    //           primary: Colour.lightGreen,
    //           fixedSize: const Size(300, 75),
    //           textStyle: GoogleFonts.grandstander(
    //               fontSize: 42,
    //               fontWeight: FontWeight.w900,
    //               color: Colors.white,
    //               decoration: TextDecoration.none),
    //           shape: RoundedRectangleBorder(
    //               borderRadius: BorderRadius.circular(20))),
    //       onPressed:(numGuesses < 5)?pressedGuess: null,
    //       child: Text('$numGuesses/5'),
    //     ),
    //     FutureBuilder<List<Target>>(
    //       future: loadedTargets,
    //       builder:
    //           (BuildContext context, AsyncSnapshot<List<Target>> snapshot) {
    //           return Expanded(
    //             flex: 4,
    //             child: GridView.count(
    //                 physics: const NeverScrollableScrollPhysics(),
    //                 crossAxisCount: width,
    //                 children: targets));
    //
    //       },
    //     ),
    //     FutureBuilder<List<Tile>>(
    //       future: loadedLetters,
    //       builder: (BuildContext context, AsyncSnapshot<List<Tile>> snapshot) {
    //         return Expanded(
    //             flex: 3,
    //             child: GridView.count(
    //                 mainAxisSpacing: 10,
    //                 crossAxisSpacing: 10,
    //                 physics: const NeverScrollableScrollPhysics(),
    //                 crossAxisCount: 5,
    //                 children: tiles));
    //       },
    //     ),
    //     // Row(children: [
    //     //   FloatingActionButton(
    //     //     onPressed: () {
    //     //       if(gatherIndexes()) {
    //     //         print('checking letters');
    //     //         checkLetters();
    //     //       }else{
    //     //         shakeIndexes();
    //     //         print('shaking indexeds');
    //     //       }
    //     //     },
    //     //     backgroundColor: Colors.green,
    //     //     child: const Icon(Icons.check),
    //     //   ),
    //     //   //const Spacer(),
    //     //   FloatingActionButton(
    //     //     onPressed: () {
    //     //       setState(() {
    //     //         tiles;
    //     //       });
    //     //     },
    //     //     backgroundColor: Colors.grey,
    //     //     child: const Icon(Icons.shuffle),
    //     //   ),
    //     // ]),
    //   ]),
    // );
  }

}

class Let {
  String letter;
  int id;

  Let(this.letter, this.id);
}

typedef VisibilityCallback = void Function();
typedef setRedCallback = void Function(String s);
