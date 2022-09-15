
import 'app_config.dart';

/// new API's
var getProblemListUrl = "${AppConfig().BASE_URL}/api/list/problem_list";

var submitProblemListUrl = "${AppConfig().BASE_URL}/api/form/submit_problems";

var getAboutProgramUrl = "${AppConfig().BASE_URL}/api/list/welcome_screen";

var registerUserUrl = "${AppConfig().BASE_URL}/api/register";
/// shiprocket Api
var shippingApiUrl = AppConfig().shipRocket_AWB_URL;

var loginWithOtpUrl = "${AppConfig().BASE_URL}/api/otp_login";

var getOtpUrl = "${AppConfig().BASE_URL}/api/sendOTP";

var getAppointmentSlotsListUrl = "${AppConfig().BASE_URL}/api/getData/slots/";

var bookAppointmentUrl = "${AppConfig().BASE_URL}/api/getData/book";

var enquiryStatusUrl = "${AppConfig().BASE_URL}/api/form/check_enquiry_status";




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