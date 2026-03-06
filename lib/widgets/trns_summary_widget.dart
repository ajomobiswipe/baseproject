import 'package:baseproject/gen/assets.gen.dart';
import 'package:baseproject/providers/data_monitoring_provider.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

class TransactionSummaryWidget extends StatelessWidget {
  final Map<String, dynamic>? txn;

  const TransactionSummaryWidget({
    super.key,
    this.txn,
  });

  @override
  Widget build(BuildContext context) {
    // if (txn == null) {
    //   return _noDataWidget();
    // }

    int visaSale = txn?["visaSaleAprCnt"] ?? 0;
    double visaSaleAmt = (txn?["visaSaleAprAmt"] ?? 0).toDouble();

    int visaRefund = txn?["visaRefundAprCnt"] ?? 0;
    double visaRefundAmt = (txn?["visaRefundAprAmt"] ?? 0).toDouble();

    int visaVoid = txn?["visaVoidAprCnt"] ?? 0;
    double visaVoidAmt = (txn?["visaVoidAprAmt"] ?? 0).toDouble();

    int mcSale = txn?["mcCrSaleAprCnt"] ?? 0;
    double mcSaleAmt = (txn?["mcCrSaleAprAmt"] ?? 0).toDouble();

    int mcRefund = txn?["mcCrRefundAprCnt"] ?? 0;
    double mcRefundAmt = (txn?["mcCrRefundAprAmt"] ?? 0).toDouble();

    int mcVoid = txn?["mcCrVoidAprCnt"] ?? 0;
    double mcVoidAmt = (txn?["mcCrVoidAprAmt"] ?? 0).toDouble();

    return Container(
      padding: const EdgeInsets.all(16),
      margin: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14),
        boxShadow: [
          BoxShadow(
            blurRadius: 8,
            color: Colors.grey.withOpacity(.2),
          )
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            "Transaction Summary",
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
          Consumer<DataMonitoringProvider>(
              builder: (context, dataProvider, child) {
            return Text(
              "Last Update: ${dataProvider.lastUpdatedTime}",
              style: TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.w500,
                  color: Colors.grey.shade600),
            );
          }),
          const SizedBox(height: 16),
          Row(
            children: [
              Expanded(
                child: _schemeCard(
                  "VISA",
                  Colors.blue,
                  sale: visaSale,
                  saleAmt: visaSaleAmt,
                  refund: visaRefund,
                  refundAmt: visaRefundAmt,
                  voidCnt: visaVoid,
                  voidAmt: visaVoidAmt,
                  iconPath: Assets.images.visa.path,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: _schemeCard(
                  "MasterCard",
                  Colors.orange,
                  sale: mcSale,
                  saleAmt: mcSaleAmt,
                  refund: mcRefund,
                  refundAmt: mcRefundAmt,
                  voidCnt: mcVoid,
                  voidAmt: mcVoidAmt,
                  iconPath: Assets.images.mastercard.path,
                ),
              ),
            ],
          )
        ],
      ),
    );
  }

  Widget _schemeCard(
    String title,
    Color color, {
    required int sale,
    required double saleAmt,
    required int refund,
    required double refundAmt,
    required int voidCnt,
    required double voidAmt,
    required String iconPath,
  }) {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.grey.shade200),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Text(title,
                  style: TextStyle(
                      fontWeight: FontWeight.bold, fontSize: 16, color: color)),
              SizedBox(width: 12),
              Image.asset(
                iconPath,
                height: 20,
              ),
            ],
          ),
          const SizedBox(height: 10),
          _row("Sales", sale, saleAmt, Colors.green),
          _row("Refund", refund, refundAmt, Colors.blue),
          _row("Void", voidCnt, voidAmt, Colors.orange),
        ],
      ),
    );
  }

  Widget _row(String label, int count, double amount, Color color) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: Row(
        children: [
          Icon(Icons.circle, size: 10, color: color),
          const SizedBox(width: 6),
          Expanded(child: Text(label)),
          Text("$count / ${amount.toStringAsFixed(2)}")
        ],
      ),
    );
  }

  Widget _noDataWidget() {
    return Container(
      padding: const EdgeInsets.all(24),
      margin: const EdgeInsets.all(12),
      alignment: Alignment.center,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14),
      ),
      child: const Text(
        "No Transaction Data Available",
        style: TextStyle(
          fontSize: 16,
          color: Colors.grey,
        ),
      ),
    );
  }
}
