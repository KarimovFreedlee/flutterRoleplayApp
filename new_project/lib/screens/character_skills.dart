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
  
  FirebaseFirestore db = FirebaseFirestore.instance;
  int availableRanks;


  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
      stream: db.collection('characters').doc(widget.documentIndex).snapshots(),
      builder: (context, snapshot) {
        if(!snapshot.hasData) return Text('Loading data....');

        availableRanks = snapshot.data['SKILL_RANKS'];
        
        RanksCounter ranksCounter = RanksCounter(maxCounterValue:snapshot.data['Lvl'], callback: callback, availableRanks: availableRanks,);
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
                _tableRow('Acrobatics', _totalBonus(_modifier(snapshot.data['DEX']), ranksCounter.counter), snapshot.data['DEX'], widget: ranksCounter),
                _tableRow('Appraise', _totalBonus(_modifier(snapshot.data['INT']),ranksCounter.counter), snapshot.data['INT'], widget: ranksCounter),
                _tableRow('Bluff', _totalBonus(_modifier(snapshot.data['CHA']),ranksCounter.counter), snapshot.data['CHA'], widget: ranksCounter),
                _tableRow('Climb', _totalBonus(_modifier(snapshot.data['STR']),ranksCounter.counter), snapshot.data['STR'], widget: ranksCounter),
                _tableRow('Diplomacy', _totalBonus(_modifier(snapshot.data['CHA']),ranksCounter.counter), snapshot.data['CHA'], widget: ranksCounter),
                _tableRow('Disguise', _totalBonus(_modifier(snapshot.data['CHA']),ranksCounter.counter), snapshot.data['CHA'], widget: ranksCounter),
                _tableRow('Escape Artist', _totalBonus(_modifier(snapshot.data['DEX']),ranksCounter.counter), snapshot.data['DEX'], widget: ranksCounter),
                _tableRow('Fly', _totalBonus(_modifier(snapshot.data['DEX']),ranksCounter.counter), snapshot.data['DEX'], widget: ranksCounter),
                _tableRow('Handle Animal*', _totalBonus(_modifier(snapshot.data['CHA']),ranksCounter.counter), snapshot.data['CHA'], widget: ranksCounter),
                _tableRow('Heal', _totalBonus(_modifier(snapshot.data['WIS']),ranksCounter.counter), snapshot.data['WIS'], widget: ranksCounter),
                _tableRow('Intimidate', _totalBonus(_modifier(snapshot.data['CHA']), ranksCounter.counter), snapshot.data['CHA'], widget: ranksCounter),
                _tableRow('Linguistics*', _totalBonus(_modifier(snapshot.data['INT']),ranksCounter.counter), snapshot.data['INT'], widget: ranksCounter),
                _tableRow('Perception', _totalBonus(_modifier(snapshot.data['WIS']),ranksCounter.counter), snapshot.data['WIS']),
                _tableRow('Ride', _totalBonus(_modifier(snapshot.data['DEX']),ranksCounter.counter), snapshot.data['DEX']),
                _tableRow('Sense Motive', _totalBonus(_modifier(snapshot.data['WIS']),ranksCounter.counter), snapshot.data['WIS']),
                _tableRow('Sleight of Hand*', _totalBonus(_modifier(snapshot.data['DEX']),ranksCounter.counter), snapshot.data['DEX']),
                _tableRow('Spellcraft*', _totalBonus(_modifier(snapshot.data['INT']),ranksCounter.counter), snapshot.data['INT']),
                _tableRow('Stealth', _totalBonus(_modifier(snapshot.data['DEX']),ranksCounter.counter), snapshot.data['DEX']),
                _tableRow('Survival', _totalBonus(_modifier(snapshot.data['WIS']),ranksCounter.counter), snapshot.data['WIS']),
                _tableRow('Swim', _totalBonus(_modifier(snapshot.data['STR']),ranksCounter.counter), snapshot.data['STR']),
                _tableRow('Use Magic Device*', _totalBonus(_modifier(snapshot.data['CHA']),ranksCounter.counter), snapshot.data['CHA']),
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
         availableRanks --;
      });
      print(availableRanks);
    }
  }

  void applayRanks(){
    db.collection('characters').doc(widget.documentIndex).update({'SKILL_RANKS': availableRanks});
  }
}

