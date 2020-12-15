import 'package:flutter/material.dart';
import 'package:new_project/index.dart';
import 'dart:math';

class MyListOfCharactersScreen extends StatefulWidget {
  MyListOfCharactersScreen({Key key, this.title, this.characterName, this.charactersList, this.characterRace, this.characterClass}) : super(key: key);
  final String characterName;
  final String characterRace;
  final String characterClass;
  final List charactersList;
  final String title;

  @override
  _MyListOfCharactersScreenState createState() => _MyListOfCharactersScreenState();
}

class _MyListOfCharactersScreenState extends State<MyListOfCharactersScreen> {
  var rng = new Random();
  final _list = ['Арсен', "Владислав", "Артур", "Хуй"];
  final _raceList = ['Dwarf', 'Elf', 'Gnome', 'Half Elf','Half Orc','Hafling', 'Human'];
  final _classList = ['Bard', 'Barbarian', 'Cleric', 'Druid','Fighter','Monk', 'Paladin', 'Ranger', 'Rogue', 'Sorcerer', 'Wizard'];
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: Container(
        color: Colors.grey[350],
        child: Center(
          child: ListView.separated(
            itemCount: widget.charactersList.length,
            separatorBuilder: (BuildContext context, int index) => Divider(),
            padding: EdgeInsets.symmetric(vertical: 16.0),
            itemBuilder: (_, int index){
              return Container(
                color: Colors.white,
                child: ListTile(
                  title: Text(widget.characterName),
                  contentPadding: EdgeInsets.symmetric(horizontal: 20.0, vertical: 10.0),
                  subtitle: Text(widget.characterRace +' ' + widget.characterClass),
                  trailing: Text('Lvl '+rng.nextInt(21).toString()),
                  onTap: ()=>Navigator.push(context, MaterialPageRoute(builder: (BuildContext context) => MyCharacterScreen(name: widget.characterName))),
                ),
              );
            },
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: ()=>Navigator.push(context, MaterialPageRoute(builder: (BuildContext context) => MyCharacterCreateScreen(listOfNames: _list, listCallback: _addCharacterToList))),
        child: Icon(Icons.person_add)
      )
    );
  }
  void _addCharacterToList(String name){
    setState((){
      // widget.charactersList.add(name);
    });
  }
}