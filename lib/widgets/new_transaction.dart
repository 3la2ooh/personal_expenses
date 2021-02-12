import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class NewTransaction extends StatefulWidget {
  final Function onAddTransaction;

  NewTransaction(this.onAddTransaction);

  @override
  _NewTransactionState createState() => _NewTransactionState();
}

class _NewTransactionState extends State<NewTransaction> {
  final _titleController = TextEditingController();
  final _amountController = TextEditingController();
  DateTime _selectedDate;

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Card(
        child: Container(
          padding: EdgeInsets.only(
            left: 10,
            right: 10,
            top: 10,
            bottom: MediaQuery.of(context).viewInsets.bottom + 10,
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              TextField(
                decoration: InputDecoration(labelText: 'Title'),
                controller: this._titleController,
                onSubmitted: (_) => _submitData(),
              ),
              TextField(
                decoration: InputDecoration(labelText: 'Amount'),
                controller: this._amountController,
                keyboardType: TextInputType.numberWithOptions(decimal: true),
                onSubmitted: (_) => _submitData(),
              ),
              Row(
                children: [
                  Expanded(
                    child: Text(
                      this._selectedDate == null
                          ? 'No Date Chosen'
                          : 'Selected Date: ${DateFormat.yMd().format(this._selectedDate)}',
                    ),
                  ),
                  FlatButton(
                    child: Text(
                      'Choose Date',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    textColor: Theme.of(context).primaryColor,
                    onPressed: this._presentDatePicker,
                  )
                ],
              ),
              RaisedButton(
                child: Text('Add Transaction'),
                color: Theme.of(context).primaryColor,
                textColor: Theme.of(context).textTheme.button.color,
                onPressed: () => _submitData(),
              )
            ],
          ),
        ),
      ),
    );
  }

  void _submitData() {
    final title = this._titleController.text;
    final amount = this._amountController.text.isNotEmpty
        ? double.parse(this._amountController.text)
        : 0;

    if (title.isEmpty || amount <= 0 || this._selectedDate == null) return;

    widget.onAddTransaction(title, amount, this._selectedDate);

    // To close the bottom modal after submitting
    Navigator.of(context).pop();
  }

  void _presentDatePicker() {
    showDatePicker(
      context: context,
      initialDate:
          this._selectedDate == null ? DateTime.now() : this._selectedDate,
      firstDate: DateTime(DateTime.now().year),
      lastDate: DateTime.now(),
    ).then((date) {
      if (date == null) return;

      setState(() {
        this._selectedDate = date;
      });
    });
  }
}
