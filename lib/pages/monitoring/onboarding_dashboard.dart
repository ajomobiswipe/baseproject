import 'package:baseproject/pages/chart_type.dart';
import 'package:baseproject/pages/monitoring/onboarding_barchart.dart';
import 'package:flutter/material.dart';

import 'package:baseproject/pages/chart_type.dart';
import 'package:baseproject/pages/monitoring/onboarding_barchart.dart';
import 'package:flutter/material.dart';

class OnboardingDashBoard extends StatelessWidget {
  final dynamic merchantOnboardData;

  const OnboardingDashBoard({
    Key? key,
    required this.merchantOnboardData,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    if (merchantOnboardData == null) {
      return const Center(child: Text("No Data Available"));
    }

    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: ListView(
        children: [
          _buildChart(
            title: "Merchant Onboard Count",
            yearly: merchantOnboardData['yearlyMerchantCount'],
            monthly: merchantOnboardData['monthlyMerchantCount'],
            weekly: merchantOnboardData['weeklyMerchantCount'],
          ),
          _buildChart(
            title: "Terminal Onboard Count",
            yearly: merchantOnboardData['yearlyTerminalCount'],
            monthly: merchantOnboardData['monthlyTerminalCount'],
            weekly: merchantOnboardData['weeklyTerminalCount'],
          ),
        ],
      ),
    );
  }

  Widget _buildChart({
    required String title,
    dynamic yearly,
    dynamic monthly,
    dynamic weekly,
  }) {
    if (yearly == null && monthly == null && weekly == null) {
      return Card(
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Center(child: Text("No Data Available for $title")),
        ),
      );
    }

    return OnboardingBarChart(
      title: title,
      yearlyMerchantOnboardData: yearly ?? [],
      monthlyMerchantOnboardData: monthly ?? [],
      weeklyMerchantOnboardData: weekly ?? [],
      chatytype: ChartType.Day,
    );
  }
}
