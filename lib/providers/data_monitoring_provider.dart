import 'dart:convert';
import 'package:baseproject/services/monitoring_service.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
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
  List<DashBoardModel> dashboardDataList = [];

  Map<String, dynamic>? currentMonthData;
  Map<String, dynamic>? todayData;
  dynamic merchantOnboardData;
  dynamic transactionDashBoardData;
  List<dynamic> dashBoardData = [];
  String lastUpdatedTime = "";
  final Map<String, dynamic> stayusReq = {
    "fromDate": DateFormat("dd-MM-yyyy").format(DateTime.now()),
    "toDate": DateFormat("dd-MM-yyyy").format(DateTime.now()),
    "acquirerId": "GDEAOMA0101",
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
    "instId": "GDEAOMA0101",
    "processDate": DateFormat("dd-MM-yyyy").format(DateTime.now()),
    "apiType": "1"
  };
  final Map<String, String> transactionDashboardreq = {
    "appProductId": "6",
    "instId": "GDEAOMA0101",
    "processDate": DateFormat("dd-MM-yyyy").format(DateTime.now()),
    "apiType": "2"
  };
  List<MonitoringTableModel> uiData = [];
  final List<ChartDataModel> chartDataModel = [
    ChartDataModel(color: Colors.cyan, title: "System"),
    ChartDataModel(color: Colors.green, title: "Cpu"),
    ChartDataModel(color: Colors.lightBlue, title: "Memory"),
  ];

  Future<void> getDashboardData() async {
    // try {
    final response = await monitoringService.getDashboardData(stayusReq);
    final Map<String, dynamic> data = json.decode(response.body);

    if (data['data'] != null && data['data'].isNotEmpty) {
      final dashboard = data['data'][0];

      if (dashboard['txnInfo'] != null && dashboard['txnInfo'].isNotEmpty) {
        todayData = dashboard['txnInfo'][0];
      } else {
        todayData = null;
      }

      dashBoardData = dashboard['applicationStatus'];
    }
    dashboardDataList.clear();
    notifyListeners();

    for (var service in dashBoardData) {
      String serviceName = service["serviceName"] ?? "Unknown Service";
      String cpuString = service["cpu"] ?? "0%";
      double cpuPercentage = double.parse(cpuString.replaceAll('%', ''));

      String memoryString = service["memory"] ?? "0GiB / 0GiB";
      String serviceStatus = service["status"] ?? "Unknown";

// Split the memory string into used and total parts
      List<String> memoryParts = memoryString.split('/');

      double usedMemory = parseMemory(memoryParts[0].trim());
      double totalMemory = 0;

      if (memoryParts.length > 1) {
        totalMemory = parseMemory(memoryParts[1].trim());
      }

      double memoryPercentage =
          totalMemory > 0 ? usedMemory / totalMemory : 0.0;
      print(dashboardDataList.length);
      dashboardDataList.add(DashBoardModel(
          serviceName: serviceName,
          cpuPercentage: cpuPercentage / 100,
          Status: serviceStatus,
          memmoryPercentage: memoryPercentage,
          memmoryStatus: memoryString));
    }
    lastUpdatedTime =
        "${DateFormat("dd-MM-yyyy:").format(DateTime.now())} ${DateFormat("HH:mm:ss").format(DateTime.now())}";
    print("outside loop ${dashboardDataList.length}");
    notifyListeners();
    // } catch (error) {
    //   print("Error fetching data: $error");
    // }
  }

  Future<void> getOnboardingDashboardData() async {
    try {
      final response = await monitoringService
          .getOnboardingDashboardData(onboardingDashboardReq);
      final Map<String, dynamic> data = json.decode(response.body);

      merchantOnboardData = data['data'][0];
      notifyListeners();
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
      notifyListeners();
    } catch (error) {
      print("Error fetching data: $error");
    }
  }

  void setDefaultValues() {
    //if (todayData == null) return;
  }

  double parseMemory(String value) {
    if (value.contains("MiB")) {
      return double.parse(value.replaceAll("MiB", "")) / 1024;
    } else if (value.contains("GiB")) {
      return double.parse(value.replaceAll("GiB", ""));
    }
    return 0;
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
