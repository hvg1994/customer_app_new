import 'package:flutter/material.dart';
import 'package:gwc_customer/model/error_model.dart';
import 'package:gwc_customer/model/prepratory_meal_model/prep_meal_model.dart';
import 'package:gwc_customer/repository/api_service.dart';
import 'package:gwc_customer/repository/prepratory_repository/prep_repository.dart';
import 'package:gwc_customer/screens/program_plans/meal_pdf.dart';
import 'package:gwc_customer/services/prepratory_service/prepratory_service.dart';
import 'package:gwc_customer/utils/app_config.dart';
import 'package:gwc_customer/widgets/constants.dart';
import 'package:gwc_customer/widgets/widgets.dart';
import 'package:http/http.dart' as http;
import 'package:sizer/sizer.dart';

class PrepratoryPlanScreen extends StatefulWidget {
  String totalDays;
  String dayNumber;
  PrepratoryPlanScreen({Key? key, required this.dayNumber, required this.totalDays}) : super(key: key);

  @override
  State<PrepratoryPlanScreen> createState() => _PrepratoryPlanScreenState();
}

class _PrepratoryPlanScreenState extends State<PrepratoryPlanScreen> {
  String? planNotePdfLink;

  late final prepratoryMealFuture;
  getPrepratoryMeals() {
    prepratoryMealFuture = PrepratoryMealService(repository: repository).getPrepratoryMealService();
  }

