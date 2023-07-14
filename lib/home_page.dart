import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:monsterdle/monster_block.dart';
import 'package:monsterdle/monster_api.dart';
import 'package:monsterdle/data/monster_data.dart';
import 'package:google_fonts/google_fonts.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final MonsterApi api = MonsterApi();
  MonsterData monsterData = MonsterData();
  Map<String, dynamic> monster = {};
  TextEditingController guessController = TextEditingController();
  bool? correctGuess;
  int guessCount = 0;
  Future? loadMonsterFuture;

  void getMonster() async {
    getLocalData();

    if (correctGuess == true) {
      Map<String, dynamic> data = await api.getMonsterData("7");
      setState(() {
        monster = data;
      });
      print("correct call ${correctGuess}");
    } else {
      Map<String, dynamic> data =
          await api.getMonsterData(guessCount.toString());
      setState(() {
        monster = data;
      });
      print("correct call ${guessCount}");
    }
  }

  @override
  void initState() {
    super.initState();
    setupData();
    loadMonsterFuture = monsterData.loadMonsterData();
  }

  Future<void> setupData() async {
    await Future(() => getLocalData());
    getMonster();
  }

  void getLocalData() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? lastSavedTime = prefs.getString('lastSavedTime');

    if (lastSavedTime != null) {
      DateTime lastDate = DateTime.parse(lastSavedTime);
      DateTime currentDate = DateTime.now();

      // Check if lastSavedTime is from a previous day
      if (lastDate.isBefore(
          DateTime(currentDate.year, currentDate.month, currentDate.day))) {
        guessCount = 0;
        correctGuess = false;
      } else {
        guessCount = prefs.getInt('guessCount') ?? 0;
        correctGuess = prefs.getBool('correctGuess') ?? false;
      }
    } else {
      guessCount = 0;
      correctGuess = false;
    }
  }

  void submitGuess() async {
    print(
        'Response: ${monster['id']} ${guessController.text} ${guessCount}'); // print the response
    bool? result =
        await api.submitGuess(guessController.text, guessCount.toString());
    setAnswerTruthyness(result);
    incrementGuessCount();
    setLocalData();
    getMonster();
    guessController.clear();
  }

  void setLocalData() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setInt('guessCount', guessCount);
    prefs.setBool('correctGuess', correctGuess ?? false);
    prefs.setString('lastSavedTime', DateTime.now().toIso8601String());
  }

  void incrementGuessCount() {
    guessCount += 1;
    setLocalData();
  }

  void setAnswerTruthyness(bool value) {
    correctGuess = value;
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: loadMonsterFuture,
      builder: (context, snapshot) {
        if (snapshot.connectionState != ConnectionState.done) {
          return Center(child: CircularProgressIndicator());
        }

        if (snapshot.hasError) {
          return Center(
              child: Text("An error occurred: ${snapshot.error}",
                  style: GoogleFonts.ptSerif(fontSize: 20, color: Colors.red)));
        }

        return Scaffold(
          appBar: AppBar(
            title: Text('Monsterdle', style: GoogleFonts.ptSerif(fontSize: 24)),
            backgroundColor: Colors.deepPurple,
          ),
          body: SingleChildScrollView(
            child: Center(
              child: Padding(
                padding: EdgeInsets.all(10.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    SizedBox(height: 20.0),
                    if (correctGuess == true) ...[
                      Text('You got it!',
                          style: GoogleFonts.ptSerif(
                              fontSize: 24, color: Colors.green)),
                    ],
                    if (correctGuess == false && guessCount >= 7) ...[
                      Text('Better luck next time.',
                          style: GoogleFonts.ptSerif(
                              fontSize: 24, color: Colors.orange)),
                    ],
                    SizedBox(height: 20.0),
                    MonsterBlock(
                      monster: monster,
                    ),
                    SizedBox(height: 20.0),
                    Container(
                      width: MediaQuery.of(context).size.width * 0.5,
                      child: Autocomplete<String>(
                        optionsBuilder: (TextEditingValue textEditingValue) {
                          if (textEditingValue.text == '') {
                            return const Iterable<String>.empty();
                          }

                          return monsterData.monsterNames
                              .where((String option) {
                            return option
                                .toLowerCase()
                                .contains(textEditingValue.text.toLowerCase());
                          }).toList();
                        },
                        onSelected: (String selection) {
                          print('You selected $selection');
                        },
                        fieldViewBuilder: (BuildContext context,
                            TextEditingController textEditingController,
                            FocusNode focusNode,
                            VoidCallback onFieldSubmitted) {
                          guessController = textEditingController;
                          return TextField(
                            controller: textEditingController,
                            focusNode: focusNode,
                            onSubmitted:
                                (correctGuess == true || guessCount >= 7)
                                    ? null
                                    : (value) {
                                        guessController.text = value;
                                        submitGuess();
                                      },
                            decoration: InputDecoration(
                              labelText: 'Enter your guess',
                              fillColor: Colors.white,
                              filled: true,
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(10.0),
                                borderSide: BorderSide(),
                              ),
                            ),
                            style: TextStyle(fontFamily: 'Georgia'),
                            readOnly: (correctGuess == true || guessCount >= 7),
                          );
                        },
                      ),
                    ),
                    SizedBox(height: 20.0),
                    ElevatedButton(
                      onPressed: (correctGuess == true || guessCount >= 7)
                          ? null
                          : submitGuess,
                      child: Text('Submit Guess',
                          style: GoogleFonts.ptSerif(fontSize: 18)),
                      style: ElevatedButton.styleFrom(
                        primary: Colors.deepPurple, // button's fill color
                        onPrimary: Colors.white, // button's text color
                        onSurface: Colors.grey, // button's border color
                      ),
                    ),
                    SizedBox(height: 20.0),
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}
