import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

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
        if(!snapshot.hasData) return Text('Loading data....');
        return ListView(
          children: [
            Container(
              padding: EdgeInsets.symmetric(vertical: 16.0),
              height: 50,
              child: Text(
                'Info',
                textAlign: TextAlign.center,
              )
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                Text('AC: '+ '${10+_modifier(snapshot.data['DEX'])}'),
                Text('Initiative: '+ '${_modifier(snapshot.data['DEX'])}'),
                Text('HP: '+ '${snapshot.data['HP']}')
              ],
            ),
             Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                Text('Fortitude: '+ '${snapshot.data['FORTITUDE']}'),
                Text('Reflex: '+ '${snapshot.data['REFLEX']}'),
                Text('Will: '+ '${snapshot.data['WILL']}')
              ],
            ),
            Container(
              padding: EdgeInsets.symmetric(vertical: 16.0),
              height: 50,
              child: Text(
                'Basic Atack Bonus: ${snapshot.data['BAB']}',
                textAlign: TextAlign.center,
              )
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
        );
      }
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