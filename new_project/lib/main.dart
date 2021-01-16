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
              primary: Colors.orange[200],
            ),
          ),
        ),
        home: StreamBuilder(
          stream: FirebaseFirestore.instance.collection('characters').snapshots(),
          builder: (context, snapshot) {
            if(!snapshot.hasData) return SpinKitRotatingCircle(
            color: Colors.white,
            size: 50.0,
          );
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
        if (!snapshot.hasData) return SpinKitRotatingCircle(
            color: Colors.white,
            size: 50.0,
          );
        return ListView(
          // ignore: deprecated_member_use
          children: snapshot.data.documents.map((document) {
            // ignore: deprecated_member_use
            var docId=document.documentID;
            return Padding(
              padding: const EdgeInsets.all(3.0),
              child: Card(
                color: Colors.grey,
                shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(15.0),
                ),
                child: Column(
                  children: [
                    Container(
                      decoration: BoxDecoration(
                        color: Theme.of(context).primaryColor,
                        borderRadius: BorderRadius.vertical(
                          top: Radius.circular(15.0),
                        )
                      ),
                      child: Stack(
                        children: [
                          Align(alignment: Alignment.center, child: Text(document['name']+' - '+document['race']+' '+ document['class'])),
                          Padding(
                            padding: const EdgeInsets.only(right: 8.0),
                            child: Align(alignment: Alignment.centerRight, child: Text('Lvl: '+'${document['Lvl']}')),
                          )  
                        ],
                      ),
                    ),
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
