import 'package:flutter/material.dart';
import 'package:gwc_customer/model/error_model.dart';
import 'package:gwc_customer/model/faq_model/faq_list_model.dart';
import 'package:gwc_customer/repository/api_service.dart';
import 'package:gwc_customer/repository/profile_repository/settings_repo.dart';
import 'package:gwc_customer/screens/profile_screens/faq_screens/faq_answers_screen.dart';
import 'package:gwc_customer/services/profile_screen_service/settings_service.dart';
import 'package:gwc_customer/widgets/unfocus_widget.dart';
import 'package:sizer/sizer.dart';
import 'package:http/http.dart' as http;
import '../../../widgets/constants.dart';
import '../../../widgets/widgets.dart';

class FaqScreen extends StatefulWidget {
  const FaqScreen({Key? key}) : super(key: key);

  @override
  State<FaqScreen> createState() => _FaqScreenState();
}

class _FaqScreenState extends State<FaqScreen> {
  final searchController = TextEditingController();
  //FAQs
  //
  // GENERAL QUERY
  //
  // 1. Can I skip a day and restart?
  // No, this will drastically reduce the efficacy.
  //
  // 2. Can the program be followed by a family member?
  // No, each program is customized based on your gut & hence will not work for another person.
  //
  // 3. Will I get a refund if i can't continue?
  // Once your program has been created we will not be able to issue a refund.

  // YOGA PLAN QUERY
  //
  // 1. Can I skip yoga?
  // Not at all, Yoga does 30% of the work in your program & is vital.
  //
  // 2. When should I do yoga?
  // Please follow your yoga modules as prescribed in your Diet & Yoga plans
  //
  // 3. I am not fit enough to do the yoga modules.
  // Get in touch with us & we’ll have it changed for you.

  // 1. Can I have ice cream/supplements/curd/egg/apple cider vinegar?
  // No, None. This will drastically reduce the efficacy.
  //
  // 2. Can I add flavoring to the meals?
  // Yes but only the ones prescribed in your plan. Honey is something you can add.
  //
  // 3. I am out the whole day today & will be unable to follow my plan, can I have something from
  // outside?
  // Only fruits, boiled vegetables, fruit juices & tender coconut water. No milk, No sugar.

  List<String> questions = [
    'Can I skip a day and restart?',
    'Can the program be followed by a family member?',
    "Will I get a refund if i can't continue?",
    'Can I have ice cream/supplements/curd/egg/apple cider vinegar?',
    'Can I add flavoring to the meals?',
    'I am out the whole day today & will be unable to follow my plan, can I have something from outside?',
    'Can I skip yoga?',
    'When should I do yoga?',
    'I am not fit enough to do the yoga modules.',
  ];
  List<String> paths = [
    'assets/images/faq/faq1.png',
    'assets/images/faq/faq2.png',
    'assets/images/faq/faq3.png',
    'assets/images/faq/faq4.png',
    'assets/images/faq/faq5.png',
    'assets/images/faq/faq6.png',
    'assets/images/faq/faq7.png',
    'assets/images/faq/faq8.png',
    'assets/images/faq/faq9.png',
  ];

  List<String> answers = [
    'No, this will drastically reduce the efficacy.',
    'No, each program is customized based on your gut & hence will not work for another person.',
    'Once your program has been created we will not be able to issue a refund.',
    'No, None. This will drastically reduce the efficacy.',
    'Yes but only the ones prescribed in your plan. Honey is something you can add.',
    'Only fruits, boiled vegetables, fruit juices & tender coconut water. No milk, No sugar.',
    'Not at all, Yoga does 30% of the work in your program & is vital.',
    'Please follow your yoga modules as prescribed in your Diet & Yoga plans',
    'Get in touch with us & we’ll have it changed for you.'
  ];
  List<FAQ> faq = [];
  List<FAQ> searchFAQResults = [];



  List<FaqList> fullFaq = [];
  List<FaqList> searchedFAQResults = [];

  Future? faqFuture;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    for (int i = 0; i < questions.length; i++) {
      faq.add(FAQ(questions[i], paths[i], answers[i]));
    }

