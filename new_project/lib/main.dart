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
              characterName: snapshot.data.documents[0]['name'],
              characterRace: snapshot.data.documents[0]['race'],
              characterClass: snapshot.data.documents[0]['class'],
              charactersList: [snapshot.data.documents[0]],
              );
          }
        ),
    );
  }
}


