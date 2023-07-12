import 'package:flutter/material.dart';
import 'dart:convert';

class MonsterBlock extends StatefulWidget {
  final Map<String, dynamic> monster;

  MonsterBlock({required this.monster});

  @override
  _MonsterBlockState createState() => _MonsterBlockState();
}

class _MonsterBlockState extends State<MonsterBlock> {
  @override
  Widget build(BuildContext context) {
    // Check for each field if it exists, then display it
    return Container(
      child: Column(
        children: <Widget>[
          // Display Image
          if (widget.monster.containsKey('image'))
            Container(
              height: 250, // set the height of the container
              child: Image.memory(
                  base64Decode(widget.monster['image'].split(',').last)),
            ),
          // Display Size
          if (widget.monster.containsKey('name'))
            Text('Size: ${widget.monster['name']}'),
          if (widget.monster.containsKey('size'))
            Text('Size: ${widget.monster['size']}'),
          if (widget.monster.containsKey('challenge'))
            Text('CR: ${widget.monster['challenge']}'),
          // Display ac
          if (widget.monster.containsKey('hp'))
            Text('HP: ${widget.monster['hp']}'),
          // Display alignment
          if (widget.monster.containsKey('alignment'))
            Text('Alignment: ${widget.monster['alignment']}'),
          // Display ac
          if (widget.monster.containsKey('ac'))
            Text('AC: ${widget.monster['ac']}'),
          // Display str
          if (widget.monster.containsKey('str'))
            Text('Strength: ${widget.monster['str']}'),
          if (widget.monster.containsKey('dex'))
            Text('Dexterity: ${widget.monster['dex']}'),
          if (widget.monster.containsKey('con'))
            Text('Constitution: ${widget.monster['con']}'),
          if (widget.monster.containsKey('int'))
            Text('Intelligence: ${widget.monster['int']}'),
          if (widget.monster.containsKey('wis'))
            Text('Wisdom: ${widget.monster['wis']}'),
          if (widget.monster.containsKey('cha'))
            Text('Charisma: ${widget.monster['cha']}'),
          if (widget.monster.containsKey('senses'))
            Text('Senses: ${widget.monster['senses']}'),
          if (widget.monster.containsKey('languages'))
            Text('Languages: ${widget.monster['languages']}'),
          if (widget.monster.containsKey('additional'))
            Text('Additional Information: ${widget.monster['additional']}'),
          if (widget.monster.containsKey('source'))
            Text('Sourcebook: ${widget.monster['source']}'),
          // and so on for all fields
        ],
      ),
    );
  }
}
