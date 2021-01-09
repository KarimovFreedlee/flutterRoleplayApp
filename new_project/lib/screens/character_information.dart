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
                  saveThrowsContainer('Fortitude', '${snapshot.data['FORTITUDE']}'),
                  saveThrowsContainer('Reflex', '${snapshot.data['REFLEX']}'),
                  saveThrowsContainer('Will', '${snapshot.data['WILL']}'),
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
              ButtonBar(
                alignment: MainAxisAlignment.center,
                children: [
                  ElevatedButton(
                    onPressed: () {
                      alert();
                    },
                    child: Text('Delete character', style: TextStyle(fontSize: 20)
                    ),
                  ),
                  RaisedButton(
                    onPressed: null,
                    child: Text('Edit character', style: TextStyle(fontSize: 20)
                    ),
                  ),
                ],
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
}