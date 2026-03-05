class EndPoints {
  static const baseLogin = 'https://softpos-mpoc.omaemirates.com:19097';
  static const refreshtoken = '/NanoUMS/v1/refreshToken/';
  static const baseSwitchMonitoring =
      'https://softpos-mpoc.omaemirates.com:18084';
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
