import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class MyCharacterAbilitiesScreen extends StatefulWidget {

  final String documentIndex;

  const MyCharacterAbilitiesScreen({Key key, this.documentIndex}) : super(key: key);
  @override
  _MyCharacterAbilitiesScreenState createState() => _MyCharacterAbilitiesScreenState();
}

class _MyCharacterAbilitiesScreenState extends State<MyCharacterAbilitiesScreen> {

  TextEditingController strController = TextEditingController();

  TextEditingController dexController = TextEditingController();

  TextEditingController conController = TextEditingController();

  TextEditingController intController = TextEditingController();

  TextEditingController wisController = TextEditingController();

  TextEditingController chaController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
      // ignore: deprecated_member_use
      stream: FirebaseFirestore.instance.collection('characters').document(widget.documentIndex).snapshots(),
      builder: (context, snapshot) {
        if(!snapshot.hasData) return Text('Loading data....');
        return ListView(
          children: [
            Container(
              padding: EdgeInsets.symmetric(vertical: 16.0),
              height: 50,
              child: Text(
                'Ability',
                textAlign: TextAlign.center,
              )
            ),
            Table(
              children: [
                  TableRow(
                  children: [
                    _tableContainer(Text('Name'), height: 30),
                    _tableContainer(Text('Score'), height: 30),
                    _tableContainer(Text('Modify'), height: 30),
                    // _tableContainer(Text('Temp'), height: 30),
                  ]
                ),
                _tableRow('STR', _abilityScore(strController, strController.text = snapshot.data['STR']), strController),
                _tableRow('DEX', _abilityScore(dexController, dexController.text = snapshot.data['DEX']), dexController),
                _tableRow('CON', _abilityScore(conController, conController.text = snapshot.data['CON']), conController),
                _tableRow('INT', _abilityScore(intController, intController.text = snapshot.data['INT']), intController),
                _tableRow('WIS', _abilityScore(wisController, wisController.text = snapshot.data['WIS']), wisController),
                _tableRow('CHA', _abilityScore(chaController, chaController.text = snapshot.data['CHA']), chaController),
              ],
            ),
          ],
        );
      }
    );
  }

  TableRow _tableRow(String title, Widget _secondColumn, TextEditingController textController, {Widget widget}){
    return TableRow(
      children: [
        _tableContainer(Text(title)),
        _tableContainer(_secondColumn),
        _tableContainer(Text(_modifier(textController.text).toString())), 
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
  
  Widget _abilityScore(TextEditingController textController, String text){
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

  Widget _tableContainer(Widget child, {double height = 100,}){
    return Card(
        child: Container(
        height: height,
        alignment: Alignment.center,
        child: child,
      ),
    );
  }

}