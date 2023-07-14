import 'dart:convert';
import 'package:flutter/services.dart' show rootBundle;

class MonsterData {
  List<String> monsterNames = [];

  Future<void> loadMonsterData() async {
    String jsonString =
        await rootBundle.loadString('lib/data/monster_data.json');
    Map<String, dynamic> jsonData = jsonDecode(jsonString);

    monsterNames = List<String>.from(
        jsonData['monsters'].map((monster) => monster['name']));
  }
}
