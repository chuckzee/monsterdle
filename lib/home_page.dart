import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:monsterdle/monster_block.dart';
import 'package:monsterdle/monster_api.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final MonsterApi api = MonsterApi();
  Map<String, dynamic> monster = {};
  TextEditingController guessController = TextEditingController();
  bool? correctGuess;
  int guessCount = 0;
  void getMonster({bool value = false}) async {
    Map<String, dynamic> data =
        await api.getMonsterData(value ? '7' : guessCount.toString());
    setState(() {
      monster = data;
    });
  }

  void getLocalData() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    guessCount = prefs.getInt('guessCount') ?? 0;
    correctGuess = prefs.getBool('correctGuess') ?? false;
  }

  @override
  void initState() {
    super.initState();
    getLocalData();
    if (correctGuess == true) {
      print('guessCount in initState: ${correctGuess}');
      getMonster(value: true);
    } else {
      getMonster();
    }
  }

  void submitGuess() async {
    print(
        'Response: ${monster['id']} ${guessController.text} ${guessCount}'); // print the response
    bool? result =
        await api.submitGuess(guessController.text, guessCount.toString());
    setState(() {
      correctGuess = result;
    });
    incrementGuessCount();
    setLocalData();

    if (correctGuess != true) {
      getMonster();
    } else {
      Map<String, dynamic> data = await api.getMonsterData('7');
      setState(() {
        monster = data;
      });
    }
  }

  void setLocalData() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setInt('guessCount', guessCount);
    prefs.setBool('correctGuess', correctGuess ?? false);
  }

  void incrementGuessCount() {
    guessCount += 1;
    setLocalData();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Monsterdle'),
      ),
      body: Column(
        children: <Widget>[
          if (correctGuess == true) ...[
            Text('You got it!', style: TextStyle(fontSize: 24)),
          ],
          if (correctGuess == false && guessCount >= 8) ...[
            Text('Better luck next time.', style: TextStyle(fontSize: 24)),
          ],
          MonsterBlock(
            monster: monster,
          ),
          Container(
            width:
                MediaQuery.of(context).size.width * 0.5, // 50% of screen width
            child: TextField(
              controller: guessController,
              decoration: InputDecoration(
                labelText: 'Enter your guess',
              ),
              readOnly: correctGuess == true,
            ),
          ),
          ElevatedButton(
            onPressed: correctGuess == true ? null : submitGuess,
            child: Text('Submit Guess'),
          ),
        ],
      ),
    );
  }
}
