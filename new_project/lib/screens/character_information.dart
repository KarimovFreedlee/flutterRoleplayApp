import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:new_project/index.dart';

class MycharacterInformationScreen extends StatefulWidget {
  final String documentIndex;

  const MycharacterInformationScreen({Key key, this.documentIndex}) : super(key: key);
  @override
  _MycharacterInformationScreenState createState() => _MycharacterInformationScreenState();

}

class _MycharacterInformationScreenState extends State<MycharacterInformationScreen> {

  FirebaseFirestore dbOfClasses = FirebaseFirestore.instance;
  List<String> classes = ['Bard', 'Barbarian', 'Cleric', 'Druid','Fighter','Monk', 'Paladin', 'Ranger', 'Rogue', 'Sorcerer', 'Wizard'];

  String dropdownClassValue = 'Bard';
  
  int bab = 0, fortitude= 0 , reflex= 0, will = 0; 

  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
      stream: FirebaseFirestore.instance.collection('characters').doc(widget.documentIndex).snapshots(),
      builder: (context, snapshot) {
        if(!snapshot.hasData) return SpinKitFadingCircle(
          color: Colors.white,
          size: 50.0,
        );
        return Padding(
          padding: const EdgeInsets.all(8.0),
          child: ListView(
            children: [
              Card(
                child: Container(
                  height: 50,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      Text(
                        'Race:',
                        textAlign: TextAlign.center,
                      ),
                      Text(
                        '${snapshot.data['race']}',
                        textAlign: TextAlign.center,
                      ),
                      Text(
                        'Class:',
                        textAlign: TextAlign.center,
                      ),
                      Text(
                        '${snapshot.data['class']}',
                        textAlign: TextAlign.center,
                      ),
                      Text(
                        'Level:',
                        textAlign: TextAlign.center,
                      ),
                      Text(
                        '${snapshot.data['Lvl']}',
                        textAlign: TextAlign.center,
                      ),
                      Text(
                        'Xp: ',
                        textAlign: TextAlign.center,
                      ),
                      Text(
                        '${snapshot.data['XP']}',
                        textAlign: TextAlign.center,
                      ),
                    ],
                  ),
                ),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(100.0),
                      child: Container(
                        height: 160,
                        width: 160,
                        color: Colors.grey[800],
                        child: Text('Avatar is going to be here'),
                      ),
                    ),
                  ),
                  Column(
                    children: [
                      Card(
                        child: Container(
                          alignment: Alignment.center,
                          height: 50,
                          width: 120,
                          child: Text('Initiative: '+ '${_modifier(snapshot.data['DEX'])}'),
                        ),
                      ),
                      Card(
                        child: Container(
                          alignment: Alignment.center,
                          height: 50,
                          width: 120,
                          child: Text('AC: '+ '${10+_modifier(snapshot.data['DEX'])}'),
                        ),
                      ),
                      Card(
                        child: Container(
                          alignment: Alignment.center,
                          height: 50,
                          width: 120,
                          child: Text('HP: '+ '${snapshot.data['HP']}'),
                        ),
                      ),
                    ],
                  )
                ],
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  saveThrowsContainer('Fortitude', '${snapshot.data['FORTITUDE'] + _modifier(snapshot.data['CON'])}'),
                  saveThrowsContainer('Reflex', '${snapshot.data['REFLEX'] + _modifier(snapshot.data['DEX'])}'),
                  saveThrowsContainer('Will', '${snapshot.data['WILL'] + _modifier(snapshot.data['WIS'])}'),
                ],
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Card(
                    child: Container(
                      alignment: Alignment.center,
                      height: 50,
                      width: 150,
                      child: Text(
                        'Basic Atack Bonus',
                        textAlign: TextAlign.center,
                      ),
                    )
                  ),
                  Card(
                    child: Container(
                      alignment: Alignment.center,
                      height: 50,
                      width: 50,
                      child: Text(
                        '${snapshot.data['BAB']}',
                        textAlign: TextAlign.center,
                      ),
                    )
                  ),
                ],
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
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
                    items: classes
                        .map<DropdownMenuItem<String>>((String value) {
                      return DropdownMenuItem<String>(
                        value: value,
                        child: Text(value),
                      );
                    }).toList()
                  ),
                  RaisedButton(
                    onPressed: () async {
                      switch(dropdownClassValue){  // switch case can be optimased
                        case 'Bard':
                          await dbOfClasses.collection('classes').doc('bard').get().then((value) => 
                            setState((){
                              List babArray = value.data()['BAB'];
                              bab = babArray[snapshot.data['Lvl']];
                              fortitude = value.data()['FORTITUDE'][snapshot.data['Lvl']];
                              reflex = value.data()['REFLEX'][snapshot.data['Lvl']];
                              will = value.data()['WILL'][snapshot.data['Lvl']];
                            })
                          );

                          levelUpCharacter(snapshot.data['Lvl'], _modifier(snapshot.data['INT'])+6+ snapshot.data['SKILL_RANKS']); // should probably inv this function one time and make another var skillRanks
                        break;
                        case 'Barbarian':
                          await dbOfClasses.collection('classes').doc('barbarian').get().then((value) => 
                            setState((){
                              List babArray = value.data()['BAB'];
                              bab = babArray[snapshot.data['Lvl']];
                              fortitude = value.data()['FORTITUDE'][snapshot.data['Lvl']];
                              reflex = value.data()['REFLEX'][snapshot.data['Lvl']];
                              will = value.data()['WILL'][snapshot.data['Lvl']];
                            })
                          );
                          levelUpCharacter(snapshot.data['Lvl'], _modifier(snapshot.data['INT'])+4+ snapshot.data['SKILL_RANKS']);
                        break;
                        case 'Cleric':
                          await dbOfClasses.collection('classes').doc('cleric').get().then((value) => 
                            setState((){
                              List babArray = value.data()['BAB'];
                              bab = babArray[snapshot.data['Lvl']];
                              fortitude = value.data()['FORTITUDE'][snapshot.data['Lvl']];
                              reflex = value.data()['REFLEX'][snapshot.data['Lvl']];
                              will = value.data()['WILL'][snapshot.data['Lvl']];
                            })
                          );
                          levelUpCharacter(snapshot.data['Lvl'], _modifier(snapshot.data['INT'])+2+ snapshot.data['SKILL_RANKS']);
                        break;
                        case 'Druid':
                          await dbOfClasses.collection('classes').doc('druid').get().then((value) => 
                            setState((){
                              List babArray = value.data()['BAB'];
                              bab = babArray[snapshot.data['Lvl']];
                              fortitude = value.data()['FORTITUDE'][snapshot.data['Lvl']];
                              reflex = value.data()['REFLEX'][snapshot.data['Lvl']];
                              will = value.data()['WILL'][snapshot.data['Lvl']];
                            })
                          );
                          levelUpCharacter(snapshot.data['Lvl'], _modifier(snapshot.data['INT'])+4+ snapshot.data['SKILL_RANKS']);
                        break;
                        case 'Fighter':
                          await dbOfClasses.collection('classes').doc('fighter').get().then((value) => 
                            setState((){
                              List babArray = value.data()['BAB'];
                              bab = babArray[snapshot.data['Lvl']];
                              fortitude = value.data()['FORTITUDE'][snapshot.data['Lvl']];
                              reflex = value.data()['REFLEX'][snapshot.data['Lvl']];
                              will = value.data()['WILL'][snapshot.data['Lvl']];
                            })
                          );
                          levelUpCharacter(snapshot.data['Lvl'], _modifier(snapshot.data['INT'])+2+ snapshot.data['SKILL_RANKS']);
                        break;
                        case 'Monk':
                          await dbOfClasses.collection('classes').doc('monk').get().then((value) => 
                            setState((){
                              List babArray = value.data()['BAB'];
                              bab = babArray[snapshot.data['Lvl']];
                              fortitude = value.data()['FORTITUDE'][snapshot.data['Lvl']];
                              reflex = value.data()['REFLEX'][snapshot.data['Lvl']];
                              will = value.data()['WILL'][snapshot.data['Lvl']];
                            })
                          );
                          levelUpCharacter(snapshot.data['Lvl'], _modifier(snapshot.data['INT'])+4+ snapshot.data['SKILL_RANKS']);
                        break;
                        case 'Paladin':
                          await dbOfClasses.collection('classes').doc('paladin').get().then((value) => 
                            setState((){
                              List babArray = value.data()['BAB'];
                              bab = babArray[snapshot.data['Lvl']];
                              fortitude = value.data()['FORTITUDE'][snapshot.data['Lvl']];
                              reflex = value.data()['REFLEX'][snapshot.data['Lvl']];
                              will = value.data()['WILL'][snapshot.data['Lvl']];
                            })
                          );
                          levelUpCharacter(snapshot.data['Lvl'], _modifier(snapshot.data['INT'])+2+ snapshot.data['SKILL_RANKS']);
                        break;
                        case 'Ranger':
                          await dbOfClasses.collection('classes').doc('ranger').get().then((value) => 
                            setState((){
                              List babArray = value.data()['BAB'];
                              bab = babArray[snapshot.data['Lvl']];
                              fortitude = value.data()['FORTITUDE'][snapshot.data['Lvl']];
                              reflex = value.data()['REFLEX'][snapshot.data['Lvl']];
                              will = value.data()['WILL'][snapshot.data['Lvl']];
                            })
                          );
                          levelUpCharacter(snapshot.data['Lvl'], _modifier(snapshot.data['INT'])+6+ snapshot.data['SKILL_RANKS']);
                        break;
                        case 'Rogue':
                          await dbOfClasses.collection('classes').doc('rogue').get().then((value) => 
                            setState((){
                              List babArray = value.data()['BAB'];
                              bab = babArray[snapshot.data['Lvl']];
                              fortitude = value.data()['FORTITUDE'][snapshot.data['Lvl']];
                              reflex = value.data()['REFLEX'][snapshot.data['Lvl']];
                              will = value.data()['WILL'][snapshot.data['Lvl']];
                            })
                          );
                          levelUpCharacter(snapshot.data['Lvl'], _modifier(snapshot.data['INT'])+8+ snapshot.data['SKILL_RANKS']);
                        break;
                        case 'Sorcerer':
                          await dbOfClasses.collection('classes').doc('sorcerer').get().then((value) => 
                            setState((){
                              List babArray = value.data()['BAB'];
                              bab = babArray[snapshot.data['Lvl']];
                              fortitude = value.data()['FORTITUDE'][snapshot.data['Lvl']];
                              reflex = value.data()['REFLEX'][snapshot.data['Lvl']];
                              will = value.data()['WILL'][snapshot.data['Lvl']];
                            })
                          );
                          levelUpCharacter(snapshot.data['Lvl'], _modifier(snapshot.data['INT'])+2+ snapshot.data['SKILL_RANKS']);
                        break;
                        case 'Wizard':
                          await dbOfClasses.collection('classes').doc('wizard').get().then((value) => 
                            setState((){
                              List babArray = value.data()['BAB'];
                              bab = babArray[snapshot.data['Lvl']];
                              fortitude = value.data()['FORTITUDE'][snapshot.data['Lvl']];
                              reflex = value.data()['REFLEX'][snapshot.data['Lvl']];
                              will = value.data()['WILL'][snapshot.data['Lvl']];
                            })
                          );
                          levelUpCharacter(snapshot.data['Lvl'], _modifier(snapshot.data['INT'])+2+ snapshot.data['SKILL_RANKS']);
                        break;
                      }
                    Navigator.pop(context);
                    },
                    child: Text('Level up', style: TextStyle(fontSize: 20)
                    ),
                  ),
                ],
              ),
              Text('Some character bio', textAlign: TextAlign.center),
              ElevatedButton(
                onPressed: () {
                  alert();
                },
                child: Text('Delete character', style: TextStyle(fontSize: 20)
                ),
              ),
            ],
          ),
        );
      }
    );
  }

  Widget saveThrowsContainer(String text, value, {double width = 100}){
    return Container(
      child: Column(
        children: [
          Card(
            child: Container(
              alignment: Alignment.center,
              height: 50,
              width: width,
              child: Text(text),
            )
          ),
          Card(
            child: Container(
              alignment: Alignment.center,
              height: 80,
              width: width,
              child: Text(value),
            ),
          ),
        ],
      ),
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

  Future<void> alert(){
    return showDialog<void>(
    context: context,
    barrierDismissible: false, // user must tap button!
    builder: (BuildContext context) {
      return AlertDialog(
        title: Text('Delete character'),
        content: SingleChildScrollView(
          child: ListBody(
            children: <Widget>[
              Text('This will delete character.'),
              Text('Are you sure you want to delete this character?'),
            ],
          ),
        ),
        actions: <Widget>[
          TextButton(
            child: Text('Accept'),
            onPressed: () {
              Navigator.of(context).pop();
              Navigator.pop(context);
              deleteCharacter();
            },
          ),
          TextButton(
            child: Text('Cancel'),
            onPressed: () {
              Navigator.of(context).pop();
            },
          ),
        ],
      );
    },
  );
  }
  
  void deleteCharacter() async{
    await FirebaseFirestore.instance.collection('characters').doc(widget.documentIndex).delete();
  }

  void levelUpCharacter(int level, skillRanks) async{
    level++;
    await FirebaseFirestore.instance.collection('characters').doc(widget.documentIndex).update({
      'Lvl' : level,
      'SKILL_RANKS': skillRanks,
      'BAB' : bab,
      'FORTITUDE': fortitude,
      'REFLEX' : reflex,
      'WILL': will,
      'LEVEL_UP': true
      });
  }
}