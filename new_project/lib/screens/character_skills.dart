import 'dart:typed_data';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:new_project/index.dart';

class MyCharacterSkillsScreen extends StatefulWidget {

  final String documentIndex;
  const MyCharacterSkillsScreen({Key key, this.documentIndex}) : super(key: key);
  @override
  _MyCharacterSkillsScreenState createState() => _MyCharacterSkillsScreenState();
}

class _MyCharacterSkillsScreenState extends State<MyCharacterSkillsScreen> {
  
  List<RanksCounter> listOfRanksCounters = [];

  FirebaseFirestore db = FirebaseFirestore.instance;
  int availableRanks;
  bool levelUp = true;


  initState(){
    FirebaseFirestore.instance.collection('characters').doc(widget.documentIndex).get().then((value) => 
      setState((){
        availableRanks = value.data()['SKILL_RANKS'];
      })
    );
    super.initState();
  }
  int ranksFromData;

  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
      stream: db.collection('characters').doc(widget.documentIndex).snapshots(),
      builder: (context, snapshot) {
        if(!snapshot.hasData) return SpinKitFadingCircle(
          color: Colors.white,
          size: 50.0,
        );
        List listOfRanksCountersValue = snapshot.data['SKILL_RANKS_LIST'];
        for(var i = 0; i < 23; i++){
          RanksCounter ranksCounter = RanksCounter(
            maxCounterValue:snapshot.data['Lvl'], 
            callback: callback, 
            availableRanks: availableRanks, 
            callbackIncrement: callbackIncrement, 
            counter: listOfRanksCountersValue[i], 
            levelUp: snapshot.data['LEVEL_UP']
          );
          listOfRanksCounters.add(ranksCounter);
        }
        return ListView(
          children: [
            Container(
              padding: EdgeInsets.symmetric(vertical: 16.0),
              height: 50,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  Text(
                    'Skill Points:',
                    textAlign: TextAlign.center,
                  ),
                  Text(
                    '$availableRanks',
                    textAlign: TextAlign.center,
                  ),
                ],
              )
            ),
            Table(
              children: [
                  TableRow(
                  children: [
                    _tableContainer(Text('Skill name'), height: 30),
                    _tableContainer(Text('Total bonus'), height: 30),
                    _tableContainer(Text('Ability mod'), height: 30),
                    _tableContainer(Text('Ranks'), height: 30),
                  ]
                ),
                _tableRow('Acrobatics', _totalBonus(_modifier(snapshot.data['DEX']), listOfRanksCounters[0].counter), snapshot.data['DEX'], widget: listOfRanksCounters[0]),
                _tableRow('Appraise', _totalBonus(_modifier(snapshot.data['INT']), listOfRanksCounters[1].counter), snapshot.data['INT'], widget: listOfRanksCounters[1]),
                _tableRow('Bluff', _totalBonus(_modifier(snapshot.data['CHA']),listOfRanksCounters[2].counter), snapshot.data['CHA'], widget: listOfRanksCounters[2]),
                _tableRow('Climb', _totalBonus(_modifier(snapshot.data['STR']),listOfRanksCounters[3].counter), snapshot.data['STR'], widget: listOfRanksCounters[3]),
                _tableRow('Craft', _totalBonus(_modifier(snapshot.data['INT']),listOfRanksCounters[4].counter), snapshot.data['INT'], widget: listOfRanksCounters[4]),
                _tableRow('Diplomacy', _totalBonus(_modifier(snapshot.data['CHA']),listOfRanksCounters[5].counter), snapshot.data['CHA'], widget: listOfRanksCounters[5]),
                _tableRow('Disguise', _totalBonus(_modifier(snapshot.data['CHA']),listOfRanksCounters[6].counter), snapshot.data['CHA'], widget: listOfRanksCounters[6]),
                _tableRow('Escape Artist', _totalBonus(_modifier(snapshot.data['DEX']),listOfRanksCounters[7].counter), snapshot.data['DEX'], widget: listOfRanksCounters[7]),
                _tableRow('Fly', _totalBonus(_modifier(snapshot.data['DEX']),0), snapshot.data['DEX']),
                _tableRow('Handle Animal*', _totalBonus(_modifier(snapshot.data['CHA']),0), snapshot.data['CHA']),
                _tableRow('Heal', _totalBonus(_modifier(snapshot.data['WIS']),0), snapshot.data['WIS']),
                _tableRow('Intimidate', _totalBonus(_modifier(snapshot.data['CHA']), 0), snapshot.data['CHA']),
                _tableRow('Knowledge*', _totalBonus(_modifier(snapshot.data['INT']),0), snapshot.data['INT']),
                _tableRow('Linguistics*', _totalBonus(_modifier(snapshot.data['INT']),0), snapshot.data['INT']),
                _tableRow('Perception', _totalBonus(_modifier(snapshot.data['WIS']),0), snapshot.data['WIS']),
                _tableRow('Perform', _totalBonus(_modifier(snapshot.data['CHA']),0), snapshot.data['CHA']),
                _tableRow('Profession', _totalBonus(_modifier(snapshot.data['WIS']),0), snapshot.data['WIS']),
                _tableRow('Ride', _totalBonus(_modifier(snapshot.data['DEX']),0), snapshot.data['DEX']),
                _tableRow('Sense Motive', _totalBonus(_modifier(snapshot.data['WIS']),0), snapshot.data['WIS']),
                _tableRow('Sleight of Hand*', _totalBonus(_modifier(snapshot.data['DEX']),0), snapshot.data['DEX']),
                _tableRow('Spellcraft*', _totalBonus(_modifier(snapshot.data['INT']),0), snapshot.data['INT']),
                _tableRow('Stealth', _totalBonus(_modifier(snapshot.data['DEX']),0), snapshot.data['DEX']),
                _tableRow('Survival', _totalBonus(_modifier(snapshot.data['WIS']),0), snapshot.data['WIS']),
                _tableRow('Swim', _totalBonus(_modifier(snapshot.data['STR']),0), snapshot.data['STR']),
                _tableRow('Use Magic Device*', _totalBonus(_modifier(snapshot.data['CHA']),0), snapshot.data['CHA']),
              ],
            ),
            ElevatedButton(
              onPressed: applayRanks,
              child: const Text('Applay ranks ', style: TextStyle(fontSize: 20)),
            )
          ], 
        );
      }
    );
  }

  TableRow _tableRow(String title, Widget _secondColumn, String textController, {Widget widget}){
    return TableRow(
      children: [
        _tableContainer(Text(title)),
        _tableContainer(_secondColumn),
        _tableContainer(Text(_modifier(textController).toString())), 
        _tableContainer(widget), 
      ]
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

  Widget _totalBonus(int abilityMod, int ranks){
    return Text((abilityMod+ranks).toString(),);
  }
  
  Widget _tableContainer(Widget child, {double height = 70,}){
    return Card(
        child: Container(
        height: height,
        alignment: Alignment.center,
        child: child,
      ),
    );
  }

  void callback() {
    if(availableRanks != 0){
      setState((){
        availableRanks--;
      });
    }
  }

  void callbackIncrement() {
    if(availableRanks != 0){
      setState((){
         availableRanks++;
      });
    }
  }

  void applayRanks(){
    if(availableRanks == 0){
      setState((){
      levelUp = false;
    });
    }
    List<int> list = List.filled(24, 0);
    for( var i = 0; i < 23; i++){
      list[i] = listOfRanksCounters[i].counter;
    }
    db.collection('characters').doc(widget.documentIndex).update({'SKILL_RANKS': availableRanks});
    db.collection('characters').doc(widget.documentIndex).update({'SKILL_RANKS_LIST': list}); 
  }
}

