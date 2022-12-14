import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

const gPrimaryColor = Color(0xff4E7215);
// const gsecondaryColor = Color(0xffC10B02);
const gsecondaryColor = Color(0xffD10034);

const gBlackColor = Color(0xff000000);
const gWhiteColor = Color(0xffFFFFFF);
const gContentColor = Color(0xff346604);
const gGreyColor = Color(0xff707070);
const gMainColor = Color(0xffC7A102);
const gHintTextColor = Color(0xff4A4848);

const gTextColor = Color(0xff2D414B);
const gTapColor = Color(0xffF8FAFF);
const gBackgroundColor = Color(0xffFFE889);

const kPrimaryColor = Color(0xffBB0A36);
const kSecondaryColor = Color(0xffFFF5F5);
const kTextColor = Color(0xff000000);
const kWhiteColor = Color(0xffFFFFFF);
const kContentColor = Color(0xffFE4F60);
const kGutColor = Color(0xffFF0040);
const kWellnessColor = Color(0xffFD5D5D);
const kWellColor = Color(0xffCC4764);
const kSectionColor = Color(0xffFF597D);
const kSoundColor = Color(0xffE6A790);
const kDetailsColor = Color(0xffFF5A7F);
const kHealthColor = Color(0xffD10034);

const kDividerColor = Color(0xff000029);


const String kFontMedium = 'GothamMedium';
const String kFontBook = 'GothamBook';
const String kFontLight = 'GothamLight';
const String kFontRBold1 = 'GothamRoundedBold';
const String kFontBold = 'GothamBold';
const String kFontRBold2 = 'GothamRoundedBold_21016';
const String kFontBlack = 'GothamBlack';
const String kFontPoppinsRegular = 'PoppinsRegular';


const kButtonColor = Color(0xffD10034);


// existing user
class eUser{
  var kRadioButtonColor = gsecondaryColor;
  var threeBounceIndicatorColor = gWhiteColor;

  var mainHeadingColor = gBlackColor;
  var mainHeadingFont = kFontRBold2;
  double mainHeadingFontSize = 13.sp;

  var userFieldLabelColor =  Colors.black87.withOpacity(0.7);
  var userFieldLabelFont = kFontBlack;
  double userFieldLabelFontSize = 11.sp;
  /*
  fontFamily: "GothamBook",
  color: gGreyColor,
  fontSize: 11.sp
   */
  var userTextFieldColor =  gGreyColor;
  var userTextFieldFont = kFontBook;
  double userTextFieldFontSize = 11.sp;

  var userTextFieldHintColor =  Colors.grey.withOpacity(0.5);
  var userTextFieldHintFont = kFontPoppinsRegular;
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
  var resendOtpFontColor = gBlackColor;
  var resendOtpFontDisableColor = Colors.grey.withOpacity(0.5);

  var buttonColor = kButtonColor;
  var buttonTextColor = gWhiteColor;
  double buttonTextSize = 10.sp;
  var buttonTextFont = kFontRBold2;
  var buttonBorderColor = gMainColor;
  double buttonBorderWidth = 1;



  var buttonBorderRadius = 30.0;

  var loginDummyTextColor =  Colors.black87;
  var loginDummyTextFont = kFontBook;
  double loginDummyTextFontSize = 9.sp;

  var anAccountTextColor =  gGreyColor;
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
  var kDayTextFont = kFontRBold2;

  var topViewHeadingText = gBlackColor;
  double topViewHeadingFontSize = 12.sp;
  var topViewHeadingFont = kFontMedium;

  var topViewSubText = gBlackColor.withOpacity(0.5);
  double topViewSubFontSize = 9.sp;
  var topViewSubFont = kFontBook;

  var kBottomViewHeadingText = gsecondaryColor;
  double kBottomViewHeadingFontSize = 12.sp;
  var kBottomViewHeadingFont = kFontMedium;

  var kBottomViewSubText = gGreyColor;
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
  var kBottomSheetBenefitsFont = kFontLight;

  var threeBounceIndicatorColor = gWhiteColor;
}


class MealPlanConstants{
  var dayBorderColor = Color(0xFFE2E2E2);
  var dayBorderDisableColor = gGreyColor;
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
  var groupHeaderFont = kFontRBold1;
  double groupHeaderFontSize = 12.sp;

  var mustHaveTextColor = gsecondaryColor;
  var mustHaveFont = kFontBold;
  double mustHaveFontSize = 6.sp;

  var mealNameTextColor = gBlackColor;
  var mealNameFont = kFontBold;
  double mealNameFontSize = 12.sp;

  var benifitsFont = kFontLight;
  double benifitsFontSize = 8.sp;
}