  String? totalDays;
  String? dayNumber;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    totalDays = widget.totalDays;
    dayNumber = widget.dayNumber;
    getPrepratoryMeals();
  }

  final PrepratoryRepository repository = PrepratoryRepository(
    apiClient: ApiClient(
      httpClient: http.Client(),
    ),
  );
  @override
  Widget build(BuildContext context) {
    return SafeArea(
        child: Scaffold(
          body: SingleChildScrollView(
            child: Container(
              padding: EdgeInsets.all(8),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  buildAppBar((){
                    Navigator.pop(context);
                  },
                  showHelpIcon: true,
                  helpOnTap: (){
                    if(planNotePdfLink != null || planNotePdfLink!.isNotEmpty){
                      Navigator.push(context, MaterialPageRoute(builder: (ctx)=>
                          MealPdf(pdfLink: planNotePdfLink! ,
                            heading: "Note",
                          )));
                    }
                    else{
                      AppConfig().showSnackbar(context, "Note Link Not available", isError: true);
                    }
                  }),
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 12),
                    child: Text('Day ${widget.dayNumber} Preparatory Meal Plan',
                      style: TextStyle(
                        fontFamily: eUser().mainHeadingFont,
                        color: eUser().mainHeadingColor,
                        fontSize: eUser().mainHeadingFontSize
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 5, horizontal: 5),
                    child: Text('${int.parse(widget.totalDays) - int.parse(widget.dayNumber)} days Remaining',
                      style: TextStyle(
                          fontFamily: kFontMedium,
                          color: gHintTextColor,
                          fontSize: 10.sp
                      ),
                    ),
                  ),
                  FutureBuilder(
                    future: prepratoryMealFuture,
                      builder: (_, snapshot){
                      if(snapshot.hasData){
                        if(snapshot.data.runtimeType == ErrorModel){
                          final res = snapshot.data as ErrorModel;
                          return Center(
                            child: Text(res.message ?? '',
                              style: TextStyle(
                                fontSize: 10.sp,
                                fontFamily: kFontMedium,
                              ),
                            ),
                          );
                        }
                        else{
                          PrepratoryMealModel res = snapshot.data as PrepratoryMealModel;
                          if(widget.totalDays.isEmpty) totalDays = res.days;
                          final dataList = res.data!.toJson();
                          planNotePdfLink = res.note;

                          return customMealPlanTile(dataList);
                          // lst.addAll(dataList.values.map((e) => MealSlot.fromJson(e)));
                          // return customMealPlanTile(key, lst);

                          // dataList.map((key, value) {
                          //   List<MealSlot> lst = [];
                          //   print("$key==$value");
                          //   value.forEach((e){
                          //     lst.add(MealSlot.fromJson(e));
                          //   });
                          //   return ;
                          // });
                          // return SizedBox();


                        }
                      }
                      else if(snapshot.hasError){
                        return Center(
                          child: Text(snapshot.error.toString() ?? '',
                            style: TextStyle(
                              fontSize: 10.sp,
                              fontFamily: kFontMedium,
                            ),
                          ),
                        );
                      }
                      return Center(child: buildCircularIndicator(),);
                      }
                  )
                ],
              ),
            ),
          ),
        )
    );
  }

  customMealPlanTile(Map<String, dynamic> dataList){
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 10),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ...dataList.entries.map((e) {
            print("${e.key}==${e.value}");
            print(e.value.runtimeType);
            List<MealSlot> lst = (e.value as List).map((e) => MealSlot.fromJson(e)).toList();
            // (e.value as List).forEach((element) {
            //   lst.add(MealSlot.fromJson(element));
            // });
            print(lst);
            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 8),
                  child: Text(e.key,
                    style: TextStyle(
                      height: 1.5,
                      color: gHintTextColor,
                      fontSize: 12.sp,
                      fontFamily: kFontMedium,
                        // fontSize: MealPlanConstants().mealNameFontSize,
                        // fontFamily: MealPlanConstants().mealNameFont
                    ),
                  ),
                ),
                ListView.separated(
                  physics: NeverScrollableScrollPhysics(),
                  shrinkWrap: true,
                  itemCount: lst.length,
                  itemBuilder: (_, index){
                    return GestureDetector(
                      onTap: (){
                        showPdf(lst[index].recipeUrl ?? ' ');
                      },
                      child: Container(
                        // color: Colors.red,
                        height: 95,
                        padding: EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Container(
                              height: 85,
                              width: 90,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(15),
                              ),
                              child: ClipRRect(
                                borderRadius: BorderRadius.circular(15),
                                child: (lst[index].itemPhoto == null) ? Image.asset('assets/images/meal_placeholder.png',
                                  fit: BoxFit.fill,
                                ) :
                                Image.network(lst[index].itemPhoto?? '',
                                  errorBuilder: (_, widget, child){
                                  return Image.asset('assets/images/meal_placeholder.png',
                                    fit: BoxFit.fill,
                                  );
                                  },
                                  fit: BoxFit.fill,
                                ),
                              ),
                            ),
                            SizedBox(
                              width: 8,
                            ),
                            Expanded(
                              child: Column(
                                // mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  SizedBox(
                                    height: 3,
                                  ),
                                  RichText(
                                    textScaleFactor: MediaQuery.of(context).textScaleFactor,
                                    text: TextSpan(
                                        text: lst[index].name,
                                        style: TextStyle(
                                            fontSize: MealPlanConstants().mealNameFontSize,
                                            fontFamily: MealPlanConstants().mealNameFont,
                                            color: gHintTextColor
                                        ),
                                        children:[
                                          TextSpan(
                                            text: (lst[index].subTitle == null) ? '' : '\t\t\t*${lst[index].subTitle}',
                                            style: TextStyle(
                                              fontSize: MealPlanConstants().mustHaveFontSize,
                                              fontFamily: MealPlanConstants().mustHaveFont,
                                              color: MealPlanConstants().mustHaveTextColor,
                                            ),
                                          )
                                        ]
                                    ),
                                  ),
                                  // Text(lst[index].name ?? 'Brahmari',
                                  //   style: TextStyle(
                                  //       fontSize: MealPlanConstants().mealNameFontSize,
                                  //       fontFamily: MealPlanConstants().mealNameFont
                                  //   ),
                                  // ),
                                  SizedBox(
                                    height: 8,
                                  ),
                                  Expanded(
                                    child: Text(lst[index].benefits!.replaceAll("-", '\n-') ??
                                        "- It Calms the nervous system.\n\n- It simulates the pituitary and pineal glands.",
                                      style: TextStyle(
                                          fontSize: MealPlanConstants().benifitsFontSize,
                                          fontFamily: MealPlanConstants().benifitsFont
                                      ),
                                    ),
                                  ),
                                  SizedBox(
                                    height: 4,
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                  separatorBuilder: (_, index){
                    // if(index.isEven){
                    return orFiled();
                    // }
                    // else return SizedBox();
                  },
                ),
              ],
            );
          })
        ],
      ),
    );
  }

  showPdf(String itemUrl) {
    print(itemUrl);
    String? url;
    if(itemUrl.contains('drive.google.com')){
      url = itemUrl;
      // url = 'https://drive.google.com/uc?export=view&id=1LV33e5XOl0YM8r6AqhU6B4oZniWwXcTZ';
      // String baseUrl = 'https://drive.google.com/uc?export=view&id=';
      // print(itemUrl.split('/')[5]);
      // url = baseUrl + itemUrl.split('/')[5];
    }
    else{
      url = itemUrl;
    }
    print(url);
    if(url.isNotEmpty) Navigator.push(context, MaterialPageRoute(builder: (ctx)=> MealPdf(pdfLink: url! ,)));
  }

  orFiled(){
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 8),
      child: Center(
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text('------------ ',
              style: TextStyle(
                fontFamily: kFontBold,
                color: gBlackColor
              ),
            ),
            Text('OR',
              style: TextStyle(
                  fontFamily: kFontBold,
                  color: gBlackColor
              ),
            ),
            Text(' ------------',
              style: TextStyle(
                  fontFamily: kFontBold,
                  color: gBlackColor
              ),
            ),
          ],
        ),
      ),
    );
  }
}
