
import 'app_config.dart';

/// new API's
var getProblemListUrl = "${AppConfig().BASE_URL}/api/list/problem_list";

var submitProblemListUrl = "${AppConfig().BASE_URL}/api/form/submit_problems";

var getAboutProgramUrl = "${AppConfig().BASE_URL}/api/list/welcome_screen";

var registerUserUrl = "${AppConfig().BASE_URL}/api/register";
/// shiprocket Api
var shippingApiLoginUrl = "${AppConfig().shipRocket_AWB_URL}/auth/login";

var shippingApiUrl = "${AppConfig().shipRocket_AWB_URL}/courier/track/awb";

var loginWithOtpUrl = "${AppConfig().BASE_URL}/api/otp_login";

var logOutUrl = "${AppConfig().BASE_URL}/api/logout";

var getOtpUrl = "${AppConfig().BASE_URL}/api/sendOTP";

var getAppointmentSlotsListUrl = "${AppConfig().BASE_URL}/api/getData/slots/";

var bookAppointmentUrl = "${AppConfig().BASE_URL}/api/getData/book";

var enquiryStatusUrl = "${AppConfig().BASE_URL}/api/form/check_enquiry_status";

var submitEvaluationFormUrl = "${AppConfig().BASE_URL}/api/submitForm/evaluation_form";

var getEvaluationDataUrl = "${AppConfig().BASE_URL}/api/getData/get_evaluation_data";

var getDashboardDataUrl = "${AppConfig().BASE_URL}/api/getData/get_dashboard_data";

var getUserProfileUrl = "${AppConfig().BASE_URL}/api/user";

var termsConditionUrl = "${AppConfig().BASE_URL}/api/list/terms_and_conditions";

var uploadReportUrl = "${AppConfig().BASE_URL}/api/submitForm/user_report";

var getUserReportListUrl = "${AppConfig().BASE_URL}/api/getData/user_reports_list";

var getMealProgramDayListUrl = "${AppConfig().BASE_URL}/api/listData/user_program_details";

/// need to pass day number 1,2,3 ....
var getMealPlanDataUrl = "${AppConfig().BASE_URL}/api/getDataList/user_day_meal_plan";

var submitDayPlanDetailsUrl = "${AppConfig().BASE_URL}/api/submitData/patient_meal_tracking";


//  old apis
// var welcomeTextUrl = "${AppConfig().BASE_URL}/api/list/welcome_text";
// var postLoginUrl = "${AppConfig().BASE_URL}/login";
// var termsConditionUrl =
//     "${AppConfig().BASE_URL}/api/list/terms_and_conditions";
// var getProblemListUrl = "${AppConfig().BASE_URL}/api/list/problem_list";
// var submitProblemListUrl = "${AppConfig().BASE_URL}/api/form/submit_problems";

// var getThankYouTextUrl = "${AppConfig().BASE_URL}/api/list/thank_you_text";
// var getDocumentTextUrl = "${AppConfig().BASE_URL}/api/list/document_text";
// var registerUserUrl = "${AppConfig().BASE_URL}/api/register";
// var sendOTPUrl = "${AppConfig().BASE_URL}/api/sendOTP";
// var validateOTPUrl = "${AppConfig().BASE_URL}/api/validateOTP";
// var getProgramDetailsUrl =
//     "${AppConfig().BASE_URL}/api/getData/get_program_details";
// var sendPaymentIdUrl = "${AppConfig().BASE_URL}/api/submitForm/payment";
// var getAppointmentSlotsListUrl = "${AppConfig().BASE_URL}/api/getData/slots/";
// var bookAppointmentUrl = "${AppConfig().BASE_URL}/api/getData/book";
// var uploadReportUrl = "${AppConfig().BASE_URL}/api/submitForm/user_report";
// var getUserReportListUrl =
//     "${AppConfig().BASE_URL}/api/getData/user_reports_list";
// var submitEvaluationFormUrl =
//     "${AppConfig().BASE_URL}/api/submitForm/evaluation_form";
// var getUserProfileUrl = "${AppConfig().BASE_URL}/api/user";