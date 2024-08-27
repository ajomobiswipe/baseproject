import 'package:baseproject/gen/assets.gen.dart';
import 'package:baseproject/pages/monitoring/onboarding_dashboard.dart';
import 'package:baseproject/pages/monitoring/transaction_dashboard.dart';
import 'package:baseproject/widgets/radialChart/radial_chart.dart';
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
        backgroundColor: Colors.white,
        appBar: AppBar(
          backgroundColor: Colors.blue,
          title: Text(
            getTitle(),
            style: TextStyle(color: Colors.white),
          ),
        ),
        // appBar: PreferredSize(
        //   preferredSize:
        //       Size.fromHeight(MediaQuery.of(context).size.height / 4),
        //   child: TabBar(
        //     controller: _tabController,
        //     tabs: const [
        //       Tab(
        //         icon: Icon(Icons.graphic_eq),
        //         text: "Status",
        //       ),
        //       Tab(
        //         icon: Icon(Icons.view_week_outlined),
        //         text: "Week",
        //       ),
        //       Tab(
        //         icon: Icon(Icons.calendar_month),
        //         text: "Month",
        //       ),
        //       Tab(
        //         icon: Icon(Icons.local_convenience_store_outlined),
        //         text: "Custom",
        //       ),
        //     ],
        //     onTap: (value) {
        //       dataMonitoringProvider.changeMonitoringInfo(tabIndex: value);
        //     },
        //   ),
        // ),
        body: getHomescreenItems(currentIndex),
        bottomNavigationBar: Container(
          decoration: BoxDecoration(
            // color: Colors.white,
            boxShadow: [
              BoxShadow(
                blurRadius: 20,
                color: Colors.black.withOpacity(.1),
              )
            ],
          ),
          child: SafeArea(
            child: Padding(
              padding:
                  const EdgeInsets.symmetric(horizontal: 15.0, vertical: 8),
              child: GNav(
                rippleColor: Colors.grey[300]!,
                hoverColor: Colors.grey[100]!,
                gap: 8,
                activeColor: Colors.blue,
                iconSize: 24,
                padding: EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                duration: Duration(milliseconds: 400),
                tabBackgroundColor: Colors.grey[100]!,
                color: Colors.grey,
                tabs: [
                  GButton(
                    icon: Icons.dashboard,
                    text: 'Status',
                  ),
                  GButton(
                    icon: Icons.add_chart_rounded,
                    text: 'Onboarding',
                  ),
                  GButton(
                    icon: Icons.receipt_long,
                    text: 'Transactions',
                  ),
                ],
                selectedIndex: currentIndex,
                onTabChange: (index) {
                  setState(() {
                    currentIndex = index;
                  });
                },
              ),
            ),
          ),
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
        Positioned(
          bottom: 0,
          child: Row(
            children: [
              Image.asset(
                Assets.images.alliance.path,
                height: 70,
              ),
            ],
          ),
        ),
        const SizedBox(height: 40),
        SizedBox(
          height: screenHeight,
          width: screenWidth,
          child: ListView(
            children: [
              const SizedBox(height: 40),
              Consumer<DataMonitoringProvider>(
                  builder: (context, dataProvider, child) {
                return GridView.builder(
                  itemCount: dataProvider.dashboardData.length,
                  padding: const EdgeInsets.all(16.0),
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 3,
                    crossAxisSpacing: 16.0,
                    mainAxisSpacing: 16.0,
                    childAspectRatio: 1,
                  ),
                  itemBuilder: (context, index) {
                    return RadialChart(
                      title: dataProvider.dashboardData[index].title,
                      percent: dataProvider.dashboardData[index].percentage,
                      lineColor: dataProvider.dashboardData[index].linecolor,
                    );
                  },
                );
              }),
              // const SizedBox(height: 20),
              // Container(
              //   height: screenWidth / 2,
              //   child: PieChart(
              //     swapAnimationDuration: const Duration(milliseconds: 750),
              //     swapAnimationCurve: Curves.easeInOutQuint,
              //     PieChartData(
              //       sections: list,
              //     ),
              //   ),
              // ),
              // const Row(
              //   mainAxisAlignment: MainAxisAlignment.center,
              //   children: [
              //     Text(
              //       'System Status',
              //       style: TextStyle(
              //         color: Colors.brown,
              //         fontSize: 20,
              //         fontWeight: FontWeight.bold,
              //       ),
              //     ),
              //   ],
              // ),
              // const SizedBox(height: 20), // Add some space before the row
              // const Row(
              //   mainAxisAlignment: MainAxisAlignment.center,
              //   children: [
              //     IconTextRow(
              //       iconData: Icons.rectangle_rounded,
              //       iconColor: Colors.red,
              //       text: 'Memory',
              //     ),
              //     SizedBox(width: 15),
              //     IconTextRow(
              //       iconData: Icons.rectangle_rounded,
              //       iconColor: Colors.blueAccent,
              //       text: 'CPU',
              //     ),
              //     SizedBox(width: 15),
              //     IconTextRow(
              //       iconData: Icons.rectangle_rounded,
              //       iconColor: Colors.teal,
              //       text: 'Storage',
              //     ),
              //   ],
              // ),
              const SizedBox(height: 40),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  Column(
                    children: [
                      Image.asset(
                        Assets.images.visa.path,
                        height: 100,
                      ),
                      Container(
                        height: 30,
                        width: 40,
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(20),
                            border: Border.all(color: Colors.black, width: 2),
                            color: Colors.blue),
                      ),
                    ],
                  ),
                  Column(
                    children: [
                      Image.asset(
                        Assets.images.mastercard.path,
                        height: 100,
                      ),
                      Container(
                        height: 30,
                        width: 40,
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(20),
                            border: Border.all(color: Colors.black, width: 2),
                            color: Colors.orange),
                      ),
                    ],
                  ),
                ],
              ),
              const SizedBox(height: 40),
              commonTable(),
              const SizedBox(height: 20),
              // commonTable(headereTwo, rowsTwo),
            ],
          ),
        ),
      ],
    );
  }

  Padding commonTable() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 10),
      child: Consumer<DataMonitoringProvider>(
          builder: (context, dataProvider, child) {
        return Table(
          columnWidths: const {
            0: FlexColumnWidth(4),
            1: FlexColumnWidth(4),
            2: FlexColumnWidth(4),
            3: FlexColumnWidth(4),
            4: FlexColumnWidth(2),
          },
          border: TableBorder.all(color: Colors.grey),
          children: [
            // First Row (Headers)
            TableRow(
              decoration: const BoxDecoration(color: Colors.black),
              children: dataProvider.headers
                  .map((header) => _buildTableCell(header,
                      fontWeight: FontWeight.bold, color: Colors.white))
                  .toList(),
            ),
            // Data Rows
            // TableRow(
            //   children: [
            //     _buildTableCell("Visa"),
            //     _buildTableCell(dataProvider.todayData[0]["visaApprovedCount"]),
            //     _buildTableCell(dataProvider.todayData[0]["visaDeclinedCount"]),
            //     _buildTableCell("1"),
            //     _buildTableCell("1"),
            //   ],
            // )
            ...dataProvider.uiData.map((data) {
              return TableRow(
                children: [
                  _buildTableCell(data.schemeName),
                  _buildTableCell(data.approved),
                  _buildTableCell(data.declined),
                  _buildTableCell(data.reversal),
                  _buildTableCell(data.percentage)
                ],
              );
            }).toList(),
          ],
        );
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
