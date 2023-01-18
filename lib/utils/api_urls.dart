
import 'app_config.dart';

/// new API's
var getProblemListUrl = "${AppConfig().BASE_URL}/api/list/problem_list";

var submitProblemListUrl = "${AppConfig().BASE_URL}/api/form/submit_problems";

var getAboutProgramUrl = "${AppConfig().BASE_URL}/api/list/welcome_screen";

var registerUserUrl = "${AppConfig().BASE_URL}/api/register";
/// shiprocket Api
var shippingApiLoginUrl = "${AppConfig().shipRocket_AWB_URL}/auth/login";

var shippingApiUrl = "${AppConfig().shipRocket_AWB_URL}/courier/track/awb";

var shoppingListApiUrl = "${AppConfig().BASE_URL}/api/getData/get_shopping_list";

var shoppingApproveApiUrl = "${AppConfig().BASE_URL}/api/submitForm/update_shipping_approval";

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

var updateUserProfileUrl = "${AppConfig().BASE_URL}/api/submitForm/update_user_profile";

var termsConditionUrl = "${AppConfig().BASE_URL}/api/list/terms_and_conditions";

var uploadReportUrl = "${AppConfig().BASE_URL}/api/submitForm/user_report";

var getUserReportListUrl = "${AppConfig().BASE_URL}/api/getData/user_reports_list";

var getMealProgramDayListUrl = "${AppConfig().BASE_URL}/api/listData/user_program_details";

/// need to pass day number 1,2,3 ....
var getMealPlanDataUrl = "${AppConfig().BASE_URL}/api/getDataList/user_day_meal_plan";

var submitDayPlanDetailsUrl = "${AppConfig().BASE_URL}/api/submitData/patient_meal_tracking";

/// feedback Url
var submitFeedbackUrl = "${AppConfig().BASE_URL}/api/submitForm/feedback";

var getCallSupportUrl = "${AppConfig().BASE_URL}/api/getData/call_support";

var startProgramOnSwipeUrl = "${AppConfig().BASE_URL}/api/submitForm/start_program";

var chatGroupIdUrl = "${AppConfig().BASE_URL}/api/getData/get_chat_messages_group";

/// this is called after all 15 days completed than on click on next clap ui we need to hit this api
var startPostProgramUrl = "${AppConfig().BASE_URL}/api/submitForm/post_program";

var submitPostProgramMealTrackingUrl = "${AppConfig().BASE_URL}/api/submitData/post_program_meal_tracking";

var getPPEarlyMorningUrl = "${AppConfig().BASE_URL}/api/getDataList/protocol_guide_meal_plan/early_morning";

var getPPBreakfastUrl = "${AppConfig().BASE_URL}/api/getDataList/protocol_guide_meal_plan/breakfast";

var getPPMidDayUrl = "${AppConfig().BASE_URL}/api/getDataList/protocol_guide_meal_plan/mid_day";

var getPPLunchUrl = "${AppConfig().BASE_URL}/api/getDataList/protocol_guide_meal_plan/lunch";

var getPPEveningUrl = "${AppConfig().BASE_URL}/api/getDataList/protocol_guide_meal_plan/evening";

var getPPDinnerUrl = "${AppConfig().BASE_URL}/api/getDataList/protocol_guide_meal_plan/dinner";

var getPPPostDinnerUrl = "${AppConfig().BASE_URL}/api/getDataList/protocol_guide_meal_plan/post_dinner";

/// this is called on protocol home page and also
/// if user already submited details based on the day selection details will get
var getProtocolDayDetailsUrl = "${AppConfig().BASE_URL}/api/getDataList/protocol_guide_day_score";

var doctorRequestedReportListUrl = "${AppConfig().BASE_URL}/api/getData/requested_reports_list/doctor_requested_reports";

var submitDoctorRequestedReportUrl = "${AppConfig().BASE_URL}/api/submitForm/requested_user_report";

var notificationListUrl = "${AppConfig().BASE_URL}/api/getData/notification_list";

var rewardPointsUrl = "${AppConfig().BASE_URL}/api/getDataList/get_user_reward_points";

var rewardPointsStagesUrl = "${AppConfig().BASE_URL}/api/getDataList/user_stages_levels";

var faqListUrl = "${AppConfig().BASE_URL}/api/getDataList/faq_list";

var submitStatusTrackerUrl = "${AppConfig().BASE_URL}/api/submitData/patient_meal_tracking";

var getHomeDetailsUrl = "${AppConfig().BASE_URL}/api/getDataList/user_stages_data";

var daySummaryUrl = "${AppConfig().BASE_URL}/api/getDataList/protocol_summary";

var ppCalendarUrl = "${AppConfig().BASE_URL}/api/getDataList/protocol_meal_tracking_calendar";



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