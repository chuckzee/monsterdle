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
          // Display Name
          if (widget.monster.containsKey('name'))
            Text('Name: ${widget.monster['name']}'),
          // Display Size
          if (widget.monster.containsKey('size'))
            Text('Size: ${widget.monster['size']}'),
          // Display CR
          if (widget.monster.containsKey('cr'))
            Text(
                'CR: ${widget.monster['cr'] != "-" ? widget.monster['cr'] : "?"}'),
          // Display HP
          if (widget.monster.containsKey('hp'))
            Text('HP: ${widget.monster['hp']}'),
          // Display Alignment
          if (widget.monster.containsKey('alignment'))
            Text(
                'Alignment: ${widget.monster['alignment'] != "-" ? widget.monster['alignment'] : "unaligned or unknown"}'),
          // Display AC
          if (widget.monster.containsKey('ac'))
            Text('AC: ${widget.monster['ac']}'),
          // Display Type
          if (widget.monster.containsKey('type'))
            Text('Type: ${widget.monster['type']}'),
          // Display Legendary
          if (widget.monster.containsKey('legendary'))
            Text(
                'Is Legendary?: ${widget.monster['legendary'] != "-" ? widget.monster['legendary'] : "Nope"}'),
          // Display Movement
          if (widget.monster.containsKey('movement'))
            Text(
                'Movement Type: ${widget.monster['movement'] != "-" ? widget.monster['movement'] : "ground speed or stationary"}'),
          // Display Sourcebook
          if (widget.monster.containsKey('source'))
            Text('Sourcebook: ${widget.monster['source']}'),
        ],
      ),
    );
  }
}
