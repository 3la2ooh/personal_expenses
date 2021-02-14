import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
// import 'package:flutter/services.dart';

import './widgets/new_transaction.dart';
import './widgets/transaction_list.dart';
import './widgets/chart.dart';
import './models/transaction.dart';

void main() {
  // WidgetsFlutterBinding.ensureInitialized();
  // SystemChrome.setPreferredOrientations([
  //   DeviceOrientation.portraitUp,
  //   DeviceOrientation.portraitDown,
  // ]);
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Platform.isIOS
        ? CupertinoApp(
            title: 'Personal Expenses',
            theme: CupertinoThemeData(
              primaryColor: Colors.purple,
              primaryContrastingColor: Colors.amber,
              // fontFamily: 'Quicksand',
              textTheme: CupertinoTextThemeData(
                textStyle: TextStyle(
                  fontFamily: 'OpenSans',
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            home: MyHomePage(),
          )
        : MaterialApp(
            title: 'Personal Expenses',
            theme: ThemeData(
              primarySwatch: Colors.purple,
              accentColor: Colors.amber,
              fontFamily: 'Quicksand',
              textTheme: ThemeData.light().textTheme.copyWith(
                    headline6: TextStyle(
                      fontFamily: 'OpenSans',
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                    button: TextStyle(
                      color: Colors.white,
                    ),
                  ),
              appBarTheme: AppBarTheme(
                textTheme: ThemeData.light().textTheme.copyWith(
                      headline6: TextStyle(
                        fontFamily: 'OpenSans',
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
              ),
            ),
            home: MyHomePage(),
          );
  }
}

class MyHomePage extends StatefulWidget {
  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  final List<Transaction> _userTransactions = [
    Transaction(
      id: 't1',
      amount: 99.99,
      title: 'Shoes',
      date: DateTime.now(),
    ),
    Transaction(
      id: 't2',
      amount: 15.99,
      title: 'Socks',
      date: DateTime.now().subtract(Duration(days: 3)),
    ),
    Transaction(
      id: 't3',
      amount: 10.49,
      title: 'Shawarma',
      date: DateTime.now().subtract(Duration(days: 5)),
    ),
  ];
  bool _showChart = true;

  @override
  Widget build(BuildContext context) {
    final isLandscape =
        MediaQuery.of(context).orientation == Orientation.landscape;

    final PreferredSizeWidget appBar = Platform.isIOS
        ? CupertinoNavigationBar(
            middle: Text('Personal Expenses'),
            trailing: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                GestureDetector(
                  onTap: () => this._onStartAdding(context),
                  child: Icon(CupertinoIcons.add),
                ),
              ],
            ),
          )
        : AppBar(
            title: Text('Personal Expenses'),
            actions: [
              IconButton(
                icon: Icon(
                  Icons.add,
                ),
                onPressed: () => this._onStartAdding(context),
              ),
            ],
          );

    final pageBody = SafeArea(
      child: SingleChildScrollView(
        child: Column(
          children: <Widget>[
            if (isLandscape)
              Container(
                height: this._getHeight(appBar) * 0.15,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text('Show Chart'),
                    Switch.adaptive(
                      value: this._showChart,
                      activeColor: Theme.of(context).accentColor,
                      onChanged: (value) {
                        setState(() {
                          this._showChart = value;
                        });
                      },
                    )
                  ],
                ),
              ),
            if (isLandscape)
              this._showChart
                  ? Container(
                      height: this._getHeight(appBar) * 0.6,
                      child: Chart(this._recentTransactions),
                    )
                  : this._getTransactionList(appBar, 0.85),
            if (!isLandscape)
              Container(
                height: this._getHeight(appBar) * 0.3,
                child: Chart(this._recentTransactions),
              ),
            if (!isLandscape) this._getTransactionList(appBar, 0.7),
          ],
          crossAxisAlignment: CrossAxisAlignment.stretch,
        ),
      ),
    );

    return Platform.isIOS
        ? CupertinoPageScaffold(
            navigationBar: appBar,
            child: pageBody,
          )
        : Scaffold(
            appBar: appBar,
            body: pageBody,
            floatingActionButton: Platform.isIOS
                ? Container()
                : FloatingActionButton(
                    child: Icon(Icons.add),
                    onPressed: () => this._onStartAdding(context),
                  ),
            floatingActionButtonLocation:
                FloatingActionButtonLocation.centerFloat,
          );
  }

  Container _getTransactionList(AppBar appBar, double multiplicity) {
    return Container(
      height: this._getHeight(appBar) * multiplicity,
      child: TransactionList(
        _userTransactions,
        _deleteTransaction,
      ),
    );
  }

  double _getHeight(AppBar appBar) {
    return MediaQuery.of(context).size.height -
        appBar.preferredSize.height -
        MediaQuery.of(context).padding.top;
  }

  List<Transaction> get _recentTransactions {
    return this._userTransactions.where((transaction) {
      return transaction.date.isAfter(
        DateTime.now().subtract(
          Duration(days: 7),
        ),
      );
    }).toList();
  }

  void _addNewTransaction(String title, double amount, DateTime date) {
    final newTransaction = Transaction(
        title: title,
        amount: amount,
        date: date,
        id: DateTime.now().toString());

    setState(() {
      _userTransactions.add(newTransaction);
    });
  }

  void _deleteTransaction(String id) {
    setState(() {
      this._userTransactions.removeWhere((element) => element.id == id);
    });
  }

  void _onStartAdding(BuildContext context) {
    showModalBottomSheet(
      isScrollControlled: true,
      context: context,
      builder: (_) {
        return NewTransaction(_addNewTransaction);
      },
    );
  }
}
