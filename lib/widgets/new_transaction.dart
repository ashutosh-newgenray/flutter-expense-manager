import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class NewTransaction extends StatefulWidget {
  final Function addTx;

  NewTransaction(this.addTx);

  @override
  _NewTransactionState createState() => _NewTransactionState();
}

class _NewTransactionState extends State<NewTransaction> {
  final _titleController = TextEditingController();
  final _amountController = TextEditingController();
  DateTime _selectedDate;
  void _submitData() {
    final enteredTitle = _titleController.text;
    final enteredAmount = double.parse(_amountController.text);
    if (enteredTitle.isEmpty || enteredAmount <= 0 || _selectedDate == null) {
      return;
    }
    widget.addTx(enteredTitle, enteredAmount, _selectedDate);

    Navigator.of(context).pop();
  }

  void _presentDatePicker() {
    showDatePicker(
            context: context,
            initialDate: DateTime.now(),
            firstDate: DateTime(2021),
            lastDate: DateTime.now())
        .then((pickedDate) => {
              if (pickedDate != null)
                {
                  setState(() {
                    _selectedDate = pickedDate;
                  })
                }
            });
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Card(
          elevation: 3,
          child: Container(
              padding: EdgeInsets.only(
                left: 10,
                top: 10,
                right: 10,
                bottom: MediaQuery.of(context).viewInsets.bottom + 10,
              ),
              child: Column(children: [
                TextField(
                  decoration: InputDecoration(labelText: 'Title'),
                  controller: _titleController,
                ),
                TextField(
                    keyboardType: TextInputType.number,
                    decoration: InputDecoration(labelText: 'Amount'),
                    controller: _amountController,
                    onSubmitted: (_) => _submitData),
                Container(
                  height: 70,
                  child: Row(children: [
                    Expanded(
                      child: Text(
                          _selectedDate == null
                              ? 'No Date Selected'
                              : DateFormat.yMMMMd().format(_selectedDate),
                          style: TextStyle(color: Colors.grey.shade700)),
                    ),
                    FlatButton(
                      child: Text('Choose Date',
                          style: TextStyle(
                              fontWeight: FontWeight.bold,
                              color: Theme.of(context).primaryColor)),
                      onPressed: _presentDatePicker,
                    )
                  ]),
                ),
                Container(
                    margin: EdgeInsets.only(top: 20),
                    child: FlatButton(
                      child: Text("Add Expense"),
                      color: Theme.of(context).accentColor,
                      onPressed: _submitData,
                    ))
              ]))),
    );
  }
}
