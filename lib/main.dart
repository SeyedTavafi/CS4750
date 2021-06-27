//Seyed Tavafi
//CS4750.01
// Professor Sun
//Number Guessing game project
// Summer 2021

import 'dart:async';
import 'dart:convert';
import 'dart:math';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:shared_preferences/shared_preferences.dart';
void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Number Guessing Game',
      theme: ThemeData(
        scaffoldBackgroundColor: Color(0xff192f44),
        primarySwatch: Colors.amber,
        textTheme: TextTheme(
          bodyText1: TextStyle(color: Colors.white),
          bodyText2: TextStyle(color: Colors.white),
          headline1: TextStyle(color: Colors.white),
          headline2: TextStyle(color: Colors.white),
          headline3: TextStyle(color: Colors.white),
          headline4: TextStyle(color: Colors.white),
          headline5: TextStyle(color: Colors.white),
          headline6: TextStyle(color: Colors.white),
          caption: TextStyle(color: Colors.white),
          overline: TextStyle(color: Colors.white),
          button: TextStyle(color: Colors.white),
          subtitle1: TextStyle(color: Colors.white),
          subtitle2: TextStyle(color: Colors.white),
        ),
      ),
      home: IntroPage(),
    );
  }
}

//statefulwidget: data changes   statelesswidget: data doesn't change
class IntroPage extends StatefulWidget {
  IntroPage({Key? key}) : super(key: key);

  @override
  //Anytime is need to change the state (Timer will change)
  _IntroPageState createState() => _IntroPageState();
}

