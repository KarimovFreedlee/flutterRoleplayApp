import 'package:flutter/material.dart';

class RanksCounter extends StatefulWidget {
  RanksCounter({this.counter = 0});
  int counter;
  @override
  _RanksCounterState createState() => _RanksCounterState();
}

class _RanksCounterState extends State<RanksCounter> {
  
  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: <Widget>[
        InkWell(
          onTap: ()=>setState(()=> widget.counter++),
          child: Container(
            color: Colors.blue,
            child: Icon(Icons.add),
          ),
        ),
        Expanded(
          child: Center(
            child: Text(
              '${widget.counter}',
              textAlign: TextAlign.center,
              ),
          ),
        ),
        InkWell(
          onTap: (){
              setState((){
                if(widget.counter == 0){
                  widget.counter = 0;
                } else{
                  widget.counter--;
                }
              });
            },
          child: Container(
            color: Colors.blue,
            child: Icon(Icons.remove),
          ),
        )
      ],
    );
  }
}