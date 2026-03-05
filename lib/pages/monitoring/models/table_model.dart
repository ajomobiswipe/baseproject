import 'package:baseproject/pages/monitoring/models/chart_data_model.dart';
import 'package:flutter/material.dart';

class MonitoringTableModel {
  final String schemeName;
  final int approved;
  final int declined;
  final int reversal;
  final double percentage;

  MonitoringTableModel(
      {required this.schemeName,
      required this.approved,
      required this.declined,
      required this.reversal,
      required this.percentage});
}

class DashBoardModel {
  final String serviceName;
  final String Status;
  final double cpuPercentage;
  final double memmoryPercentage;
  final String memmoryStatus;

  DashBoardModel(
      {required this.serviceName,
      required this.Status,
      required this.cpuPercentage,
      required this.memmoryStatus,
      required this.memmoryPercentage});
}