class _IntroPageState extends State<IntroPage> {
  @override
  Widget build(BuildContext context) {
    //scaffold includes everything about the code.
    return Scaffold(
      // make sure everything is visible for users
      body: SafeArea(
        child: Center(
          child: Column(
            children: [
              Expanded(
                child: Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Container(
                        child: Image(
                          width: MediaQuery.of(context).size.width * .8,
                          image: ExactAssetImage(
                            "images/mainPageImage.jpg",
                            scale: 1.8,
                          ),
                        ),
                      ),
                      SizedBox(
                        height: 24,
                      ),
                      Container(
                        child: Text(
                          "You should choose the number between 1-100  and you have 8 chance to guess correct number",
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            color: Colors.amber,
                            fontSize: 18,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              //gesture detector it is easier to use and it is easier to modify.
              GestureDetector(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => GamePage(title: 'Timer: '),
                    ),
                  );
                },
                child: Container(
                  height: 50,
                  width: MediaQuery.of(context).size.width * .9,
                  decoration: BoxDecoration(
                    color: Colors.amber,
                    borderRadius: BorderRadius.circular(14.0),
                  ),
                  child: Center(
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Text(
                        "START",
                        style: TextStyle(
                          color: Color(0xff192f44),
                          fontSize: 24.0,
                          fontWeight: FontWeight.w300,
                        ),
                      ),
                    ),
                  ),
                ),
              ),
              SizedBox(
                height: 12,
              ),
              GestureDetector(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => ScoreBoard(),
                    ),
                  );
                },
                child: Container(
                  height: 50,
                  width: MediaQuery.of(context).size.width * .9,
                  decoration: BoxDecoration(
                    color: Colors.amber,
                    borderRadius: BorderRadius.circular(14.0),
                  ),
                  child: Center(
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Text(
                        "SCOREBOARD",
                        style: TextStyle(
                          color: Color(0xff192f44),
                          fontSize: 24.0,
                          fontWeight: FontWeight.w300,
                        ),
                      ),
                    ),
                  ),
                ),
              ),
              SizedBox(
                height: 48,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class GamePage extends StatefulWidget {
  GamePage({Key? key, required this.title}) : super(key: key);

  final String title;

  @override
  _GamePageState createState() => _GamePageState();
}

class _GamePageState extends State<GamePage> {
  int _counter = 0;
  int _randNumber = 0;
  //future
  late Timer _timer;
  var _textGusssed = TextEditingController();
  //create random object
  var rng = new Random();

  //bishtare kamtare
  var _res;

  // it checks if the game still running or not.
  bool _isGameON = true;
//liste addad vooroodi
  List<Widget> items = [];

  //timer should goes on or not
  bool _gameIsActive = true;

  // it stores winning games only
  var arr = [];
//for showing guess of the users in the bottom box.
  void addToList(String title) {
    Widget item = ListTile(
      title: Text("${_counter + 1}: you chose $title"),
    );
    setState(() {
      items.add(item);
    });
  }

  // store the timer and number of guess if the users wins only
  Future storeWinings() async {
    var body = {
      "time": _timer.tick.toString(),
      "count": _counter,
    };
    print(body);
    print(arr);
    arr.add(body);
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    try {
      //convert arr to Json because Json is string type
      prefs.setString('recordsList', jsonEncode(arr));
    } catch (e) {
      print(e);
    }
  }

  _gussResult(String text) {
    int number = 0;
    if (_counter <= 8) {
      if (text != "" && text != null) number = int.parse(text);
      if (number == _randNumber) {
        setState(() {
          _gameIsActive = false;
          _timer.cancel();
          _isGameON = false;
          _res = "Congratulation you won!";
        });
        storeWinings().whenComplete(() => () {});
        setState(() {
          _gameIsActive = true;
        });
      } else if (_counter == 8) {
        setState(() {
          _timer.cancel();
          _res = "You Lose! the correct number was $_randNumber";
          _isGameON = false;
        });
      } else if (number > _randNumber) {
        setState(() {
          _res = "It's higher! go lower";
        });
      } else if (number < _randNumber) {
        setState(() {
          _res = "It's lower! go higher";
        });
      } else {
        setState(() {
          _timer.cancel();
          _res = "You Lose! the correct number was $_randNumber";
          _isGameON = false;
        });
      }
    } else {
      setState(() {
        _timer.cancel();
        _res = "You Lose! the correct number was $_randNumber";
        _isGameON = false;
      });
    }
  }

  void _incrementCounter() {
    setState(() {
      _counter++;
    });
  }

  @override
  //stop timer and cancel it. if users jump out of the program
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    _timer.cancel();
  }

  @override

  //for score board storage
  void initState() {
    super.initState();
    getArrOfWinings().then(
      (value) => () {
        setState(
          () {
            arr = value;
          },
        );
      },
    );
    //create random number
    _randNumber = rng.nextInt(100);
    print(_randNumber);
    //intialized timer
    _timer = Timer.periodic(Duration(seconds: 1), (timer) {
      setState(() {
        _timer = timer;
      });
    });
  }

  // we using it for getting records and put them in array
  Future getArrOfWinings() async {
    SharedPreferences instace = await SharedPreferences.getInstance();
    var res;
    try {
      res = instace.getString('recordsList');
    } catch (e) {
      print(e);
      res = null;
    }
    arr = res != null ? jsonDecode(res) : [];
    return arr;
  }

  @override
  Widget build(BuildContext context) {
    print(_randNumber);
    return Scaffold(
      appBar: AppBar(
        title: Text("${widget.title} ${_timer.tick}"),
        backgroundColor: Colors.amber,
      ),
      body: _gameIsActive
          ? Center(
              child: Column(
                children: <Widget>[
                  SizedBox(
                    height: 24,
                  ),
                  Container(
                    width: MediaQuery.of(context).size.width * .9,
                    decoration: BoxDecoration(
                      border: Border.all(
                        width: 1,
                        color: Colors.white,
                      ),
                      borderRadius: BorderRadius.circular(20.0),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(12.0),
                      child: Text(
                        '${_res ?? "go ahead!"}',
                        style: TextStyle(
                          fontSize: 24.0,
                        ),
                      ),
                    ),
                  ),
                  SizedBox(
                    height: 12.0,
                  ),
                  Container(
                    width: MediaQuery.of(context).size.width * .9,
                    child: _isGameON
                        ? TextField(
                            maxLength: 3,
                            style: TextStyle(
                              color: Colors.amber,
                            ),
                            controller: _textGusssed,
                            keyboardType: TextInputType.number,
                            decoration: InputDecoration(
                              filled: true,
                              fillColor: Colors.white,
                              hintText: "Enter a number from 0 to 100",
                              border: new OutlineInputBorder(
                                borderRadius: const BorderRadius.all(
                                  const Radius.circular(20.0),
                                ),
                                borderSide: BorderSide(
                                  color: Colors.white,
                                ),
                              ),
                              counter: Text("$_counter / 8"),
                            ),
                            inputFormatters: [
                              // FilteringTextInputFormatter(filterPattern,
                              //     allow: allow),
                              LengthLimitingTextInputFormatter(3),
                              FilteringTextInputFormatter.digitsOnly,
                            ],
                            //the value the user input
                            onSubmitted: (value) {
                              addToList(value.toString());
                              _incrementCounter();
                              _gussResult(_textGusssed.text);
                            },
                          )
                    //when the game is over andstart over game again
                        : ElevatedButton(
                            onPressed: () {
                              setState(
                                () {
                                  _isGameON = true;
                                  _counter = 0;
                                  _randNumber = rng.nextInt(100);
                                  _textGusssed.text = "";
                                  _res = null;
                                  items = [];
                                  _timer.cancel();
                                  _timer = Timer.periodic(Duration(seconds: 1),
                                      (timer) {
                                    setState(() {
                                      _timer = timer;
                                    });
                                  });
                                },
                              );
                            },
                            child: Text("Start Over!"),
                          ),
                  ),
                  Expanded(
                    child: Center(
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Container(
                          decoration: BoxDecoration(
                            border: Border.all(
                              color: Colors.white,
                            ),
                            borderRadius: BorderRadius.circular(20.0),
                          ),
                          child: ListView.builder(
                            reverse: true,
                            itemCount: items.length,
                            itemBuilder: (context, index) {
                              return items[index];
                            },
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            )
          : Center(
              child: Text("please wait..."),
            ),
      //rest the game and start the gane again
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          setState(
            () {
              _isGameON = true;
              _gameIsActive = true;
              _counter = 0;
              _randNumber = rng.nextInt(100);
              _textGusssed.text = "";
              _res = null;
              items = [];
              _timer.cancel();
              _timer = Timer.periodic(
                Duration(seconds: 1),
                (timer) {
                  setState(() {
                    _timer = timer;
                  });
                },
              );
            },
          );
        },
        tooltip: 'Rest',
        child: Icon(Icons.restart_alt),
      ),
    );
  }
}

class ScoreBoard extends StatefulWidget {
  ScoreBoard({Key? key}) : super(key: key);

  @override
  _ScoreBoardState createState() => _ScoreBoardState();
}

class _ScoreBoardState extends State<ScoreBoard> {
  late Future _future;

  Future<List> getArrOfWinings() async {
    SharedPreferences instace = await SharedPreferences.getInstance();
    var res;
    try {
      res = instace.getString('recordsList');
    } catch (e) {
      print(e);
      res = null;
    }
    var arr = res != null ? jsonDecode(res) : [];
    return arr;
  }

  @override
  void initState() {
    super.initState();
    _future = getArrOfWinings();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Center(
          child: Column(
            children: [
              SizedBox(
                height: 24.0,
              ),
              Text(
                "Scoreboard",
                style: TextStyle(
                  fontSize: 18,
                  color: Colors.amber,
                ),
              ),
              SizedBox(
                height: 18.0,
              ),
              Container(
                width: MediaQuery.of(context).size.width * .86,
                padding: EdgeInsets.only(
                  bottom: 8.0,
                ),
                child: Row(
                  children: [
                    Text(
                      '#Correct guess',
                      style: TextStyle(
                        color: Colors.amber,
                      ),
                    ),
                    Spacer(),
                    Text(
                      'Duration',
                      style: TextStyle(
                        color: Colors.amber,
                      ),
                    )
                  ],
                ),
              ),
              Container(
                width: MediaQuery.of(context).size.width * .9,
                padding: EdgeInsets.only(
                  bottom: 12.0,
                ),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(24.0),
                  color: Colors.amber,
                ),
                child: FutureBuilder(
                    future: _future,
                    builder: (context, snapshot) {
                      List arr;
                      if (snapshot.hasData) {
                        arr = snapshot.data as List;
                        return ListView.builder(
                          shrinkWrap: true,
                          itemCount: arr.length,
                          itemBuilder: (buildContext, index) {
                            return Padding(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 24.0,
                              ),
                              child: Column(
                                children: [
                                  SizedBox(
                                    height: 12.0,
                                  ),
                                  Row(
                                    children: [
                                      Expanded(
                                        child: Text(
                                          "${arr[index]['count']} out of 8",
                                          style: TextStyle(
                                            color: Color(0xff192f44),
                                          ),
                                        ),
                                      ),
                                      Text(
                                        "${arr[index]['time']} sec",
                                        style: TextStyle(
                                          color: Color(0xff192f44),
                                        ),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            );
                          },
                        );
                      } else {
                        return Center(
                          child: Text("no records yet!"),
                        );
                      }
                    }),
              ),
              SizedBox(
                height: 8.0,
              ),
              Spacer(),
              Container(
                width: MediaQuery.of(context).size.width * 0.9,
                child: ElevatedButton(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  child: Text("GO BACK"),
                ),
              ),
              SizedBox(
                height: 8.0,
              )
            ],
          ),
        ),
      ),
    );
  }
}
