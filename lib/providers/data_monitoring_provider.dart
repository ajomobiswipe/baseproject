import 'dart:convert';
import 'package:baseproject/services/monitoring_service.dart';
import 'package:flutter/material.dart';
import '../pages/monitoring/models/chart_data_model.dart';
import '../pages/monitoring/models/table_model.dart';

class DataMonitoringProvider with ChangeNotifier {
  final List<String> headers = [
    "Schemes",
    "Approved",
    "Declined",
    "Reversal",
    "%"
  ];
  final List<String> headereTwo = [
    "Overall",
    "Approved",
    "Declined",
    "Reversal",
    "%"
  ];
  final MonitoringService monitoringService = MonitoringService();
  List<DashBoardModel> dashboardData = [];

  Map<String, dynamic>? currentMonthData;
  Map<String, dynamic>? todayData;
  dynamic merchantOnboardData;
  dynamic transactionDashBoardData;
  Map<String, dynamic>? dashBoardData;
  final Map<String, dynamic> stayusReq = {
    "fromDate": "24-07-2024",
    "toDate": "27-07-2024",
    "acquirerId": "ADIBOMA0001",
    "merchantId": null,
    "rrn": "",
    "authCode": null,
    "cardNo": null,
    "responseCode": null,
    "transactionType": "",
    "terminalId": null
  };
  final Map<String, String> onboardingDashboardReq = {
    "appProductId": "6",
    "instId": "ADIBOMA0001",
    "processDate": "2024-08-26",
    "apiType": "1"
  };
  final Map<String, String> transactionDashboardreq = {
    "appProductId": "6",
    "instId": "ADIBOMA0001",
    "processDate": "2024-08-25",
    "apiType": "2"
  };
  List<MonitoringTableModel> uiData = [];
  final List<ChartDataModel> chartDataModel = [
    ChartDataModel(color: Colors.cyan, title: "System"),
    ChartDataModel(color: Colors.green, title: "Cpu"),
    ChartDataModel(color: Colors.lightBlue, title: "Memory"),
  ];

  Future<void> getDashboardData() async {
    final int month = DateTime.now().month;
    try {
      final response = await monitoringService.getDashboardData(stayusReq);
      final Map<String, dynamic> data = json.decode(response.body);

      todayData = data['data'][0]['txnInfo'][0];
      dashBoardData = data['data'][0]['applicationStatus'][0];
      // print(dashBoardData!["serviceName"]);
      print(todayData);
      print(dashBoardData);

      setDefaultValues();
    } catch (error) {
      print("Error fetching data: $error");
    }
  }

  Future<void> getOnboardingDashboardData() async {
    try {
      final response = await monitoringService
          .getOnboardingDashboardData(onboardingDashboardReq);
      final Map<String, dynamic> data = json.decode(response.body);

      merchantOnboardData = data['data'][0];
    } catch (error) {
      print("Error fetching data: $error");
    }
  }

  Future<void> getTransactionDashboardData() async {
    try {
      final response = await monitoringService
          .getTransactionDashboardData(transactionDashboardreq);
      final Map<String, dynamic> data = json.decode(response.body);
      transactionDashBoardData = data['data'][0];
      print(data['data'][0]);
    } catch (error) {
      print("Error fetching data: $error");
    }
  }

