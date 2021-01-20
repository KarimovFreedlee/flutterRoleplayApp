import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:new_project/index.dart';

class MyCharacterScreen extends StatefulWidget {
  MyCharacterScreen({this.name, this.documentIndex, this.characterClass});
  final String name;
  final String documentIndex;
  final String characterClass;

  @override
  _MyCharacterScreenState createState() => _MyCharacterScreenState();
}

class _MyCharacterScreenState extends State<MyCharacterScreen> {

  TextEditingController strController = TextEditingController();

  TextEditingController dexController = TextEditingController();

  TextEditingController conController = TextEditingController();

  TextEditingController intController = TextEditingController();

  TextEditingController wisController = TextEditingController();

  TextEditingController chaController = TextEditingController();
  FirebaseFirestore db;
  int number = 0;
  int _selectedIndex = 0;

  List<Widget> _widgetOptions = <Widget>[];

  @override
  initState(){
    _widgetOptions = <Widget>[
      MyCharacterAbilitiesScreen(documentIndex: widget.documentIndex,),
      MyCharacterSkillsScreen(documentIndex: widget.documentIndex, characterClass: widget.characterClass),
      MycharacterInformationScreen(documentIndex: widget.documentIndex)
    ];
    super.initState();
  }

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.name ?? ''),
      ),
      body: StreamBuilder(
        // ignore: deprecated_member_use
        stream: FirebaseFirestore.instance.collection('characters').doc(widget.documentIndex).snapshots(),
        builder: (context, snapshot) {
          if(!snapshot.hasData) return SpinKitRotatingCircle(
            color: Colors.white,
            size: 50.0,
          );
          return _widgetOptions.elementAt(_selectedIndex);
        }
      ),
      bottomNavigationBar: BottomNavigationBar(
      items: const <BottomNavigationBarItem>[
        BottomNavigationBarItem(
          icon: Icon(Icons.analytics),
          label: 'Abilitys',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.assessment),
          label: 'Skills',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.article),
          label: 'Info',
        ),
      ],
      currentIndex: _selectedIndex,
      selectedItemColor: Theme.of(context).primaryColor,
      onTap: _onItemTapped,
    ),
    );
  }
}