import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

const gPrimaryColor = Color(0xff4E7215);
// const gsecondaryColor = Color(0xffC10B02);
const gsecondaryColor = Color(0xffD10034);
const gMainColor = Color(0xffC7A102);


const gBlackColor = Color(0xff000000);
const gWhiteColor = Color(0xffFFFFFF);
const gHintTextColor = Color(0xff676363);
const kLineColor = Color(0xffB9B4B4);


const gTextColor = gBlackColor;
const gTapColor = Color(0xffF8FAFF);
const gBackgroundColor = Color(0xffFAFAFA);
const gSitBackBgColor = Color(0xffFFE889);


const kPrimaryColor = Color(0xffBB0A36);
const kSecondaryColor = Color(0xffFFF5F5);
const kTextColor = Color(0xff000000);
const kWhiteColor = Color(0xffFFFFFF);

const kDividerColor = Color(0xff000029);


const String kFontMedium = 'GothamMedium';
const String kFontBook = 'GothamBook';
const String kFontBold = 'GothamBold';


const kButtonColor = Color(0xffD10034);

/// tracker ui fonts
double headingFont = 12.sp;
double subHeadingFont = 10.sp;
double questionFont = 10.sp;


// existing user
class eUser{
  var kRadioButtonColor = gsecondaryColor;
  var threeBounceIndicatorColor = gWhiteColor;

  var mainHeadingColor = gBlackColor;
  var mainHeadingFont = kFontBold;
  double mainHeadingFontSize = 13.sp;

  var userFieldLabelColor =  gBlackColor;
  var userFieldLabelFont = kFontMedium;
  double userFieldLabelFontSize = 11.sp;
  /*
  fontFamily: "GothamBook",
  color: gHintTextColor,
  fontSize: 11.sp
   */
  var userTextFieldColor =  gHintTextColor;
  var userTextFieldFont = kFontBook;
  double userTextFieldFontSize = 11.sp;

  var userTextFieldHintColor =  Colors.grey.withOpacity(0.5);
  var userTextFieldHintFont = kFontMedium;
  double userTextFieldHintFontSize = 10.sp;

  var focusedBorderColor = gBlackColor;
  var focusedBorderWidth = 1.5;

  var fieldSuffixIconColor = gPrimaryColor;
  var fieldSuffixIconSize = 22;

  var fieldSuffixTextColor =  gBlackColor.withOpacity(0.5);
  var fieldSuffixTextFont = kFontMedium;
  double fieldSuffixTextFontSize = 8.sp;

  var resendOtpFontSize = 9.sp;
  var resendOtpFont = kFontBook;
  var resendOtpFontColor = gsecondaryColor;

  var buttonColor = kButtonColor;
  var buttonTextColor = gWhiteColor;
  double buttonTextSize = 12.sp;
  var buttonTextFont = kFontBold;
  var buttonBorderColor = kLineColor;
  double buttonBorderWidth = 1;



  var buttonBorderRadius = 30.0;

  var loginDummyTextColor =  Colors.black87;
  var loginDummyTextFont = kFontBook;
  double loginDummyTextFontSize = 9.sp;

  var anAccountTextColor =  gHintTextColor;
  var anAccountTextFont = kFontMedium;
  double anAccountTextFontSize = 10.sp;

  var loginSignupTextColor =  gsecondaryColor;
  var loginSignupTextFont = kFontBold;
  double loginSignupTextFontSize = 10.5.sp;

}

class PPConstants{
  final bgColor = Color(0xffFAFAFA).withOpacity(1);

  var kDayText = gBlackColor;
  double kDayTextFontSize = 13.sp;
  var kDayTextFont = kFontBold;

  var topViewHeadingText = gBlackColor;
  double topViewHeadingFontSize = 12.sp;
  var topViewHeadingFont = kFontMedium;

  var topViewSubText = gBlackColor.withOpacity(0.5);
  double topViewSubFontSize = 9.sp;
  var topViewSubFont = kFontBook;

  var kBottomViewHeadingText = gsecondaryColor;
  double kBottomViewHeadingFontSize = 12.sp;
  var kBottomViewHeadingFont = kFontMedium;

  var kBottomViewSubText = gHintTextColor;
  double kBottomViewSubFontSize = 8.5.sp;
  var kBottomViewSubFont = kFontBook;

  var kBottomViewSuffixText = gBlackColor.withOpacity(0.5);
  double kBottomViewSuffixFontSize = 8.sp;
  var kBottomViewSuffixFont = kFontBook;

  var kBottomSheetHeadingText = gsecondaryColor;
  double kBottomSheetHeadingFontSize = 12.sp;
  var kBottomSheetHeadingFont = kFontMedium;

  /// this is for benefits answer
  var kBottomSheetBenefitsText = gBlackColor;
  /// this is for benefits answer
  double kBottomSheetBenefitsFontSize = 10.sp;
  /// this is for benefits answer
  var kBottomSheetBenefitsFont = kFontMedium;

  var threeBounceIndicatorColor = gWhiteColor;
}


class MealPlanConstants{
  var dayBorderColor = Color(0xFFE2E2E2);
  var dayBorderDisableColor = gHintTextColor;
  var dayTextColor = gBlackColor;
  var dayTextSelectedColor = gWhiteColor;
  var dayBgNormalColor = gWhiteColor;
  var dayBgSelectedColor = gPrimaryColor;
  var dayBgPresentdayColor = gsecondaryColor;
  double dayBorderRadius = 8.0;
  double presentDayTextSize = 10.sp;
  double DisableDayTextSize = 10.sp;
  var dayTextFontFamily = kFontMedium;
  var dayUnSelectedTextFontFamily = kFontBook;

  var groupHeaderTextColor = gBlackColor;
  var groupHeaderFont = kFontBook;
  double groupHeaderFontSize = 12.sp;

  var mustHaveTextColor = gsecondaryColor;
  var mustHaveFont = kFontBold;
  double mustHaveFontSize = 8.sp;

  var mealNameTextColor = gBlackColor;
  var mealNameFont = kFontMedium;
  double mealNameFontSize = 12.sp;

  var benifitsFont = kFontBook;
  double benifitsFontSize = 10.sp;

}