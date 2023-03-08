import 'package:flutter/material.dart';
import 'package:gwc_customer/model/consultation_model/appointment_slot_model.dart';
import 'package:gwc_customer/model/consultation_model/child_slots_model.dart';
import 'package:gwc_customer/model/error_model.dart';
import 'package:gwc_customer/model/success_message_model.dart';
import 'package:gwc_customer/model/user_slot_for_schedule_model/user_slot_days_schedule_model.dart';
import 'package:gwc_customer/repository/user_slot_for_schedule_repository/schedule_slot_repository.dart';
import 'package:gwc_customer/services/user_slot_for_schedule_service/user_slot_for_schedule_service.dart';
import 'package:gwc_customer/utils/app_config.dart';
import 'package:gwc_customer/widgets/constants.dart';
import 'package:gwc_customer/widgets/widgets.dart';
import 'package:sizer/sizer.dart';
import 'package:intl/intl.dart';
import '../../repository/api_service.dart';
import 'package:http/http.dart' as http;

class NewScheduleScreen extends StatefulWidget {
  const NewScheduleScreen({Key? key}) : super(key: key);

  @override
  State<NewScheduleScreen> createState() => _NewScheduleScreenState();
}

class _NewScheduleScreenState extends State<NewScheduleScreen> {

  Future? getSlotDaysListFuture, slotFuture;

