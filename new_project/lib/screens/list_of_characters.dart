import 'package:flutter/material.dart';
import 'package:new_project/index.dart';

class MyListOfCharactersScreen extends StatefulWidget {
  MyListOfCharactersScreen({Key key, this.title, this.charactersListView}) : super(key: key);
  final Widget charactersListView;
  final String title;

  @override
  _MyListOfCharactersScreenState createState() => _MyListOfCharactersScreenState();
}

class _MyListOfCharactersScreenState extends State<MyListOfCharactersScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: Container(
        child: Center(
          child: widget.charactersListView
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: ()=>Navigator.push(context, MaterialPageRoute(builder: (BuildContext context) => MyCharacterCreateScreen())),
        child: Icon(Icons.person_add),
        backgroundColor: Theme.of(context).primaryColor,
      )
    );
  }
}