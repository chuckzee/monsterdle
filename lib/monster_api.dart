import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';

class MonsterApi {
  final String baseUrl = "https://monsterdle-backend.azurewebsites.net";

  Future<Map<String, dynamic>> getMonsterData(String guessNumber) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    // Check the value of correctGuess in shared preferences
    bool? correctGuess = prefs.getBool('correctGuess') ?? false;
    correctGuess == true ? guessNumber = '7' : guessNumber = guessNumber;
    // if guessNumber is greater than 7, and correctGuess = false, then set guessNumber to 8
    if (int.parse(guessNumber) > 7 && correctGuess == false) {
      guessNumber = '7';
    }
    DateTime now = DateTime.now();
    String monsterId =
        ((now.year * 10000 + now.month * 100 + now.day) % 800).toString();

    var url = Uri.parse('$baseUrl/monsters/$monsterId?guess=$guessNumber');
    http.Response response = await http.get(url);
    print('Response: ${response.body}'); // print the response
    return json.decode(response.body);
  }

  Future<bool> submitGuess(String guess, String guessNumber) async {
    DateTime now = DateTime.now();
    String monsterId =
        ((now.year * 10000 + now.month * 100 + now.day) % 800).toString();
    var url = Uri.parse('$baseUrl/monsters/$monsterId/guess?guess=$guess');
    http.Response response = await http.get(url);
    print('Response: ${response.body}'); // print the response
    if (response.statusCode == 200) {
      Map<String, dynamic> result = json.decode(response.body);
      return result['correct'];
    } else {
      throw Exception('Failed to submit guess');
    }
  }
}
