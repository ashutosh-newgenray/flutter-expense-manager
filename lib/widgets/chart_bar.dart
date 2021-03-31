import 'package:flutter/material.dart';

class ChartBar extends StatelessWidget {
  final day;
  final spendingAmount;
  final spendingPerOfTotal;
  ChartBar(this.day, this.spendingAmount, this.spendingPerOfTotal);

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(builder: (ctx, constraints) {
      return Column(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          Container(
            height: constraints.maxHeight * 0.05,
            child: FittedBox(
              child: Text('\$${spendingAmount.toStringAsFixed(0)}',
                  style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold)),
            ),
          ),
          SizedBox(height: constraints.maxHeight * 0.05),
          Container(
            height: constraints.maxHeight * 0.56,
            width: 15,
            color: Theme.of(context).accentColor,
            child: Stack(children: [
              Container(
                decoration: BoxDecoration(
                    border: Border.all(color: Colors.grey, width: 1.0),
                    color: Colors.grey.shade300,
                    borderRadius: BorderRadius.circular(4)),
              ),
              FractionallySizedBox(
                  heightFactor: spendingPerOfTotal,
                  child: Container(
                      decoration:
                          BoxDecoration(color: Theme.of(context).accentColor)))
            ]),
          ),
          SizedBox(height: constraints.maxHeight * 0.05),
          Text(day)
        ],
      );
    });
  }
}
