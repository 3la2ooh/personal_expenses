import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import './chart-bar.dart';
import '../models/transaction.dart';

class Chart extends StatelessWidget {
  final List<Transaction> recentTransactions;

  Chart(this.recentTransactions);

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 6,
      child: Padding(
        padding: EdgeInsets.all(10),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: this.groupedTransactionValues.map((data) {
            return Flexible(
              fit: FlexFit.tight,
              child: ChartBar(
                  label: data['day'],
                  amount: data['amount'],
                  percentage: this.spendingTotal == 0.0
                      ? 0.0
                      : (data['amount'] as double) / this.spendingTotal),
            );
          }).toList(),
        ),
      ),
    );
  }

  double get spendingTotal {
    // double total = 0;
    // this.groupedTransactionValues.forEach((value) {
    //   return total += value['amount'];
    // });
    // return total;
    return this.groupedTransactionValues.fold(0.0, (sum, value) {
      return sum + value['amount'];
    });
  }

  List<Map<String, Object>> get groupedTransactionValues {
    return List.generate(7, (index) {
      final weekDay = DateTime.now().subtract(
        Duration(days: index),
      );
      double totalSum = 0;

      for (var i = 0; i < this.recentTransactions.length; i++) {
        if (this.recentTransactions[i].date.day == weekDay.day &&
            this.recentTransactions[i].date.month == weekDay.month &&
            this.recentTransactions[i].date.year == weekDay.year) {
          totalSum += this.recentTransactions[i].amount;
        }
      }

      return {
        'day': DateFormat.E().format(weekDay).substring(0, 1),
        'amount': totalSum,
      };
    }).reversed.toList();
  }
}
