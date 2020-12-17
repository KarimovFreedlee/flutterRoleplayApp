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
          primarySwatch: Colors.blue,
        ),
        home: StreamBuilder(
          stream: FirebaseFirestore.instance.collection('characters').snapshots(),
          builder: (context, snapshot) {
            if(!snapshot.hasData) return Text('loading data');
            return MyListOfCharactersScreen(
              title: 'Flutter Demo Home Page',
              charactersListView: new CharactersList(),
              );
          }
        ),
    );
  }
}

class CharactersList extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
      stream: FirebaseFirestore.instance.collection('characters').snapshots(),
      builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
        if (!snapshot.hasData) return Text('Loading...');
        return ListView(
          // ignore: deprecated_member_use
          children: snapshot.data.documents.map((document) {
            return ListTile(
              title: Text(document['name']),
              subtitle: Text(document['race']+' '+ document['class']),
              onTap: ()=>Navigator.push(context, MaterialPageRoute(
                builder: (BuildContext context) => MyCharacterScreen(name: document['name'], documentIndex: document['ID']))),
            );
          }).toList(),
        );
      },
    );
  }
}
