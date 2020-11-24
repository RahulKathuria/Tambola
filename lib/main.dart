import 'package:flutter/material.dart';
import 'package:tambola/number.dart';
import 'dart:math';
import 'package:flutter_tts/flutter_tts.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: HomePage(),
    );
  }
}

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final FlutterTts flutterTts = FlutterTts();
  int split, split2;
  int split1;
  List<int> numberArray = [];
  List<Color> colorArray = [];
  List<int> currentNum = [];
  var returnValue;

  @override
  void initState() {
    for (var i = 1; i <= 90; i++) {
      numberArray.add(i);
    }
    for (var i = 1; i <= 90; i++) {
      colorArray.add(Colors.white);
    }

    super.initState();
  }

  var number;
  String currentNumber = "";
  Random random = new Random();

  Color numberColor = Colors.white;
  int randomNumber;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.deepPurple[100],
      floatingActionButton: FloatingActionButton(
          onPressed: () {
            _showDialog();
          },
          child: Icon(Icons.restore)),
      appBar: AppBar(
        title: Text("Tambola Numbers Generator"),
        backgroundColor: Colors.deepPurple,
      ),
      drawer: Drawer(
        child: ListView(
          children: <Widget>[
            ListTile(
              title: Text("Previous Numbers "),
              trailing: Icon(Icons.arrow_forward),
            ),
          ],
        ),
      ),
      body: Column(
        children: <Widget>[
          Expanded(
              child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Text(
                currentNumber,
                style: TextStyle(fontSize: 30, fontWeight: FontWeight.bold),
              )
            ],
          )),
          Expanded(
              flex: 2,
              child: Container(
                child: GridView.builder(
                    itemCount: 90,
                    gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 10),
                    itemBuilder: (BuildContext context, int index) {
                      return Mynumber(
                          buttonText: numberArray[index].toString(),
                          buttonColor: colorArray[index]);
                    }),
              )),
          Container(
            height: 100,
            child: ClipRRect(
              borderRadius: BorderRadius.circular(10),
              child: Container(
                width: MediaQuery.of(context).size.width * 0.55,
                child: Padding(
                  padding: EdgeInsets.fromLTRB(0, 0, 0, 0),
                  child: FlatButton(
                    color: Colors.deepPurpleAccent,
                    onPressed: () async {
                      returnValue = currentNumberFunc();
                      print(returnValue.toString() + "This is the value");
                      await _speak(returnValue.toString());
                    },
                    child: Text(
                      "Next",
                      style: TextStyle(fontSize: 20),
                    ),
                  ),
                ),
              ),
            ),
          )
        ],
      ),
    );
  }

  String currentNumberFunc() {
    Random random = new Random();

    int index = random.nextInt(90) + 1;

    if (currentNum.length == 90) {
      print("the lenght is full" + currentNum.length.toString());
      return ("Game Finished");
    }
    if (currentNum.contains(index)) {
      currentNumberFunc();
    } else if (currentNum.contains(index) != true) {
      print(index);
      currentNum.add(index);

      setState(() {
        currentNumber = index.toString();
        for (var i = 0; i <= numberArray.length - 1; i++) {
          if (index == numberArray[i]) {
            colorArray[index - 1] = Colors.deepPurple;
          }
        }
      });
    }
    return currentNumber;
  }

  void reset() {
    setState(() {
      currentNumber = "";
      for (var i = 0; i < 90; i++) {
        colorArray[i] = Colors.white;
      }
      currentNum.removeRange(0, currentNum.length);
    });
  }

  Future _speak(value) async {

    await flutterTts.setLanguage("en-US");
    await flutterTts.setPitch(1.1);
    try {
      if (int.parse(value) != null &&
          int.parse(value) >= 1 &&
          int.parse(value) <= 9) {
        await flutterTts.speak("Single number  " + value);
      } else {
        var message = value.split("");
        await flutterTts.speak("${message[0].toString()} ${message[1].toString()} \"$value\"");
      }
    } catch (e) {
      await flutterTts.speak(value);
    }
  }

  void _showDialog() {
    // flutter defined function
    _speak("Do you really want to reset the game?");
    showDialog(
      context: context,
      builder: (BuildContext context) {
        // return object of type Dialog
        return AlertDialog(
          title: new Text("Do you really want to reset the game?"),
          actions: <Widget>[
            new FlatButton(
              child: new Text("Yes"),
              onPressed: () {
                _speak("Okay, Game Reset. Enjoy the new game.");
                reset();
                Navigator.of(context).pop();
              },
            ),
            // usually buttons at the bottom of the dialog
            new FlatButton(
              child: new Text("No"),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }
}