  void setDefaultValues() {
    if (todayData == null) return;
    dashboardData = [];
    String cpuString = dashBoardData!["cpu"] ?? "0%";
    double cpuPercentage = double.parse(cpuString.replaceAll('%', ''));

    String memoryString = dashBoardData!["memory"] ?? "0GiB / 0GiB";

// Split the memory string into used and total parts
    List<String> memoryParts = memoryString.split(" / ");
    double usedMemory = double.parse(memoryParts[0].replaceAll("GiB", ""));
    double totalMemory = double.parse(memoryParts[1].replaceAll("GiB", ""));

    dashboardData.add(DashBoardModel(
        linecolor: Colors.cyan, title: "CPU", percentage: cpuPercentage / 100));
    dashboardData.add(
      DashBoardModel(
          linecolor: Colors.teal,
          title: "Memory",
          percentage: usedMemory / totalMemory),
    );
    dashboardData.add(DashBoardModel(
        linecolor: Colors.orange, title: "Storage", percentage: 0.56));

    uiData = [
      MonitoringTableModel(
        schemeName: "Visa",
        approved: todayData!["visaSaleAprCnt"] ?? 0,
        declined: todayData!["totNonAprVisaCnt"] ?? 0,
        reversal: todayData!["visaRefundAprCnt"] ?? 0,
        percentage: (todayData!["visaApprovedCount"] ?? 0).toDouble(),
      ),
      MonitoringTableModel(
        schemeName: "Master",
        approved: todayData!["mcCrSaleAprCnt"] ?? 0,
        declined: todayData!["mcrdDeclinedCount"] ?? 0,
        reversal: todayData!["mcrdReversalCount"] ?? 0,
        percentage: (todayData!["mcrdApprovedCount"] ?? 0).toDouble(),
      ),
    ];

    notifyListeners();
  }

  void changeMonitoringInfo({required int tabIndex}) {
    // setDefaultValues();
    // switch (tabIndex) {
    //   case 0:
    //     setDefaultValues();
    //     break;
    //   case 1:
    //     setWeeklyValues();
    //     break;
    //   case 2:
    //     setMonthlyValues();
    //     break;
    // }
  }

  // void setWeeklyValues() {
  //   num visaApprovedCount = 0;
  //   num visaDeclineCount = 0;
  //   num visaReversalCount = 0;
  //   num masterApprovedCount = 0;
  //   num masterDeclineCount = 0;
  //   num masterReversalCount = 0;

  //   for (var item in currentWeekData) {
  //     visaApprovedCount += item["visaApprovedCount"] ?? 0;
  //     visaDeclineCount += item["visaDeclinedCount"] ?? 0;
  //     visaReversalCount += item["visaApprovedCountRefund"] ?? 0;
  //     masterApprovedCount += item["mcrdApprovedCount"] ?? 0;
  //     masterDeclineCount += item["mcrdDeclinedCount"] ?? 0;
  //     masterReversalCount += item["mcrdApprovedCountRefund"] ?? 0;
  //   }

  //   uiData = [
  //     MonitoringTableModel(
  //       schemeName: "Visa",
  //       approved: visaApprovedCount.toInt(),
  //       declined: visaDeclineCount.toInt(),
  //       reversal: visaReversalCount.toInt(),
  //       percentage: visaApprovedCount.toDouble(),
  //     ),
  //     MonitoringTableModel(
  //       schemeName: "Master",
  //       approved: masterApprovedCount.toInt(),
  //       declined: masterDeclineCount.toInt(),
  //       reversal: masterReversalCount.toInt(),
  //       percentage: masterApprovedCount.toDouble(),
  //     ),
  //   ];

  //   notifyListeners();
  // }

  void setMonthlyValues() {
    if (currentMonthData == null) return;

    uiData = [
      MonitoringTableModel(
        schemeName: "Visa",
        approved: currentMonthData!["visaApprovedCount"] ?? 0,
        declined: currentMonthData!["visaDeclinedCount"] ?? 0,
        reversal: currentMonthData!["visaApprovedCountRefund"] ?? 0,
        percentage: (currentMonthData!["visaApprovedCount"] ?? 0).toDouble(),
      ),
      MonitoringTableModel(
        schemeName: "Master",
        approved: currentMonthData!["mcrdApprovedCount"] ?? 0,
        declined: currentMonthData!["mcrdDeclinedCount"] ?? 0,
        reversal: currentMonthData!["mcrdApprovedCountRefund"] ?? 0,
        percentage: (currentMonthData!["visaApprovedCount"] ?? 0).toDouble(),
      ),
    ];

    notifyListeners();
  }
}
