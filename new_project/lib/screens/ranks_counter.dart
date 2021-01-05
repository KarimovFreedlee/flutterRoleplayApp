import 'package:flutter/material.dart';

class RanksCounter extends StatefulWidget {
  RanksCounter({this.counter = 0, this.maxCounterValue, this.availableRanks, this.callback, this.callbackIncrement, this.levelUp});
  int counter;
  int maxCounterValue;
  int availableRanks;
  bool levelUp;
  Function callback;
  Function callbackIncrement;

  @override
  _RanksCounterState createState() => _RanksCounterState();
}

class _RanksCounterState extends State<RanksCounter> {
  int minCounterValue;
  @override
  Widget build(BuildContext context) {
    minCounterValue = widget.counter;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: <Widget>[
        InkWell(
          onTap: (){
            if(widget.counter != widget.maxCounterValue && widget.availableRanks != 0){
              widget.callback();
              setState((){
                widget.counter++;
              }); 
            }
          },
          child: Container(
            decoration: BoxDecoration(
              color: !widget.levelUp ? Colors.grey : Theme.of(context).primaryColor,
              borderRadius: BorderRadius.circular(3.0),
            ),
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
            if(widget.counter < minCounterValue){
              widget.callbackIncrement();
                setState((){
                  widget.counter--;
                });
              }
            },
          child: Container(
            decoration: BoxDecoration(
              color: Theme.of(context).primaryColor,
              borderRadius: BorderRadius.circular(3.0),
            ),
            child: Icon(Icons.remove),
          ),
        )
      ],
    );
  }

  Widget inableButton(IconData icon){
    return InkWell(
      child: Container(
        decoration: BoxDecoration(
          color: !widget.levelUp ? Colors.grey : Theme.of(context).primaryColor,
          borderRadius: BorderRadius.circular(3.0),
        ),
        child: Icon(icon),
      ),
    );
  }
}