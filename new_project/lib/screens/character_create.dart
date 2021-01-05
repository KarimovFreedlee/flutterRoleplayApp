import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:new_project/index.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:form_validator/form_validator.dart';

class MyCharacterCreateScreen extends StatefulWidget {
  MyCharacterCreateScreen();
  

  @override
  _MyCharacterCreateScreenState createState() => _MyCharacterCreateScreenState();

}

class _MyCharacterCreateScreenState extends State<MyCharacterCreateScreen> {
  
  TextEditingController nameController = TextEditingController();
  TextEditingController strController = TextEditingController();
  TextEditingController dexController = TextEditingController();
  TextEditingController conController = TextEditingController();
  TextEditingController intController = TextEditingController();
  TextEditingController wisController = TextEditingController();
  TextEditingController chaController = TextEditingController(); 

  TextEditingController racialStr = TextEditingController();
  TextEditingController racialDex = TextEditingController();
  TextEditingController racialCon = TextEditingController();
  TextEditingController racialInt = TextEditingController();
  TextEditingController racialWis = TextEditingController();
  TextEditingController racialCha = TextEditingController(); 
  
  final _formKey = GlobalKey<FormState>();
  
  String dropdownClassValue = 'Bard';
  String dropdownRaceValue = 'Dwarf';

  List<int> listOfSkillRanks = List.filled(24, 0);
  List<String> classes = ['Bard', 'Barbarian', 'Cleric', 'Druid','Fighter','Monk', 'Paladin', 'Ranger', 'Rogue', 'Sorcerer', 'Wizard'];
  List<String> races = ['Dwarf', 'Elf', 'Gnome', 'Half Elf','Half Orc','Halfling', 'Human'];

  var _characterClass = Map();

  final databaseReference = FirebaseFirestore.instance;

  String _radioValue;

  void _handleRadioValueChange(String value) {
    setState(() {
      _radioValue = value;
      _cleanRacialControllers();
      switch (value) {
        case 'STR':
          return  racialStr.text = '+2';
          break;
        case 'DEX':
          return  racialDex.text = '+2';
          break;
        case 'CON':
          return  racialCon.text = '+2';
          break;
        case 'INT':
          return  racialInt.text = '+2';
          break;
        case 'WIS':
          return  racialWis.text = '+2';
          break;
        case 'CHA':
          return  racialCha.text = '+2';
          break;
        default :
          return Text('');
        break;
      }
    });
    print(racialStr.text);
  }

 void _cleanRacialControllers(){
   racialStr.text = '';
   racialDex.text = '';
   racialCon.text = '';
   racialInt.text = '';
   racialWis.text = '';
   racialCha.text = '';
 }

