class EndPoints {
  static const baseLogin = 'https://omasoftposqc.omaemirates.com:9097';
  static const basedashboard = 'http://172.29.100.221:9508';
  static const baseSwitchMonitoring =
      'https://omasoftposqc.omaemirates.com:9512';
  static const loginAPI = "/NanoUMS/v1/login";
  static const baseApiPublic9097 =
      'https://omasoftposqc.omaemirates.com:9097/NanoUMS/v1/';
  // static const dashBoardData =
  //     "/NanoPay/Middleware/UiApi/getTransactionDashboardData";
  static const dashBoardData =
      "/NanoPay/Middleware/UiApi/txnReport?pageNumber=0&size=10&sort=insertDateTime%2Cdesc";
  static const getOnboardingDashboardData =
      "/NanoPay/Middleware/UiApi/getOnboardingDashboardData";
  static const getTransactionDashboardData =
      "/NanoPay/Middleware/UiApi/getTransactionDashboardData";
}
