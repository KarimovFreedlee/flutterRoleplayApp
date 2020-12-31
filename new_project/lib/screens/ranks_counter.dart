import 'package:flutter/material.dart';

class RanksCounter extends StatefulWidget {
  RanksCounter({this.counter = 0, this.maxCounterValue, this.availableRanks, this.callback});
  int counter;
  int maxCounterValue;
  int availableRanks;
  Function callback;

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
          onTap: (){
            if(widget.counter != widget.maxCounterValue){
              setState((){
                widget.counter++;
              }
            );
            widget.callback();
            }
          },
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