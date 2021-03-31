import 'dart:io';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_app1/widgets/new_transaction.dart';
import 'widgets/transaction_list.dart';
import 'widgets/new_transaction.dart';
import 'widgets/chart.dart';
import 'models/transaction.dart';
import 'package:flutter/services.dart';

void main() {
  // SystemChrome.setPreferredOrientations(
  //     [DeviceOrientation.portraitUp, DeviceOrientation.portraitUp]);
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        title: 'Expense Manager',
        theme: ThemeData(
          primarySwatch: Colors.pink,
          accentColor: Colors.amber,
          fontFamily: 'Quicksand',
          textTheme: ThemeData.light().textTheme.copyWith(
                title: TextStyle(
                    fontFamily: 'OpenSans',
                    fontSize: 16,
                    fontWeight: FontWeight.bold),
              ),
          appBarTheme: AppBarTheme(
            textTheme: ThemeData.light().textTheme.copyWith(
                title: TextStyle(fontFamily: 'OpenSans', fontSize: 20)),
          ),
        ),
        home: MyExpenseManager());
  }
}

class MyExpenseManager extends StatefulWidget {
  @override
  _MyExpenseManagerState createState() => _MyExpenseManagerState();
}

class _MyExpenseManagerState extends State<MyExpenseManager> {
  String titleInput;
  String amountInput;
  bool _showChart = true;
  final List<Transaction> _userTransactions = [
    Transaction(
        id: 't1',
        title: 'Electricy Bill',
        amount: 23.4,
        date: DateTime.now().subtract(Duration(days: 2))),
    Transaction(
        id: 't2',
        title: 'Grocery Bill',
        amount: 15,
        date: DateTime.now().subtract(Duration(days: 1))),
  ];

  List<Transaction> get _recentTransactions {
    return _userTransactions.where(
      (tx) {
        return tx.date.isAfter(DateTime.now().subtract(Duration(days: 7)));
      },
    ).toList();
  }

  void _addNewTransaction(String title, double amount, DateTime selectedDate) {
    final newTx = Transaction(
        id: DateTime.now().toString(),
        title: title,
        amount: amount,
        date: selectedDate);

    setState(() {
      _userTransactions.add(newTx);
    });
  }

  void _deleteTransaction(id) {
    setState(() {
      _userTransactions.removeWhere((trx) => trx.id == id);
    });
  }

  void startAddNewTransaction(BuildContext ctx) {
    showModalBottomSheet(
        context: ctx,
        builder: (_) {
          return GestureDetector(
              onTap: () {},
              child: NewTransaction(_addNewTransaction),
              behavior: HitTestBehavior.opaque);
        });
  }

  @override
  Widget build(BuildContext context) {
    final mediaQuery = MediaQuery.of(context);
    final isLandscape =
        MediaQuery.of(context).orientation == Orientation.landscape;
    final isIOS = Platform.isIOS;
    final iconButton = IconButton(
      icon: const Icon(Icons.add),
      onPressed: () {
        startAddNewTransaction(context);
      },
    );
    final PreferredSizeWidget appBar = isIOS
        ? CupertinoNavigationBar(
            middle: Text('Expense Manager'),
            trailing: CupertinoButton(
              onPressed: () => setState(() => startAddNewTransaction(context)),
              child: const Icon(CupertinoIcons.add),
            ))
        : AppBar(
            title: const Text('Expense Manager'),
            actions: [iconButton],
          );
    final chartContainer = Container(
        height: (mediaQuery.size.height -
                appBar.preferredSize.height -
                mediaQuery.padding.top) *
            0.3,
        width: double.infinity,
        child: Chart(_recentTransactions));

    final pageBody = SafeArea(
        child: SingleChildScrollView(
            child: Column(
      children: [
        if (!isLandscape)
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text('Show Chart', style: TextStyle(fontSize: 12)),
              Switch.adaptive(
                value: _showChart,
                onChanged: (bool value) {
                  setState(() {
                    _showChart = !_showChart;
                  });
                },
              )
            ],
          ),
        if (_showChart && isLandscape) chartContainer,
        if (!isLandscape) chartContainer,
        Container(
            height: (mediaQuery.size.height -
                    appBar.preferredSize.height -
                    mediaQuery.padding.top) *
                0.7,
            child: TransactionList(_userTransactions, _deleteTransaction))
      ],
    )));
    return isIOS
        ? CupertinoPageScaffold(child: pageBody, navigationBar: appBar)
        : Scaffold(
            appBar: appBar,
            body: pageBody,
            floatingActionButtonLocation:
                FloatingActionButtonLocation.centerFloat,
            floatingActionButton: Platform.isIOS
                ? Container()
                : FloatingActionButton(
                    child: Icon(Icons.add),
                    onPressed: () {
                      startAddNewTransaction(context);
                    }),
          );
  }
}
