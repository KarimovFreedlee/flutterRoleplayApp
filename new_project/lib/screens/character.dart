import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class MyCharacterScreen extends StatefulWidget {
  MyCharacterScreen({this.name, this.documentIndex});
  final String name;
  final int documentIndex;

  @override
  _MyCharacterScreenState createState() => _MyCharacterScreenState();
}

class _MyCharacterScreenState extends State<MyCharacterScreen> {

  TextEditingController strController = TextEditingController();

  TextEditingController dexController = TextEditingController();

  TextEditingController conController = TextEditingController();

  TextEditingController intController = TextEditingController();

  TextEditingController wisController = TextEditingController();

  TextEditingController chaController = TextEditingController();

  int number = 0;
  RanksCounter ranksCounter = RanksCounter(counter: 1,);
  

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.name ?? ''),
      ),
      body: StreamBuilder(
        stream: FirebaseFirestore.instance.collection('characters').snapshots(),
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
                border: TableBorder.all(),
                children: [
                   TableRow(
                    children: [
                      _tableContainer(Text('Name'), height: 30),
                      _tableContainer(Text('Score'), height: 30),
                      _tableContainer(Text('Modify'), height: 30),
                      _tableContainer(Text('Temp'), height: 30),
                    ]
                  ),
                  _tableRow('STR', _abilityScore(strController, strController.text = snapshot.data.documents[widget.documentIndex]['STR']), strController),
                  _tableRow('DEX', _abilityScore(dexController, dexController.text = snapshot.data.documents[widget.documentIndex]['DEX']), dexController),
                  _tableRow('CON', _abilityScore(conController, conController.text = snapshot.data.documents[widget.documentIndex]['CON']), conController),
                  _tableRow('INT', _abilityScore(intController, intController.text = snapshot.data.documents[widget.documentIndex]['INT']), intController),
                  _tableRow('WIS', _abilityScore(wisController, wisController.text = snapshot.data.documents[widget.documentIndex]['WIS']), wisController),
                  _tableRow('CHA', _abilityScore(chaController, chaController.text = snapshot.data.documents[widget.documentIndex]['CHA']), chaController),
                ],
              ),
              Container(
                padding: EdgeInsets.symmetric(vertical: 16.0),
                height: 50,
                child: Text(
                  'Skills',
                  textAlign: TextAlign.center,
                )
              ),
              Table(
                border: TableBorder.all(),
                children: [
                   TableRow(
                    children: [
                      _tableContainer(Text('Skill name'), height: 30),
                      _tableContainer(Text('Total bonus'), height: 30),
                      _tableContainer(Text('Ability mod'), height: 30),
                      _tableContainer(Text('Ranks'), height: 30),
                    ]
                  ),
                  _tableRow('Acrobatics', _totalBonus(_modifier(strController.text), ranksCounter.counter), strController, widget: ranksCounter),
                  _tableRow('Appraise', _totalBonus(_modifier(dexController.text),ranksCounter.counter), dexController,),
                  _tableRow('CON', _totalBonus(_modifier(conController.text),number), conController),
                  _tableRow('INT', _totalBonus(_modifier(intController.text),number), intController),
                  _tableRow('WIS', _totalBonus(_modifier(wisController.text),number), wisController),
                  _tableRow('CHA', _totalBonus(_modifier(chaController.text),number), chaController),
                ],
              ),
              RaisedButton(
                onPressed: () {print(widget.documentIndex);},
                child: const Text('Applay ranks ', style: TextStyle(fontSize: 20)),
              )
            ],
          );
        }
      ),
    );
  }

  TableRow _tableRow(String title, Widget _secondColumn, TextEditingController textController, {Widget widget}){
    return TableRow(
      children: [
        _tableContainer(Text(title)),
        _tableContainer(_secondColumn),
        _tableContainer(Text(_modifier(textController.text).toString())), 
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
            onEditingComplete: () => setState((){}),
            maxLength: 3,
            keyboardType: TextInputType.number,
            inputFormatters: [
              FilteringTextInputFormatter.digitsOnly
              ],
            ),
      );
  }

  Widget _tableContainer(Widget child, {double height = 100,}){
    return Container(
      height: height,
      alignment: Alignment.center,
      child: child,
    );
  }
}

class RanksCounter extends StatefulWidget {
  RanksCounter({this.counter = 0});
  int counter;
  @override
  _RanksCounterState createState() => _RanksCounterState();
}

class _RanksCounterState extends State<RanksCounter> {
  


  @override
  Widget build(BuildContext context) {
    return ListView(
      children: <Widget>[
        ButtonTheme(
          height: 15,
          child: RaisedButton(
            child: Icon(Icons.add),
            onPressed: ()=>setState(()=> widget.counter++),
          ),
        ),
        Text(
          '${widget.counter}',
          textAlign: TextAlign.center,
          ),
        ButtonTheme(
          height: 15,
          child: RaisedButton(
            child: Icon(Icons.remove),
            onPressed: (){
              setState((){
                if(widget.counter == 0){
                  widget.counter = 0;
                } else{
                  widget.counter--;
                  print(widget.counter);
                }
              });
            },
          ),
        )
      ],
    );
  }
}