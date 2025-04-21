// var webApi = {'domain': 'https://prod.api.9andbeyond.com'}; //PROD
//var webApi = {'domain': 'https://devapi.9andbeyond.com'}; // NEW DEV PROD
var webApi = {'domain': 'http://10.0.0.54:4060'}; //HOME
// var webApi = {'domain': 'http://172.18.16.176:4060'}; //DEV UDM
// var webApi = {'domain': 'http://192.0.0.2:4060'}; //Hotspot
// var webApi = {'domain': 'http://192.168.170.168:4060'}; //Hotspot Paras
// var webApi = {'domain': 'http://172.0.0.94:4060'}; // HOJO

var endPoint = {
  // App Config
  'searchLocationFromGoogle': '/api/appConfig/searchLocationFromGoogle',
  'fetchCommonAppConfig': '/api/appConfig/fetchCommonAppConfig',
  'getAppConfigs': '/api/appConfig/getAppConfigs',

  // Banner
  'fetchBanners': '/api/banner/fetchBanners',

  // Authentication/
  'sendOTPtoUser': '/api/auth/sendOTPtoUser',
  'verifyOTPofUser': '/api/auth/verifyOTPofUser',
  'resendOTPtoUser': '/api/auth/resendOTPtoUser',
  'login': '/api/user/login',
  'signup': '/api/user/signup',
  'editProfile': '/api/user/editProfile',
  'refreshUser': '/api/user/refreshUser',
  'getAwsSignedUrl': '/api/user/getAwsSignedUrl',
  'deleteAccount': '/api/user/deleteAccount',
  'testStatus': '/api/auth/testStatus',

  // chatgpt
  'generateQuestions': '/api/chatgpt/generateQuestions',

  // addInterview
  'addInterview': '/api/interview/addInterview',
  'getInterviews': '/api/interview/getInterviews',
  'saveRecording': '/api/interview/saveRecording',
  'endInterviewSession': '/api/interview/endInterviewSession',
};