  @override
  Widget build(BuildContext context) {
    print(listOfSkillRanks);
    return  Scaffold(
      appBar: AppBar(
        title: Text('Character creator')
      ),
      body: GestureDetector(
        onTap: () {
          FocusScopeNode currentFocus = FocusScope.of(context);

          if (!currentFocus.hasPrimaryFocus) {
            currentFocus.unfocus();
          }
        },
          child: Form(
          key: _formKey,
          child: ListView(
            children: <Widget>[
              TextFormField(
                decoration: InputDecoration(
                  icon: Icon(Icons.person),
                  labelText: 'Character name',
                ),
                controller: nameController,   
                validator: ValidationBuilder().minLength(1).build(),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children:[
                  Text('Race:'),
                    DropdownButton<String>(
                    value: dropdownRaceValue,
                    icon: Icon(Icons.arrow_downward),
                    iconSize: 24,
                    elevation: 16,
                    style: TextStyle(color: Colors.grey),
                    underline: Container(
                      height: 2,
                      color: Colors.grey,
                    ),
                    onChanged: (String newValue) {
                      _cleanRacialControllers();
                      setState(() {
                        dropdownRaceValue = newValue;
                      });
                    },
                    items: races
                        .map<DropdownMenuItem<String>>((String value) {
                      return DropdownMenuItem<String>(
                        value: value,
                        child: Text(value),
                      );
                    }).toList()
                  ),
                ]
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children:[
                  Text('Class:'),
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
                ]
              ),
              Table(
                children: [
                 TableRow(
                  children: [
                    _tableContainer(Text('Name'), height: 30),
                    _tableContainer(Text('Score'), height: 30),
                    _tableContainer(Text('Racial abilities'), height: 30),
                  ]
                ),
                _tableRow('STR', _abilityScore(strController), strController, racialAbilities('STR')),
                _tableRow('DEX', _abilityScore(dexController), dexController, racialAbilities('DEX')),
                _tableRow('CON', _abilityScore(conController), conController, racialAbilities('CON')),
                _tableRow('INT', _abilityScore(intController), intController, racialAbilities('INT')),
                _tableRow('WIS', _abilityScore(wisController), wisController, racialAbilities('WIS')),
                _tableRow('CHA', _abilityScore(chaController), chaController, racialAbilities('CHA')),
                ],
              ),
              Center(
                child: ElevatedButton(
                  onPressed: () {
                    print(racialStr.text);
                    if(_formKey.currentState.validate()){
                      alert();
                    }
                  },
                  child: Text('Submit'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  TableRow _tableRow(String title, Widget _secondColumn, TextEditingController textController, Widget widget){
    return TableRow(
      children: [
        _tableContainer(Text(title)),
        _tableContainer(_secondColumn), 
        _tableContainer(widget), 
      ]
    );
  }

  Widget _tableContainer(Widget child, {double height = 100,}){
    return Card(
      child: Container(
        height: height,
        alignment: Alignment.center,
        child: child,
      ),
    );
  }

  Widget _abilityScore(TextEditingController textController){
    return Container(
          width: 30,
          child: TextFormField(
            controller: textController,
            validator: ValidationBuilder().minLength(1).build(),
            decoration: InputDecoration(
              border: InputBorder.none,
              counterText: '',
            ),
            onEditingComplete:() => FocusScope.of(context).nextFocus(),
            maxLength: 2,
            keyboardType: TextInputType.number,
            inputFormatters: [
              FilteringTextInputFormatter.digitsOnly
            ],
          ),
      );
  } 

  Widget racialAbilityScore(TextEditingController textController, String text){
    textController.text = text;
    return Container(
      width: 30,
      child: TextField(
        readOnly: true,
        controller: textController,
        decoration: InputDecoration(
          border: InputBorder.none,
          counterText: '',
        ),
      ),
    );
  }

  Widget racialAbilities(String ability){
    switch(dropdownRaceValue) { 
      case 'Dwarf': { 
        switch (ability) {
          case 'CON':
            return  racialAbilityScore(racialCon, '+2');
            break;
          case 'WIS':
            return  racialAbilityScore(racialWis, '+2');
            break;
          case 'CHA':
            return  racialAbilityScore(racialCha, '-2');
            break;
          default :
            return Text('');
          break;
        }
      } 
      break;
      case 'Elf':
        switch (ability) {
          case 'DEX':
            return  racialAbilityScore(racialDex, '+2');
            break;
          case 'INT':
            return  racialAbilityScore(racialInt, '+2');
            break;
          case 'CON':
            return  racialAbilityScore(racialCon, '-2');
            break;
          default :
            return Text('');
          break;
        }
      break;
      case 'Gnome': { 
        switch (ability) {
          case 'CON': 
            return  racialAbilityScore(racialCon, '+2');
            break;
          case 'CHA':
            return  racialAbilityScore(racialCha,'+2');
            break;
          case 'STR':
            return  racialAbilityScore(racialStr, '-2');
            break;
          default :
            return Text('');
          break;
          }
        } 
      break;
      case 'Halfling': { 
        switch (ability) {
          case 'DEX': 
            return  racialAbilityScore(racialDex, '+2');
            break;
          case 'CHA':
            return  racialAbilityScore(racialCha, '+2');
            break;
          case 'STR':
            return  racialAbilityScore(racialStr, '-2');
            break;
          default :
            return Text('');
          break;
        }
      } 
      break;
      default:
        return abilityRadio(ability);
      break;  
    }
  }

  Widget abilityRadio(String ability){
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text('+2'),
        Radio(
          value: ability,
          groupValue: _radioValue,
          onChanged: _handleRadioValueChange,
        ),
      ],
    );
  }

  Future<void> alert(){
    return showDialog<void>(
    context: context,
    barrierDismissible: false, // user must tap button!
    builder: (BuildContext context) {
      return AlertDialog(
        title: Text('Crerate character'),
        content: SingleChildScrollView(
          child: ListBody(
            children: <Widget>[
              Text('This will create character.'),
              Text('Are you sure you want to create this character?'),
            ],
          ),
        ),
        actions: <Widget>[
          TextButton(
            child: Text('Accept'),
            onPressed: () {
              characterClass(dropdownClassValue);
              createRecord(nameController.text, dropdownRaceValue, dropdownClassValue);
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

  void characterClass(String className){
    switch(className){
      case 'Bard':
        _characterClass = characterClassCreater(8,6,0,2,2,0);
      break;
      case 'Barbarian':
        _characterClass = characterClassCreater(12,4,2,0,0,1);
      break;
      case 'Cleric':
        _characterClass = characterClassCreater(8,2,2,0,2,0);
      break;
      case 'Druid':
        _characterClass = characterClassCreater(8,4,2,0,2,0);
      break;
      case 'Fighter':
        _characterClass = characterClassCreater(10,2,2,0,0,1);
      break;
      case 'Monk':
        _characterClass = characterClassCreater(10,4,2,2,2,0);
      break;
      case 'Paladin':
        _characterClass = characterClassCreater(10,2,2,0,2,1);
      break;
      case 'Ranger':
        _characterClass = characterClassCreater(10,6,2,2,0,1);
      break;
      case 'Rouge':
        _characterClass = characterClassCreater(8,8,0,2,0,0);
      break;
      case 'Sorcerer':
        _characterClass = characterClassCreater(6,2,0,0,2,0);
      break;
      case 'Wizard':
        _characterClass = characterClassCreater(6,2,0,0,2,0);
      break;
    }
    return null;
  }


  Map characterClassCreater(int hp, skillRanks, fortitude, reflex, will, bab){
    return {
      'hp' : hp,
      'skillRanks' : _modifier(intController.text)+skillRanks,
      'fortitude' : fortitude,
      'reflex' : reflex,
      'will' : will,
      'bab' : bab
    };
  }

  void createRecord(String name, race, characterClass) async {
    await databaseReference.collection("characters")
    .add({
      'name': name,
      'race': race,
      'Lvl': 1,
      'LEVEL_UP': true,
      'class': characterClass,
      'HP': _characterClass['hp'],
      'SKILL_RANKS': _characterClass['skillRanks'],
      'SKILL_RANKS_LIST': listOfSkillRanks,
      'FORTITUDE': (_modifier(conController.text) + _characterClass['fortitude']),
      'REFLEX' : _modifier(dexController.text) + _characterClass['reflex'],
      'WILL' : _modifier(wisController.text) + _characterClass['will'],
      'BAB' : _characterClass['bab'],
      'STR': stringSum(strController.text, racialStr.text),
      'DEX': stringSum(dexController.text, racialDex.text),
      'CON': stringSum(conController.text, racialCon.text),
      'INT': stringSum(intController.text, racialInt.text),
      'WIS': stringSum(wisController.text, racialWis.text),
      'CHA': stringSum(chaController.text, racialCha.text),
    });
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

  String stringSum(String stringOne, String stringTwo){
    if(stringTwo == null || stringTwo == '')
    {
      return stringOne;
    }
    return (int.parse(stringOne ?? '0')+int.parse(stringTwo ?? '0')).toString();
  }
}