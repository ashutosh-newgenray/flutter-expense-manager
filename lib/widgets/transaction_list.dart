import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../models/transaction.dart';

class TransactionList extends StatelessWidget {
  final List<Transaction> transactions;
  final Function delTrx;

  TransactionList(this.transactions, this.delTrx);

  @override
  Widget build(BuildContext context) {
    return transactions.isEmpty
        ? Column(mainAxisAlignment: MainAxisAlignment.spaceEvenly, children: [
            Text('Start By adding new Transaction',
                style: Theme.of(context).textTheme.title),
            SizedBox(height: 50),
            Container(
                height: 200,
                child: Image.asset("images/zzz.png", fit: BoxFit.cover))
          ])
        : ListView.builder(
            itemCount: transactions.length,
            itemBuilder: (ctx, index) {
              return Card(
                elevation: 6,
                margin: EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                child: ListTile(
                    leading: CircleAvatar(
                      radius: 30,
                      child: Padding(
                        padding: EdgeInsets.all(5),
                        child: FittedBox(
                            child: Text(
                                '\$${transactions[index].amount.toString()}')),
                      ),
                    ),
                    title: Text(transactions[index].title,
                        style: Theme.of(context).textTheme.title),
                    subtitle: Text(
                        DateFormat.yMMMd().format(transactions[index].date)),
                    trailing: IconButton(
                      icon: Icon(Icons.delete,
                          color: Theme.of(context).errorColor),
                      onPressed: () => delTrx(transactions[index].id),
                    )),
              );
            },
          );
  }
}
