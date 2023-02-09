import 'package:flutter/material.dart';
import 'package:gwc_customer/widgets/constants.dart';
import 'package:gwc_customer/widgets/widgets.dart';
import 'package:sizer/sizer.dart';

class NewScheduleScreen extends StatefulWidget {
  const NewScheduleScreen({Key? key}) : super(key: key);

  @override
  State<NewScheduleScreen> createState() => _NewScheduleScreenState();
}

class _NewScheduleScreenState extends State<NewScheduleScreen> {
  @override
  Widget build(BuildContext context) {
    return SafeArea(
        child: Scaffold(
          body: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                buildAppBar(() {
                  Navigator.pop(context);
                }),
                ListView.builder(
                  shrinkWrap: true,
                  itemCount: 4,
                    itemBuilder: (_, index){
                    return slotListTile("${index+1} Slot Dates.", "Your first consultation , Please book your timings");
                    }
                )
              ],
            ),
          ),
        )
    );
  }

  topBar(){
    return Row(
      children: [
        Icon(Icons.arrow_back_ios),
        Text("Your Slot Dates.")
      ],
    );
  }



  slotListTile(String topText, String middleText){
    return SizedBox(
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          children: [
            Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(topText,
                    style: TextStyle(
                      fontFamily:
                      kFontBold,
                      color: gsecondaryColor,
                      fontSize: 11.5.sp,
                    ),
                ),
                SizedBox(
                  height: 10,
                ),
                Text(middleText,
                  style: TextStyle(
                    fontFamily:
                    kFontMedium,
                    color: gTextColor,
                    fontSize: 10.sp,
                  ),
                ),
                SizedBox(
                  height: 8,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(Icons.calendar_month),
                        Text('Day 09',
                          style: TextStyle(
                            fontFamily:
                            kFontBold,
                            color: gBlackColor,
                            fontSize: 10.sp,
                          ),
                        ),
                      ],
                    ),
                    GestureDetector(
                      onTap: (){
                        showScheduleDialog();
                      },
                      child: Text("Schedule",
                        style: TextStyle(
                          fontFamily: kFontBook,
                          color: gsecondaryColor,
                          fontSize: 10.sp,
                          decoration: TextDecoration.underline,

                        ),
                      ),
                    )
                  ],
                )
              ],
            ),
            Divider()
          ],
        ),
      ),
    );
  }

  List morningSlotList = ["08:30AM", "09:00AM", "09:30AM", "10:00AM", "10:30AM", "11:00AM"];
  String selectedMorningSlot = "";
  List eveningSlotList = ["05:30AM", "06:00AM", "06:30AM", "07:00AM", "07:30AM", "08:00AM"];
  String selectedEveningSlot = "";

  showScheduleDialog(){
    return showDialog(
        context: context,
        builder: (_ctx){
          return StatefulBuilder(
              builder: (_, setState){
                return showCustomDialog(setState);
              }
          );
        }
    );

  }

  showCustomDialog(Function setState){
    return Dialog(
      shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(8.0))),
      // contentPadding: EdgeInsets.only(top: 10.0, bottom: 8),
      child: SingleChildScrollView(
        child: SizedBox(
          height: 50.h,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(
                height: 6,
              ),
              slotView("Morning"),
              Center(
                child: Wrap(
                  runAlignment: WrapAlignment.spaceBetween,
                  children: [
                    ...morningSlotList.map((e) => slotChip(e, 'Morning',isSelected: selectedMorningSlot.contains(e), setstate: setState))
                  ],
                ),
              ),
              SizedBox(
                height: 10,
              ),
              slotView("Evening"),
              SizedBox(
                height: 5,
              ),
              Center(
                child: Wrap(
                  children: [
                    ...eveningSlotList.map((e) => slotChip(e, "Evening",isSelected: selectedEveningSlot.contains(e), setstate: setState))
                  ],
                ),
              ),
              // SizedBox(
              //   height: 10,
              // ),
              Spacer(),
              Center(
                child: Container(
                  width: 30.w,
                  height: 5.h,
                  // padding: EdgeInsets.symmetric(vertical: 1.h, horizontal: 10.w),
                  decoration: BoxDecoration(
                    color: eUser().buttonColor,
                    borderRadius: BorderRadius.circular(eUser().buttonBorderRadius),
                    // border: Border.all(color: eUser().buttonBorderColor,
                    //     width: eUser().buttonBorderWidth),
                  ),
                  child: Center(
                    child: Text(
                      'Submit',
                      style: TextStyle(
                        fontFamily:
                        kFontBold,
                        color: gWhiteColor,
                        fontSize: 11.sp,
                      ),
                    ),
                  ),
                ),
              ),
              SizedBox(
                height: 10,
              )
            ],
          ),
        ),
      ),
    );
  }

  slotView(String slotName){
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 12),
      child: Text(slotName,
        style: TextStyle(
          fontFamily: kFontBold,
          fontSize: 12.sp
        ),
      ),
    );
  }

  slotChip(String time, String slotName,{bool isSelected = false, Function? setstate}){
    return GestureDetector(
      onTap: (){
        setstate!(() {
          if(slotName == "Evening"){
            selectedEveningSlot = time;
          }
          else{
            selectedMorningSlot = time;
          }
        });
      },
      child: Container(
        padding: EdgeInsets.symmetric(
          horizontal: 8,
          vertical: 7
        ),
        margin: EdgeInsets.symmetric(horizontal: 2, vertical: 3),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(6),
          color: isSelected ? gsecondaryColor : gTapColor
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
                Icons.timelapse_rounded,
                size: 10,
                color: isSelected ? gWhiteColor : gBlackColor
            ),
            Text(time,
              style: TextStyle(
                  color: isSelected ? gWhiteColor : gBlackColor
              ),
            )
          ],
        ),
      ),
    );
  }
}
