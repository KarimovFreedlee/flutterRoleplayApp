import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:new_project/index.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class MyCharacterCreateScreen extends StatefulWidget {
  MyCharacterCreateScreen();
  

  @override
  _MyCharacterCreateScreenState createState() => _MyCharacterCreateScreenState();

}

class _MyCharacterCreateScreenState extends State<MyCharacterCreateScreen> {
  
  TextEditingController nameController = TextEditingController();

  TextEditingController strController = TextEditingController();

  TextEditingController dexController = TextEditingController();

  TextEditingController conController = TextEditingController();

  TextEditingController intController = TextEditingController();

  TextEditingController wisController = TextEditingController();

  TextEditingController chaController = TextEditingController();
  
  final _formKey = GlobalKey<FormState>();
  String dropdownClassValue = 'Bard';
  String dropdownRaceValue = 'Dwarf';
  final databaseReference = FirebaseFirestore.instance;

  RanksCounter ranksCounter = RanksCounter();
  int size;
  int number = 0;
  @override
  Widget build(BuildContext context) {
      databaseReference.collection("characters")
      .get()
      .then((res) => size = res.size);
    return  Scaffold(
      appBar: AppBar(
        title: Text('Character creator')
      ),
      body: Form(
        key: _formKey,
        child: ListView(
          children: <Widget>[
            TextFormField(
              decoration: InputDecoration(
                icon: Icon(Icons.person),
                labelText: 'Character name',
              ),
              controller: nameController,
              // validator: (value) {
              //   if (value.isEmpty) {
              //     return 'Please enter your character name';
              //   }
              //   return null;
              // },
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children:[
                Text('Race:'),
                  DropdownButton<String>(
                  value: dropdownRaceValue,
                  icon: Icon(Icons.arrow_downward),
                  iconSize: 24,
                  elevation: 16,
                  style: TextStyle(color: Colors.grey),
                  underline: Container(
                    height: 2,
                    color: Colors.grey,
                  ),
                  onChanged: (String newValue) {
                    setState(() {
                      dropdownRaceValue = newValue;
                    });
                  },
                  items: <String>['Dwarf', 'Elf', 'Gnome', 'Half Elf','Half Orc','Hafling', 'Human']
                      .map<DropdownMenuItem<String>>((String value) {
                    return DropdownMenuItem<String>(
                      value: value,
                      child: Text(value),
                    );
                  }).toList()
                ),
              ]
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children:[
                Text('Class:'),
                  DropdownButton<String>(
                  value: dropdownClassValue,
                  icon: Icon(Icons.arrow_downward),
                  iconSize: 24,
                  elevation: 16,
                  style: TextStyle(color: Colors.grey),
                  underline: Container(
                    height: 2,
                    color: Colors.grey,
                  ),
                  onChanged: (String newValue) {
                    setState(() {
                      dropdownClassValue = newValue;
                    });
                  },
                  items: <String>['Bard', 'Barbarian', 'Cleric', 'Druid','Fighter','Monk', 'Paladin', 'Ranger', 'Rogue', 'Sorcerer', 'Wizard']
                      .map<DropdownMenuItem<String>>((String value) {
                    return DropdownMenuItem<String>(
                      value: value,
                      child: Text(value),
                    );
                  }).toList()
                ),
              ]
            ),
            Table(
              border: TableBorder.all(),
              children: [
               TableRow(
                children: [
                  _tableContainer(Text('Name'), height: 30),
                  _tableContainer(Text('Score'), height: 30),
                  _tableContainer(Text('Modify'), height: 30),
                  _tableContainer(Text(''), height: 30),
                ]
              ),
              _tableRow('STR', _abilityScore(strController), strController),
              _tableRow('DEX', _abilityScore(dexController), dexController),
              _tableRow('CON', _abilityScore(conController), conController),
              _tableRow('INT', _abilityScore(intController), intController),
              _tableRow('WIS', _abilityScore(wisController), wisController),
              _tableRow('CHA', _abilityScore(chaController), chaController),
              ],
            ),
            Center(
              child: ElevatedButton(
                onPressed: () {
                  if(!nameController.text.isEmpty){
                    createRecord(nameController.text, dropdownRaceValue, dropdownClassValue);
                    Navigator.pop(context);
                  }
                },
                child: Text('Submit'),
              ),
            ),
          ],
        ),
      ),
    );
  }

  TableRow _tableRow(String title, Widget _secondColumn, TextEditingController textController, {Widget widget}){
    return TableRow(
      children: [
        _tableContainer(Text(title)),
        _tableContainer(_secondColumn),
        _tableContainer(Text(_modifier(textController.text).toString())), 
        _tableContainer(widget), 
      ]
    );
  }

  Widget _tableContainer(Widget child, {double height = 100,}){
    return Container(
      height: height,
      alignment: Alignment.center,
      child: child,
    );
  }

   int _modifier (String val){
    if(val == null || val.isEmpty){
      return 0;
    }
    var value = int.parse(val);
    if(value % 2 == 0){
      return (value - 10)~/2;
    } else{
      return (value - 11)~/2;
    }
  }

  Widget _abilityScore(TextEditingController textController){
    return Container(
          width: 30,
          child: TextFormField(
              controller: textController,
              decoration: InputDecoration(
                border: InputBorder.none,
                counterText: '',
              ),
              onEditingComplete: () => setState((){}),
              maxLength: 3,
              keyboardType: TextInputType.number,
              inputFormatters: [
                FilteringTextInputFormatter.digitsOnly
              ],
            ),
      );
  } 

  void createRecord(String name, race, characterClass) async {
      await databaseReference.collection("characters")
      .add({
        'name': name,
        'race': race,
        'class': characterClass,
        'STR': strController.text,
        'DEX': dexController.text,
        'CON': conController.text,
        'INT': intController.text,
        'WIS': wisController.text,
        'CHA': chaController.text,
        // 'ID': size
      });
  }

}
