class EndPoints {
  static const baseLogin = 'http://172.29.100.221:9508';
  static const baseSwitchMonitoring = 'http://172.29.100.221:9508';
  static const loginAPI = "/NanoPay/v1/login";
  // static const dashBoardData =
  //     "/NanoPay/Middleware/UiApi/getTransactionDashboardData";

  static const dashBoardData =
      "/NanoPay/Middleware/UiApi/txnReport?pageNumber=0&size=10&sort=insertDateTime,desc";
  static const getOnboardingDashboardData =
      "/NanoPay/Middleware/UiApi/getOnboardingDashboardData";
  static const getTransactionDashboardData =
      "/NanoPay/Middleware/UiApi/getTransactionDashboardData";
}
