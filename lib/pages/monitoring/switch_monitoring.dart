import 'package:baseproject/gen/assets.gen.dart';
import 'package:baseproject/main.dart';
import 'package:baseproject/pages/monitoring/onboarding_dashboard.dart';
import 'package:baseproject/pages/monitoring/transaction_dashboard.dart';
import 'package:baseproject/widgets/logout.dart';
import 'package:baseproject/widgets/radialChart/radial_chart.dart';
import 'package:baseproject/widgets/trns_summary_widget.dart';
import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/widgets.dart';
import 'package:provider/provider.dart';

import '../../providers/providers.dart';
import 'package:google_nav_bar/google_nav_bar.dart';

class SwitchMonitoring extends StatefulWidget {
  const SwitchMonitoring({super.key});

  @override
  State<SwitchMonitoring> createState() => _SwitchMonitoringState();
}

class _SwitchMonitoringState extends State<SwitchMonitoring>
    with SingleTickerProviderStateMixin {
  int currentIndex = 0;
  late DataMonitoringProvider dataMonitoringProvider;
  bool isDarkMode = false;
  Logout _logout = Logout();
  @override
  void initState() {
    super.initState();
    //testfun();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      dataMonitoringProvider =
          Provider.of<DataMonitoringProvider>(context, listen: false);
      //dataMonitoringProvider.setDefaultValues();

      dataMonitoringProvider.getDashboardData();
      dataMonitoringProvider.getOnboardingDashboardData();
      dataMonitoringProvider.getTransactionDashboardData();
      TokenManager tokenManager = TokenManager();
      tokenManager.start(navigatorKey.currentContext!);
    });
  }

  getTitle() {
    switch (currentIndex) {
      case 0:
        return "System Status";
      case 1:
        return "Onboarding Dashboard";
      case 2:
        return "Tranasctions Dashboard";
    }
  }

  @override
  Widget build(BuildContext context) {
    isDarkMode = Theme.of(context).brightness == Brightness.dark;
    // dataMonitoringProvider =
    //     Provider.of<DataMonitoringProvider>(context, listen: false);
    var list = [
      PiChrItem(color: Colors.red, value: 20),
      PiChrItem(color: Colors.blueAccent, value: 60),
      PiChrItem(color: Colors.teal, value: 60),
    ];

    return SafeArea(
      child: Scaffold(
        // backgroundColor: Colors.white,
        appBar: AppBar(
          actions: [
            IconButton(
                onPressed: () {
                  dataMonitoringProvider.getDashboardData();
                },
                icon: Icon(Icons.refresh)),
            IconButton(
                onPressed: () {
                  _logout.bottomSheet(context);
                },
                icon: Icon(Icons.logout)),
          ],
          backgroundColor: Colors.blue,
          title: Text(
            getTitle(),
            style: TextStyle(color: Colors.white),
          ),
        ),
        body: getHomescreenItems(currentIndex),
        bottomNavigationBar: BottomNavigationBar(
          currentIndex: currentIndex, // The currently selected index
          onTap: (index) {
            setState(() {
              currentIndex = index;
            });
          },
          items: [
            BottomNavigationBarItem(
              icon: Icon(Icons.dashboard),
              label: 'Status',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.add_chart_rounded),
              label: 'Onboarding',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.receipt_long),
              label: 'Transactions',
            ),
          ],
          selectedItemColor: Colors.blue, // Color for the selected item
          unselectedItemColor: Colors.grey, // Color for the unselected items
          // Background color of the BottomNavigationBar
          type: BottomNavigationBarType
              .fixed, // Ensures the labels are always visible
        ),
      ),
    );
  }

  getHomescreenItems(int index) {
    switch (index) {
      case 0:
        return systemStatus();
      case 1:
        return OnboardingDashBoard(
          merchantOnboardData: dataMonitoringProvider.merchantOnboardData,
        );
      case 2:
        return TransactionDashBoard(
          transactionDashBoardData:
              dataMonitoringProvider.transactionDashBoardData,
        );
    }
  }

  Stack systemStatus() {
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;
    return Stack(
      children: [
        const SizedBox(height: 40),
        SizedBox(
          height: screenHeight,
          width: screenWidth,
          child: ListView(
            children: [
              commonTable(),
              const SizedBox(height: 40),
              Consumer<DataMonitoringProvider>(
                  builder: (context, dataProvider, child) {
                return ListView.builder(
                  itemCount: dataProvider.dashboardDataList.length,
                  padding: const EdgeInsets.all(16.0),
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  itemBuilder: (context, index) {
                    final service = dataProvider.dashboardDataList[index];

                    return Padding(
                      padding: const EdgeInsets.only(bottom: 12),
                      child: serviceCard(service),
                    );
                  },
                );
              }),
              const SizedBox(height: 40),
            ],
          ),
        ),
      ],
    );
  }

  Widget serviceCard(service) {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(14),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              service.serviceName,
              style: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 12),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                RadialChart(
                  title: "CPU",
                  subtitle:
                      "${(service.cpuPercentage * 100).toStringAsFixed(2)}%",
                  percent: service.cpuPercentage,
                  lineColor:
                      service.cpuPercentage < 0.5 ? Colors.green : Colors.red,
                ),
                RadialChart(
                  title: "Memory",
                  subtitle: service.memmoryStatus,
                  percent: service.memmoryPercentage,
                  lineColor: service.memmoryPercentage < 0.5
                      ? Colors.green
                      : Colors.red,
                ),
              ],
            )
          ],
        ),
      ),
    );
  }

  Padding commonTable() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 10),
      child: Consumer<DataMonitoringProvider>(
          builder: (context, dataProvider, child) {
        return TransactionSummaryWidget(txn: dataProvider.todayData);
        // return Table(
        //   columnWidths: const {
        //     0: FlexColumnWidth(4),
        //     1: FlexColumnWidth(4),
        //     2: FlexColumnWidth(4),
        //     3: FlexColumnWidth(4),
        //     4: FlexColumnWidth(2),
        //   },
        //   border: TableBorder.all(color: Colors.grey),
        //   children: [
        //     // First Row (Headers)
        //     TableRow(
        //       decoration: const BoxDecoration(color: Colors.black),
        //       children: dataProvider.headers
        //           .map((header) => _buildTableCell(header,
        //               fontWeight: FontWeight.bold, color: Colors.white))
        //           .toList(),
        //     ),

        //     ...dataProvider.uiData.map((data) {
        //       return TableRow(
        //         children: [
        //           _buildTableCell(data.schemeName),
        //           _buildTableCell(data.approved),
        //           _buildTableCell(data.declined),
        //           _buildTableCell(data.reversal),
        //           _buildTableCell(data.percentage)
        //         ],
        //       );
        //     }).toList(),
        //   ],
        // );
      }),
    );
  }

  Widget _buildTableCell(dynamic text,
          {fontWeight = FontWeight.normal, Color? color}) =>
      TableCell(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Text(
            text.toString(),
            style: TextStyle(fontWeight: fontWeight, color: color),
          ),
        ),
      );

  PieChartSectionData PiChrItem({double? value, Color? color}) {
    return PieChartSectionData(
      value: value,
      color: color,
    );
  }
}

class IconTextRow extends StatelessWidget {
  final IconData iconData;
  final Color iconColor;
  final String text;

  const IconTextRow({
    Key? key,
    required this.iconData,
    required this.iconColor,
    required this.text,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Icon(iconData, color: iconColor),
        const SizedBox(width: 5),
        Text(text),
      ],
    );
  }
}
