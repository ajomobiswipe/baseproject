import 'package:baseproject/pages/chart_type.dart';
import 'package:baseproject/pages/monitoring/onboarding_barchart.dart';
import 'package:flutter/material.dart';

class OnboardingDashBoard extends StatelessWidget {
  final dynamic merchantOnboardData;
  const OnboardingDashBoard({Key? key, required this.merchantOnboardData})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: ListView(
        children: [
          OnboardingBarChart(
            title: "Merchant Onboard Count",
            yearlyMerchantOnboardData:
                merchantOnboardData['yearlyMerchantCount'],
            monthlyMerchantOnboardData:
                merchantOnboardData['monthlyMerchantCount'],
            weeklyMerchantOnboardData:
                merchantOnboardData['weeklyMerchantCount'],
            chatytype: ChartType.Day,
          ),
          OnboardingBarChart(
            title: "Terminal Onboard Count",
            yearlyMerchantOnboardData:
                merchantOnboardData['yearlyTerminalCount'],
            monthlyMerchantOnboardData:
                merchantOnboardData['monthlyTerminalCount'],
            weeklyMerchantOnboardData:
                merchantOnboardData['weeklyTerminalCount'],
            chatytype: ChartType.Day,
          ),
        ],
      ),
    );
  }
}
