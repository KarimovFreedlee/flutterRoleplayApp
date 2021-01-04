import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:new_project/index.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        title: 'Flutter Demo',
        theme: ThemeData(
          brightness: Brightness.dark,
          primaryColor: Colors.orange[200],
          accentColor: Color(0xff3f2318),
          elevatedButtonTheme: ElevatedButtonThemeData(
            style: ElevatedButton.styleFrom(
              primary: Color(0xffefda91),
            ),
          ),
        ),
        home: StreamBuilder(
          stream: FirebaseFirestore.instance.collection('characters').snapshots(),
          builder: (context, snapshot) {
            if(!snapshot.hasData) return Text('loading data');
            return MyListOfCharactersScreen(
              title: 'Pathfinder characters list',
              charactersListView: new CharactersList(),
              );
          }
        ),
    );
  }
}

class CharactersList extends StatelessWidget {

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

  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
      stream: FirebaseFirestore.instance.collection('characters').snapshots(),
      builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
        if (!snapshot.hasData) return Text('Loading...');
        return ListView(
          // ignore: deprecated_member_use
          children: snapshot.data.documents.map((document) {
            // ignore: deprecated_member_use
            var docId=document.documentID;
            return Padding(
              padding: const EdgeInsets.all(3.0),
              child: Card(
                color: Color(0xff3a1f14),
                shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(15.0),
                ),
                child: Column(
                  children: [
                    Center(child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        Text(document['name']+' - '+document['race']+' '+ document['class']),
                        Text('Lvl: '+'${document['Lvl']}')
                      ],
                    )),
                    ListTile(
                      title: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: [
                          Text('HP: ${document['HP']}'),
                          Text('AC: ${10+_modifier(document['DEX'])}'),
                          Text('Initiative: ${_modifier(document['DEX'])}')
                        ],
                      ),
                      onTap: ()=>Navigator.push(context, MaterialPageRoute(
                        builder: (BuildContext context) => MyCharacterScreen(name: document['name'], documentIndex: docId))),
                    ),
                  ],
                ),
              ),
            );
          }).toList(),
        );
      },
    );
  }
}
