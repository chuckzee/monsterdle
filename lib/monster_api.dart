import 'package:http/http.dart' as http;
import 'dart:convert';

class MonsterApi {
  final String baseUrl = "https://your_api_url.com";

  Future<Map<String, dynamic>> getMonsterData() async {
    // TODO: Add the logic to determine the monsterId based on the current date
    String monsterId = "monster_id";

    http.Response response = await http.get('$baseUrl/monster/$monsterId');
    return json.decode(response.body);
  }

  // TODO: Add the method for submitting a guess
}
