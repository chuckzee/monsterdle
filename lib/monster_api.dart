import 'package:http/http.dart' as http;
import 'dart:convert';

class MonsterApi {
  final String baseUrl = "https://monsterdle-backend.azurewebsites.net/";
  // final String baseUrl = "http://localhost:3000";

  Future<Map<String, dynamic>> getMonsterData(String guessNumber) async {
    DateTime now = DateTime.now();
    String monsterId =
        ((now.year * 10000 + now.month * 100 + now.day) % 800).toString();

    var url =
        Uri.parse('$baseUrl/monsters/$monsterId?guessNumber=$guessNumber');
    http.Response response = await http.get(url);
    return json.decode(response.body);
  }

  Future<bool> submitGuess(String guess, String guessNumber) async {
    DateTime now = DateTime.now();
    String monsterId =
        ((now.year * 10000 + now.month * 100 + now.day) % 800).toString();
    var url = Uri.parse(
        '$baseUrl/monsters/$monsterId/guess?guess=$guess&guessNumber=$guessNumber');
    http.Response response = await http.get(url);
    if (response.statusCode == 200) {
      bool result = json.decode(response.body);
      return result;
    } else {
      throw Exception('Failed to submit guess');
    }
  }
}
