import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class MycharacterInformationScreen extends StatefulWidget {
  final String documentIndex;

  const MycharacterInformationScreen({Key key, this.documentIndex}) : super(key: key);
  @override
  _MycharacterInformationScreenState createState() => _MycharacterInformationScreenState();
}

class _MycharacterInformationScreenState extends State<MycharacterInformationScreen> {
  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
      stream: FirebaseFirestore.instance.collection('characters').document(widget.documentIndex).snapshots(),,
      builder: (context, snapshot) {
        if(!snapshot.hasData) return Text('Loading data....');
        return ListView(
          children: [
            Text('Info'),
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
      ]
    );
  }

  Widget _tableContainer(Widget child, {double height = 100,}){
    return Container(
      height: height,
      alignment: Alignment.center,
      child: child,
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
}