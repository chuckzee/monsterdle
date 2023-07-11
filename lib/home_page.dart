import 'package:flutter/material.dart';
import 'package:monsterdle/monster_block.dart';
import 'package:monsterdle/monster_api.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  // Initialize your API service
  final MonsterApi api = MonsterApi();

  // The monster data
  Map<String, dynamic> monster = {};

  // Function to get the monster data
  void getMonster() async {
    Map<String, dynamic> data = await api.getMonsterData();
    setState(() {
      monster = data;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Monsterdle'),
      ),
      body: Column(
        children: <Widget>[
          MonsterBlock(
              monster: monster), // Your custom widget to show monster data
          // TODO: Add a TextField for user input and button to submit guess
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: getMonster,
        tooltip: 'Get Monster',
        child: Icon(Icons.refresh),
      ),
    );
  }
}
