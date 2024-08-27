import 'package:baseproject/config/endpoints.dart';
import 'package:baseproject/services/connection.dart';

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
}
