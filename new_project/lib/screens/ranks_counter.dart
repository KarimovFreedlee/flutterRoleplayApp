import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class RanksCounter extends StatefulWidget {
  RanksCounter({this.counter = 0, this.maxCounterValue, this.minCounterValue, this.availableRanks, this.levelUp});
  int counter;
  int maxCounterValue;
  int minCounterValue;
  int availableRanks;
  bool levelUp;

  @override
  _RanksCounterState createState() => _RanksCounterState();
}

class _RanksCounterState extends State<RanksCounter> {
  @override
  Widget build(BuildContext context) {
    final _textNotifier = context.watch<ValueNotifier<int>>();
    return widget.levelUp ? Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: <Widget>[
        InkWell(
          onTap: (){
            if(widget.counter != widget.maxCounterValue &&  _textNotifier.value != 0){
              _textNotifier.value-=1;
              setState((){
                widget.counter++;
              });
            }
          },
          child: widget.counter == widget.maxCounterValue ? Container(height: 25) :  Container(
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
            if(widget.counter > widget.minCounterValue){
              _textNotifier.value+=1;
              setState((){
                widget.counter--;
              });
            }
          },
          child: widget.counter == widget.minCounterValue ? Container(height: 25) : Container(
            decoration: BoxDecoration(
              color: !widget.levelUp ? Colors.grey : Theme.of(context).primaryColor,
              borderRadius: BorderRadius.circular(3.0),
            ),
            child: Icon(Icons.remove),
          ),
        )
      ],
      ) : Center(
              child: Text(
                '${widget.counter}',
                textAlign: TextAlign.center,
              ),
            );
  }
}