  Map<String, ChildSlotModel>? followUpSlots;
  final ScheduleSlotsRepository repository = ScheduleSlotsRepository(
    apiClient: ApiClient(
      httpClient: http.Client(),
    ),
  );

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getSlotDates();
  }

  getSlotDates() {
    getSlotDaysListFuture = GetUserScheduleSlotsForService(repository: repository).getShoppingDetailsListService();
  }

  getSlotFuture(String date){
    return GetUserScheduleSlotsForService(repository: repository).getFollowUpSlotsScheduleService(date);
  }

  String errorMsg = "";


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
                Expanded(child: FutureBuilder(
                    future: getSlotDaysListFuture,
                    builder: (_, snapshot){
                      if(snapshot.hasData){
                        if(snapshot.data.runtimeType == ErrorModel){
                          final res = snapshot.data as ErrorModel;
                          print(res);
                          return Center(
                            child: Text(res.message.toString() ?? ''),
                          );
                        }
                        else{
                          final res = snapshot.data as GetUserSlotDaysForScheduleModel;
                          return ListView.builder(
                              shrinkWrap: true,
                              itemCount: res.data?.length ?? 0,
                              itemBuilder: (_, index){
                                return slotListTile(res.data![index].date!,
                                    "Your Day ${res.data![index].day} Follow Up Call , Please book your timings", res.data?[index].slot ?? '', res.data?[index].date ?? '');
                              }
                          );
                        }
                      }
                      else if(snapshot.hasError){
                        return Center(
                          child: Text(snapshot.error.toString() ?? ''),
                        );
                      }
                      return Center(child: buildCircularIndicator(),);
                    }
                ))
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



  slotListTile(String dateText, String middleText, String daySlotNumber, String date){
    return SizedBox(
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          children: [
            Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(Icons.calendar_month),
                        Text(daySlotNumber,
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
                      onTap: () async {
                        if(date.isEmpty){
                          AppConfig().showSnackbar(context, "date getting empty", isError: true);
                        }
                        else{
                          showScheduleDialog(date);
                        }
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
                ),
                SizedBox(
                  height: 10,
                ),
                Text(dateText,
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
                Text(middleText,
                  style: TextStyle(
                    fontFamily:
                    kFontBook,
                    color: gTextColor,
                    fontSize: 10.sp,
                  ),
                ),
                SizedBox(
                  height: 8,
                ),

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

  List followUpSlotsList = [];
  String selectedSlot = "";
  String blockedSlot = "";
  String selectedDate = "";


  showScheduleDialog(String date) async{
    return await showDialog(
        context: context,
        builder: (_ctx){
          return StatefulBuilder(
              builder: (_, setState){
                return showCustomDialog(setState, date);
              }
          );
        }
    ). then((value) {
      selectedSlot = "";
    });

  }

  showCustomDialog(Function setState, String date){
    var inputFormat = DateFormat('dd-MM-yyyy');
    var date1 = inputFormat.parse(date);

    var outputFormat = DateFormat('yyyy-MM-dd');
    var date2 = outputFormat.format(date1);
    print(date2);
    return Dialog(
      shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(8.0))),
      // contentPadding: EdgeInsets.only(top: 10.0, bottom: 8),
      child: SingleChildScrollView(
        child: Container(
            padding: EdgeInsets.symmetric(vertical: 12),
            // height: 50.h,
            child: FutureBuilder(
              future: getSlotFuture(date2),
              builder: (_, snap){
                print("snap: $snap");
                if(snap.hasData){
                  if(snap.data.runtimeType == ErrorModel){
                    final model = snap.data as ErrorModel;

                    return Center(
                      child: Text(model.message ?? ''),
                    );
                  }
                  else if(snap.data.runtimeType == SlotModel){
                    final model = snap.data as SlotModel;
                    followUpSlots = model.data;
                    followUpSlots!.values!.forEach((e){
                      if(e.isBooked == "1"){
                        blockedSlot = e.slot!;
                      }
                    });
                    return Column(
                      mainAxisSize: MainAxisSize.min,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        SizedBox(
                          height: 6,
                        ),
                        Text(
                          'Please Select Slot',
                          style: TextStyle(
                              fontFamily: kFontMedium,
                              fontSize: 12.sp
                          ),
                        ),
                        Divider(),
                        Center(
                          child: Wrap(
                            alignment: WrapAlignment.start,
                            runAlignment: WrapAlignment.start,
                            children: [
                              ...followUpSlots!.values.map((e) => slotChip(e.slot!, '',isSelected: selectedSlot.contains(e.slot!), setstate: setState, isBlocked: blockedSlot.contains(e.slot!)))
                            ],
                          ),
                        ),
                        SizedBox(
                          height: 10,
                        ),
                        // Spacer(),
                        Center(
                          child: GestureDetector(
                            onTap: (){
                              submitFollowupSlots(date2, selectedSlot);
                            },
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
                        ),
                        SizedBox(
                          height: 10,
                        )
                      ],
                    );
                  }
                }
                return Center(child: buildCircularIndicator(),);
              },
            )
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

  slotChip(String time, String slotName,{bool isSelected = false, Function? setstate, bool isBlocked = false}){
    print("isBlocked:= $isBlocked");
    return GestureDetector(
      onTap: (){
        if(!isBlocked){
          setstate!(() {
            selectedSlot = time;
            // start = selectedSlot.split("-").first;
            // end = selectedSlot.split("-").last;
            //
            // print(start);
            // print(end);
            // if(slotName == "Evening"){
            //   selectedEveningSlot = time;
            // }
            // else{
            //   selectedMorningSlot = time;
            // }
          });
        }
      },
      child: Container(
        padding: EdgeInsets.symmetric(
            horizontal: 10,
            vertical: 10
        ),
        margin: EdgeInsets.symmetric(horizontal: 2, vertical: 3),
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(6),
            color:  (isBlocked) ? kLineColor : isSelected ? gsecondaryColor : gTapColor
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
                Icons.timelapse_rounded,
                size: 10,
                color: (isSelected || isBlocked) ? gWhiteColor : gBlackColor
            ),
            Text(time,
              style: TextStyle(
                  color: (isSelected || isBlocked) ? gWhiteColor : gBlackColor
              ),
            )
          ],
        ),
      ),
    );
  }

  submitFollowupSlots(String selectedDate, String slot) async{
    print(slot);
    String start = slot.split('-').first;
    String end = slot.split('-').last;
    print(start);
    final res = await GetUserScheduleSlotsForService(repository: repository).submitSlotSelectedService(selectedDate, start, end);
    Navigator.pop(context);
    if(res.runtimeType == ErrorModel){
      final result = res as ErrorModel;
      AppConfig().showSnackbar(context, result.message ?? '', isError: true);
    }
    else{
      final result = res as SuccessMessageModel;
      AppConfig().showSnackbar(context, result.errorMsg ?? '');
    }
    setState(() {
      selectedDate = "";
      selectedSlot = "";
    });

  }
}
