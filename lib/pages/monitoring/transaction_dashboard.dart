import 'package:baseproject/pages/chart_type.dart';
import 'package:baseproject/pages/monitoring/transaction_barchart.dart';
import 'package:flutter/material.dart';

class TransactionDashBoard extends StatelessWidget {
  final dynamic transactionDashBoardData;
  const TransactionDashBoard({Key? key, required this.transactionDashBoardData})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: ListView(
        children: [
          TranscationBarChart(
            title: "Trnsaction Count",
            monthlyTransactionData: transactionDashBoardData['monthlyTxnCount'],
            weeklytransactionData: transactionDashBoardData['weeklyTxnCount'],
            yearlyTransactionData: transactionDashBoardData['yearlyTxnCount'],
            chatytype: ChartType.Month,
          ),
        ],
      ),
    );
  }
}
