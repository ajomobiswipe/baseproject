import 'dart:convert';

import 'package:baseproject/config/endpoints.dart';
import 'package:baseproject/main.dart' as NavigationService;
import 'package:baseproject/services/connection.dart';
import 'package:baseproject/storage/secure_storage.dart';

import '../config/Config.dart';

class MonitoringService {
  getDashboardData(requestModel) async {
    Connection connection = Connection();
    var url = EndPoints.baseSwitchMonitoring + EndPoints.dashBoardData;
    print(url);
    var response = await connection.post(url, requestModel);
    return response;
  }

  getOnboardingDashboardData(requestModel) async {
    Connection connection = Connection();
    var url =
        EndPoints.baseSwitchMonitoring + EndPoints.getOnboardingDashboardData;
    print(url);
    var response = await connection.post(url, requestModel);
    return response;
  }

  getTransactionDashboardData(requestModel) async {
    Connection connection = Connection();
    var url =
        EndPoints.baseSwitchMonitoring + EndPoints.getTransactionDashboardData;
    print(url);
    var response = await connection.post(url, requestModel);
    return response;
  }

  BoxStorage boxStorage = BoxStorage();
  Future refreshToken() async {
    Connection connection = Connection();
    String token = boxStorage.getToken();
    var url = '${EndPoints.baseRefreshToken}${EndPoints.refreshtoken}$token';

    var response = await connection.get(
      url,
    );

    var decodedData = jsonDecode(response.body);

    if (response.statusCode == 401) {
      NavigationService.navigatorKey.currentState
          ?.pushReplacementNamed('login');

      clearStorage();
      return;
    }

    BoxStorage secureStorage = BoxStorage();
    secureStorage.saveUserDetails(decodedData);

    if (response.statusCode == 200) {
      return decodedData;
    }
  }
}
