import 'package:flutter/material.dart';
import 'package:gwc_customer/model/error_model.dart';
import 'package:gwc_customer/model/faq_model/faq_list_model.dart';
import 'package:gwc_customer/repository/api_service.dart';
import 'package:gwc_customer/repository/profile_repository/settings_repo.dart';
import 'package:gwc_customer/screens/profile_screens/faq_screens/faq_answers_screen.dart';
import 'package:gwc_customer/services/profile_screen_service/settings_service.dart';
import 'package:sizer/sizer.dart';
import 'package:http/http.dart' as http;
import '../../../widgets/constants.dart';
import '../../../widgets/widgets.dart';

class FaqScreenOld extends StatefulWidget {
  const FaqScreenOld({Key? key}) : super(key: key);

  @override
  State<FaqScreenOld> createState() => _FaqScreenOldState();
}

class _FaqScreenOldState extends State<FaqScreenOld> {

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

  Future? faqFuture;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    for(int i = 0; i<questions.length; i++){
      faq.add(FAQ(questions[i], paths[i], answers[i]));
    }

    faqFuture = SettingsService(repository: repo).getFaqListService();
  }
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: SingleChildScrollView(
          physics: const BouncingScrollPhysics(),
          child: Padding(
            padding: EdgeInsets.symmetric(vertical: 1.h, horizontal: 5.w),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                buildAppBar(() {
                  Navigator.pop(context);
                }),
                SizedBox(height: 3.h),
                Text(
                  "FAQ",
                  textAlign: TextAlign.center,
                  style: TextStyle(
                      fontFamily: "GothamRoundedBold_21016",
                      color: gPrimaryColor,
                      fontSize: 13.sp),
                ),
                SizedBox(
                  height: 3.h,
                ),
                newDesignUI(context)
                // buildQuestions("Can I skip a day and restart?", 0),
              ],
            ),
          ),
        ),
      ),
    );
  }

  buildQuestionsOld(FAQ faq, int index) {
    return GestureDetector(
      onTap: (){
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

  goto(FaqList faq){
    Navigator.push(context, MaterialPageRoute(builder: (_) =>
        FaqAnswerScreen(
          faqList: faq,
            // question: faq.questions,
            // icon: faq.path,
            // answer: faq.answers
        )));
  }

  oldDesignUI(BuildContext context){
    return faq.map((e) => buildQuestionsOld(e, faq.indexOf(e))).toList();
  }

  newDesignUI(BuildContext context){
    return FutureBuilder(
      future: faqFuture,
        builder: (_, snapshot){
        print(snapshot.connectionState);
          if(snapshot.connectionState == ConnectionState.done){
            print(snapshot.hasError);
            print(snapshot.hasData);
            if(snapshot.hasData){
              print(snapshot.data.runtimeType);
              if(snapshot.data.runtimeType is ErrorModel){
                ErrorModel model = snapshot.data as ErrorModel;
                return Center(
                  child: Text(model.message ?? ''),
                );
              }
              else{
                print("else");
                FaqListModel model = snapshot.data as FaqListModel;
                return ListView.builder(
                  shrinkWrap: true,
                  itemCount: model.faqList?.length ?? 0,
                    itemBuilder: (_, index){
                      return buildQuestionsNew(model.faqList![index]);
                    }
                );
                model.faqList?.map((e) {
                  return buildQuestionsNew(e);
                }).toList();
              }

            }
            else if(snapshot.hasError){
              return Center(
                child: Text(snapshot.error.toString() ?? ''),
              );
            }
          }
          else {
            return buildCircularIndicator();
          }
          return buildCircularIndicator();
        }
    );
  }

  buildQuestionsNew(FaqList faq) {
    return GestureDetector(
      onTap: (){
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


  SettingsRepository repo = SettingsRepository(
      apiClient: ApiClient(
        httpClient: http.Client()
      )
  );
}


class FAQ{
  String questions;
  String path;
  String answers;
  FAQ(this.questions,  this.path,  this.answers);
}