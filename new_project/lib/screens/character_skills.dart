import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:new_project/index.dart';


class MyCharacterSkillsScreen extends StatefulWidget {
  final String userDocumentIndex;
  final String documentIndex;
  final String characterClass; // with 2 streams i can remove it to state
  const MyCharacterSkillsScreen({Key key, this.documentIndex, this.userDocumentIndex, this.characterClass}) : super(key: key);
  @override
  _MyCharacterSkillsScreenState createState() => _MyCharacterSkillsScreenState();
}

class _MyCharacterSkillsScreenState extends State<MyCharacterSkillsScreen> {
  
  List<RanksCounter> listOfRanksCounters = [];

  FirebaseFirestore db = FirebaseFirestore.instance;
  int availableRanks;
  bool levelUp;
  List classSkills;
  

  initState() {
    FirebaseFirestore.instance.collection('users').doc(widget.userDocumentIndex).collection('characters').doc(widget.documentIndex).get().then((value) => 
      setState((){
        availableRanks = value.data()['SKILL_RANKS'];
      })
    );
    FirebaseFirestore.instance.collection('classes').doc(widget.characterClass).get().then((value) =>
      setState((){
        classSkills = value.data()['CLASS_SKILLS'];
      })
    );
    super.initState();
  }

  

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => ValueNotifier(availableRanks),
      child: StreamBuilder( // combain two streams
        stream: db.collection('classes').doc(widget.documentIndex).snapshots(),
        builder: (context, snapshot){ 
          if(!snapshot.hasData) return SpinKitFadingCircle(
            color: Colors.white,
            size: 50.0,
          );
        return  StreamBuilder(
        stream: db.collection('users').doc(context.watch<AuthenticationService>().getUid()).collection('characters').doc(widget.documentIndex).snapshots(),
        builder: (context, snapshot) {
          if(!snapshot.hasData) return SpinKitFadingCircle(
            color: Colors.white,
            size: 50.0,
          );
          
          levelUp = snapshot.data['LEVEL_UP'];
          List listOfRanksCountersValue = snapshot.data['SKILL_RANKS_LIST'];
          final _textNotifier = context.watch<ValueNotifier<int>>();

          for(var i = 0; i < 25; i++){
            RanksCounter ranksCounter = RanksCounter(
              maxCounterValue:snapshot.data['Lvl'],
              minCounterValue: listOfRanksCountersValue[i], 
              availableRanks: availableRanks, 
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
                      '${_textNotifier.value}',
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
                  // MY EYES!!!!!!!!!!!!!!!!!! I HAVE TO DO SMTH WITH THIS ONE!!!!!!!!!!!!!!!!!!!!!!
                  _tableRow('Acrobatics', _totalBonus(_modifier(snapshot.data['DEX']), listOfRanksCounters[0].counter, classSkill: classSkills.contains('Acrobatics')), snapshot.data['DEX'], widget: listOfRanksCounters[0]),
                  _tableRow('Appraise', _totalBonus(_modifier(snapshot.data['INT']), listOfRanksCounters[1].counter, classSkill: classSkills.contains('Appraise')), snapshot.data['INT'], widget: listOfRanksCounters[1]),
                  _tableRow('Bluff', _totalBonus(_modifier(snapshot.data['CHA']),listOfRanksCounters[2].counter, classSkill: classSkills.contains('Bluff')), snapshot.data['CHA'], widget: listOfRanksCounters[2]),
                  _tableRow('Climb', _totalBonus(_modifier(snapshot.data['STR']),listOfRanksCounters[3].counter, classSkill: classSkills.contains('Climb')), snapshot.data['STR'], widget: listOfRanksCounters[3]),
                  _tableRow('Craft', _totalBonus(_modifier(snapshot.data['INT']),listOfRanksCounters[4].counter, classSkill: classSkills.contains('Craft')), snapshot.data['INT'], widget: listOfRanksCounters[4]),
                  _tableRow('Diplomacy', _totalBonus(_modifier(snapshot.data['CHA']),listOfRanksCounters[5].counter, classSkill: classSkills.contains('Diplomacy')), snapshot.data['CHA'], widget: listOfRanksCounters[5]),
                  _tableRow('Disguise', _totalBonus(_modifier(snapshot.data['CHA']),listOfRanksCounters[6].counter, classSkill: classSkills.contains('Disguise')), snapshot.data['CHA'], widget: listOfRanksCounters[6]),
                  _tableRow('Escape Artist', _totalBonus(_modifier(snapshot.data['DEX']),listOfRanksCounters[7].counter, classSkill: classSkills.contains('Escape Artist')), snapshot.data['DEX'], widget: listOfRanksCounters[7]),
                  _tableRow('Fly', _totalBonus(_modifier(snapshot.data['DEX']),listOfRanksCounters[8].counter, classSkill: classSkills.contains('Fly')), snapshot.data['DEX'], widget: listOfRanksCounters[8]),
                  _tableRow('Handle Animal*', _totalBonus(_modifier(snapshot.data['CHA']),listOfRanksCounters[9].counter, classSkill: classSkills.contains('Handle Animal')), snapshot.data['CHA'], widget: listOfRanksCounters[9]),
                  _tableRow('Heal', _totalBonus(_modifier(snapshot.data['WIS']),listOfRanksCounters[10].counter, classSkill: classSkills.contains('Heal')), snapshot.data['WIS'], widget: listOfRanksCounters[10]),
                  _tableRow('Intimidate', _totalBonus(_modifier(snapshot.data['CHA']), listOfRanksCounters[11].counter, classSkill: classSkills.contains('Intimidate')), snapshot.data['CHA'], widget: listOfRanksCounters[11]),
                  _tableRow('Knowledge*', _totalBonus(_modifier(snapshot.data['INT']),listOfRanksCounters[12].counter, classSkill: classSkills.contains('Knowledge')), snapshot.data['INT'], widget: listOfRanksCounters[12]),
                  _tableRow('Linguistics*', _totalBonus(_modifier(snapshot.data['INT']),listOfRanksCounters[13].counter, classSkill: classSkills.contains('Linguistics')), snapshot.data['INT'], widget: listOfRanksCounters[13]),
                  _tableRow('Perception', _totalBonus(_modifier(snapshot.data['WIS']),listOfRanksCounters[14].counter, classSkill: classSkills.contains('Perception')), snapshot.data['WIS'], widget: listOfRanksCounters[14]),
                  _tableRow('Perform', _totalBonus(_modifier(snapshot.data['CHA']),listOfRanksCounters[15].counter, classSkill: classSkills.contains('Perform')), snapshot.data['CHA'], widget: listOfRanksCounters[15]),
                  _tableRow('Profession', _totalBonus(_modifier(snapshot.data['WIS']),listOfRanksCounters[16].counter, classSkill: classSkills.contains('Profession')), snapshot.data['WIS'], widget: listOfRanksCounters[16]),
                  _tableRow('Ride', _totalBonus(_modifier(snapshot.data['DEX']),listOfRanksCounters[17].counter, classSkill: classSkills.contains('Ride')), snapshot.data['DEX'], widget: listOfRanksCounters[17]),
                  _tableRow('Sense Motive', _totalBonus(_modifier(snapshot.data['WIS']),listOfRanksCounters[18].counter, classSkill: classSkills.contains('Sense Motive')), snapshot.data['WIS'], widget: listOfRanksCounters[18]),
                  _tableRow('Sleight of Hand*', _totalBonus(_modifier(snapshot.data['DEX']),listOfRanksCounters[19].counter, classSkill: classSkills.contains('Sleight of Hand')), snapshot.data['DEX'], widget: listOfRanksCounters[19]),
                  _tableRow('Spellcraft*', _totalBonus(_modifier(snapshot.data['INT']),listOfRanksCounters[20].counter,classSkill: classSkills.contains('Spellcraft')), snapshot.data['INT'], widget: listOfRanksCounters[20]),
                  _tableRow('Stealth', _totalBonus(_modifier(snapshot.data['DEX']),listOfRanksCounters[21].counter,classSkill: classSkills.contains('Stealth')), snapshot.data['DEX'], widget: listOfRanksCounters[21]),
                  _tableRow('Survival', _totalBonus(_modifier(snapshot.data['WIS']),listOfRanksCounters[22].counter,classSkill: classSkills.contains('Survival')), snapshot.data['WIS'], widget: listOfRanksCounters[22]),
                  _tableRow('Swim', _totalBonus(_modifier(snapshot.data['STR']),listOfRanksCounters[23].counter,classSkill: classSkills.contains('Swim')), snapshot.data['STR'], widget: listOfRanksCounters[23]),
                  _tableRow('Use Magic Device*', _totalBonus(_modifier(snapshot.data['CHA']),listOfRanksCounters[24].counter,classSkill: classSkills.contains('Use Magic Device')), snapshot.data['CHA'], widget: listOfRanksCounters[24]),
                ],
              ),
              RaisedButton(
                color: Theme.of(context).primaryColor,
                onPressed: levelUp ? () => alert(_textNotifier.value) : null,
                child: const Text('Applay ranks ', style: TextStyle(fontSize: 20)),
              )
            ], 
          );
        }
    );
  },
  ));
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

  Widget _totalBonus(int abilityMod, int ranks, {bool classSkill = false}){
    if (ranks != 0 && classSkill){
      return Text((abilityMod+ranks+3).toString());
    }
    return Text((abilityMod+ranks).toString());
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

  Future<void> alert(int value){
    return showDialog<void>(
    context: context,
    barrierDismissible: false, // user must tap button!
    builder: (BuildContext context) {
      return AlertDialog(
        title: Text('Apply ranks'),
        content: SingleChildScrollView(
          child: ListBody(
            children: <Widget>[
              Text('This will apply ranks to skills.'),
              Text('Are you sure you want to apply this ranks?'),
            ],
          ),
        ),
        actions: <Widget>[
          TextButton(
            child: Text('Accept'),
            onPressed: () {
              applayRanks(value);
              Navigator.of(context).pop();
              Navigator.pop(context);
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

  void applayRanks(int value){
    if(value == 0){
      setState((){
      levelUp = false;
    });
    }
    List<int> list = List.filled(25, 0);
    for( var i = 0; i < 25; i++){
      list[i] = listOfRanksCounters[i].counter;
    }
    db.collection('characters').doc(widget.documentIndex).update({'SKILL_RANKS': value});
    db.collection('characters').doc(widget.documentIndex).update({'SKILL_RANKS_LIST': list});
    db.collection('characters').doc(widget.documentIndex).update({'LEVEL_UP': levelUp}); 
  }
}