    faqFuture = SettingsService(repository: repo).getFaqListService();
  }

  @override
  Widget build(BuildContext context) {
    return UnfocusWidget(
      child: SafeArea(
        child: Scaffold(
          body: Padding(
            padding: EdgeInsets.symmetric(vertical: 1.h, horizontal: 5.w),
            child: SingleChildScrollView(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  buildAppBar(() {
                    Navigator.pop(context);
                  }),
                  //SizedBox(height: 1.h),
                  Text(
                    "FAQ",
                    style: TextStyle(
                        fontFamily: "GothamBold",
                        color: gBlackColor,
                        fontSize: 13.sp),
                  ),
                  SizedBox(height: 1.h),
                  buildSearchWidget(),
                  buildExpansionTiles(),
                  //  newDesignUI(context)
                  // buildQuestions("Can I skip a day and restart?", 0),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  buildQuestionsOld(FAQ faq, int index) {
    return GestureDetector(
      onTap: () {
        // goto(faq);
      },
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            faq.questions,
            style: TextStyle(
              color: gTextColor,
              fontFamily: 'GothamMedium',
              fontSize: 9.sp,
            ),
          ),
          Container(
            margin: EdgeInsets.symmetric(vertical: 2.h),
            height: 1,
            color: Colors.grey.withOpacity(0.4),
          ),
          SizedBox(height: 1.5.h)
        ],
      ),
    );
  }

  buildExpansionTiles() {
    return FutureBuilder(
        future: faqFuture,
        builder: (_, snapshot) {
          print(snapshot.connectionState);
          if (snapshot.connectionState == ConnectionState.done) {
            print(snapshot.hasError);
            print(snapshot.hasData);
            if (snapshot.hasData) {
              print(snapshot.data.runtimeType);
              if (snapshot.data.runtimeType is ErrorModel) {
                ErrorModel model = snapshot.data as ErrorModel;
                return Center(
                  child: Text(model.message ?? ''),
                );
              } else {
                print("else");
                FaqListModel model = snapshot.data as FaqListModel;
                fullFaq.addAll(model.faqList!);
                return Column(
                  children: [
                    searchController.text.isNotEmpty
                        ? buildSearchList()
                        : SingleChildScrollView(
                      child: Column(
                        children: [
                          generalQueries(model),
                          mealPlanQueries(model),
                          yogaPlanQueries(model),
                          symptomQueries(model),
                        ],
                      ),
                    )
                  ],
                );
                model.faqList?.map((e) {
                  return buildQuestionsNew(e);
                }).toList();
              }
            } else if (snapshot.hasError) {
              return Center(
                child: Text(snapshot.error.toString() ?? ''),
              );
            }
          }
          return buildCircularIndicator();
        });
  }

  generalQueries(FaqListModel que) {
    return ExpansionTile(
      title: Text(
        "General Queries",
        style: TextStyle(
          color: Colors.black87,
          fontSize: 12.sp,
          fontFamily: "GothamMedium",
        ),
      ),
      // leading: Image(
      //   image: AssetImage("assets/images/Group 2747.png"),
      // ),
      children: [
        ListView.builder(
          physics: NeverScrollableScrollPhysics(),
            shrinkWrap: true,
            scrollDirection: Axis.vertical,
            itemCount: que.faqList?.length,
            itemBuilder: (_, index) {
              // print("Type: ${model.faqList![index].faqType}");
              if (que.faqList![index].faqType == "general") {
                return Padding(
                  padding: const EdgeInsets.only(left: 20),
                  child: buildMenuItem(
                    onClicked: () {
                      goto(que.faqList![index]);
                    },
                    text: "${que.faqList![index].question}",
                  ),
                );
              } else {
                return SizedBox();
              }
            }),
      ],
    );
  }

  mealPlanQueries(FaqListModel que) {
    return ExpansionTile(
      title: Text(
        "Meal Plan Queries",
        style: TextStyle(
          color: Colors.black87,
          fontSize: 12.sp,
          fontFamily: "GothamMedium",
        ),
      ),
      // leading: Image(
      //   image: AssetImage("assets/images/Group 2747.png"),
      // ),
      children: [
        ListView.builder(
            physics: NeverScrollableScrollPhysics(),
            shrinkWrap: true,
            scrollDirection: Axis.vertical,
            itemCount: que.faqList?.length,
            itemBuilder: (_, index) {
              // print("Type: ${model.faqList![index].faqType}");
              if (que.faqList![index].faqType == "meal") {
                return Padding(
                  padding: const EdgeInsets.only(left: 20),
                  child: buildMenuItem(
                    onClicked: () {
                      goto(que.faqList![index]);
                    },
                    text: "${que.faqList![index].question}",
                  ),
                );
              } else {
                return SizedBox();
              }
            }),
      ],
    );
  }

  yogaPlanQueries(FaqListModel que) {
    return ExpansionTile(
      title: Text(
        "Yoga Plan Queries",
        style: TextStyle(
          color: Colors.black87,
          fontSize: 12.sp,
          fontFamily: "GothamMedium",
        ),
      ),
      // leading: Image(
      //   image: AssetImage("assets/images/Group 2747.png"),
      // ),
      children: [
        ListView.builder(
            physics: NeverScrollableScrollPhysics(),
            shrinkWrap: true,
            scrollDirection: Axis.vertical,
            itemCount: que.faqList?.length,
            itemBuilder: (_, index) {
              // print("Type: ${model.faqList![index].faqType}");
              if (que.faqList![index].faqType == "yoga") {
                return Padding(
                  padding: const EdgeInsets.only(left: 20),
                  child: buildMenuItem(
                    onClicked: () {
                      goto(que.faqList![index]);
                    },
                    text: "${que.faqList![index].question}",
                  ),
                );
              } else {
                return SizedBox();
              }
            }),
      ],
    );
  }

  symptomQueries(FaqListModel que) {
    return ExpansionTile(
      title: Text(
        "Symptom Queries",
        style: TextStyle(
          color: Colors.black87,
          fontSize: 12.sp,
          fontFamily: "GothamMedium",
        ),
      ),
      // leading: Image(
      //   image: AssetImage("assets/images/Group 2747.png"),
      // ),
      children: [
        ListView.builder(
            physics: NeverScrollableScrollPhysics(),
            shrinkWrap: true,
            scrollDirection: Axis.vertical,
            itemCount: que.faqList?.length,
            itemBuilder: (_, index) {
              // print("Type: ${model.faqList![index].faqType}");
              if (que.faqList![index].faqType == "symptom") {
                return Padding(
                  padding: const EdgeInsets.only(left: 20),
                  child: buildMenuItem(
                    onClicked: () {
                      goto(que.faqList![index]);
                    },
                    text: "${que.faqList![index].question}",
                  ),
                );
              } else {
                return SizedBox();
              }
            }),
      ],
    );
  }

  buildSearchWidget() {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(6),
        color: Colors.white,
        // border: Border.all(color: gGreyColor.withOpacity(0.5), width: 1.0),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.3),
            blurRadius: 2,
          ),
        ],
      ),
      padding: EdgeInsets.symmetric(horizontal: 2.w),
      margin: EdgeInsets.symmetric(horizontal: 0.w, vertical: 1.h),
      child: TextFormField(
        textAlignVertical: TextAlignVertical.center,
        controller: searchController,
        textAlign: TextAlign.left,
        decoration: InputDecoration(
          prefixIcon: Icon(
            Icons.search,
            color: gBlackColor,
            size: 2.5.h,
          ),
          suffixIcon: GestureDetector(
            onTap: (){
              setState(() {
                searchController.clear();
                searchedFAQResults.clear();
              });
            },
            child: Icon(
              Icons.cancel_outlined,
              color: gBlackColor,
              size: 2.5.h,
            ),
          ),
          hintText: "Search...",
          // suffixIcon: searchController.text.isNotEmpty
          //     ? GestureDetector(
          //         child:
          //             Icon(Icons.close_outlined, size: 2.h, color: gBlackColor),
          //         onTap: () {
          //           searchController.clearComposing();
          //           FocusScope.of(context).requestFocus(FocusNode());
          //         },
          //       )
          //     : null,
          hintStyle: TextStyle(
            fontFamily: "GothamBook",
            color: gBlackColor,
            fontSize: 9.sp,
          ),
          border: InputBorder.none,
        ),
        style: TextStyle(
            fontFamily: "GothamBook", color: gBlackColor, fontSize: 11.sp),
        onChanged: (value) {
          onSearchTextChanged(value);
        },
      ),
    );
  }

  onSearchTextChanged(String text) async {
    searchFAQResults.clear();
    searchedFAQResults.clear();

    if (text.isEmpty) {
      setState(() {});
      return;
    }
    // faq?.forEach((userDetail) {
    //   if (userDetail.questions!
    //       .toLowerCase()
    //       .contains(text.trim().toLowerCase())) {
    //     searchFAQResults.add(userDetail);
    //   }
    // });

    if(fullFaq != null || fullFaq.isNotEmpty){

      for (var details in fullFaq) {
        print(details.question);
        print(text.trim());
        if(details.question!.toLowerCase().contains(text.trim().toLowerCase())){
          if(searchedFAQResults.isNotEmpty){
            if(!searchedFAQResults.contains(details)){
              searchedFAQResults.add(details);
            }
          }
          else{
            searchedFAQResults.add(details);
          }
        }
      }
    }
    setState(() {});
  }

  buildSearchList() {
    return SingleChildScrollView(
      child: Container(
        padding: EdgeInsets.symmetric(vertical: 2.h, horizontal: 2.w),
        decoration: BoxDecoration(
          color: gWhiteColor,
          borderRadius: BorderRadius.circular(10),
          boxShadow: [
            BoxShadow(
              blurRadius: 2,
              color: Colors.grey.withOpacity(0.5),
            ),
          ],
        ),
        child: Column(
          children: [
            ListView.builder(
              scrollDirection: Axis.vertical,
              padding: EdgeInsets.symmetric(horizontal: 1.w),
              physics: const ScrollPhysics(),
              shrinkWrap: true,
              itemCount: searchedFAQResults.length,
              itemBuilder: ((context, index) {
                return Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    GestureDetector(
                      onTap: () {
                       goto(searchedFAQResults[index]);
                      },
                      child: Text(
                        searchedFAQResults[index].question ?? "",
                        style: TextStyle(
                            fontFamily: "GothamBook",
                            color: gBlackColor,
                            fontSize: 10.sp),
                      ),
                    ),
                    Container(
                      height: 1,
                      margin: EdgeInsets.symmetric(vertical: 1.5.h),
                      color: Colors.grey.withOpacity(0.3),
                    ),
                  ],
                );
              }),
            ),
          ],
        ),
      ),
    );
  }

  Widget buildMenuItem({
    required String text,
    VoidCallback? onClicked,
  }) {
    const color = kPrimaryColor;
    const hoverColor = Colors.grey;

    return ListTile(
      title: Text(
        text,
        style: TextStyle(
          fontFamily: eUser().userTextFieldFont,
          color: eUser().userTextFieldColor,
          fontSize: eUser().userTextFieldFontSize,
        ),
      ),
      hoverColor: hoverColor,
      onTap: onClicked,
    );
  }

  goto(FaqList faq) {
    Navigator.push(
        context,
        MaterialPageRoute(
            builder: (_) => FaqAnswerScreen(
                  faqList: faq,
                  // question: faq.questions,
                  // icon: faq.path,
                  // answer: faq.answers
                )));
  }

  oldDesignUI(BuildContext context) {
    return faq.map((e) => buildQuestionsOld(e, faq.indexOf(e))).toList();
  }

  newDesignUI(BuildContext context) {
    return FutureBuilder(
        future: faqFuture,
        builder: (_, snapshot) {
          print(snapshot.connectionState);
          if (snapshot.connectionState == ConnectionState.done) {
            print(snapshot.hasError);
            print(snapshot.hasData);
            if (snapshot.hasData) {
              print(snapshot.data.runtimeType);
              if (snapshot.data.runtimeType is ErrorModel) {
                ErrorModel model = snapshot.data as ErrorModel;
                return Center(
                  child: Text(model.message ?? ''),
                );
              } else {
                print("else");
                FaqListModel model = snapshot.data as FaqListModel;
                return ListView.builder(
                    shrinkWrap: true,
                    itemCount: model.faqList?.length ?? 0,
                    itemBuilder: (_, index) {
                      return buildQuestionsNew(model.faqList![index]);
                    });
                model.faqList?.map((e) {
                  return buildQuestionsNew(e);
                }).toList();
              }
            } else if (snapshot.hasError) {
              return Center(
                child: Text(snapshot.error.toString() ?? ''),
              );
            }
          } else {
            return buildCircularIndicator();
          }
          return buildCircularIndicator();
        });
  }

  buildQuestionsNew(FaqList faq) {
    return GestureDetector(
      onTap: () {
        goto(faq);
      },
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            faq.question ?? '',
            style: TextStyle(
              color: gTextColor,
              fontFamily: 'GothamMedium',
              fontSize: 9.sp,
            ),
          ),
          Container(
            margin: EdgeInsets.symmetric(vertical: 2.h),
            height: 1,
            color: Colors.grey.withOpacity(0.4),
          ),
          SizedBox(height: 1.5.h)
        ],
      ),
    );
  }

  SettingsRepository repo =
      SettingsRepository(apiClient: ApiClient(httpClient: http.Client()));
}

class FAQ {
  String questions;
  String path;
  String answers;

  FAQ(this.questions, this.path, this.answers);
}
