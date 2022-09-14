import 'dart:collection';
import 'dart:developer';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sizer/sizer.dart';
import '../../../model/new_user_model/choose_your_problem/child_choose_problem.dart';
import '../../../model/new_user_model/choose_your_problem/choose_your_problem_model.dart';
import '../../../repository/api_service.dart';
import '../../../repository/new_user_repository/choose_problem_repository.dart';
import '../../../services/new_user_service/choose_problem_service.dart';
import '../../../utils/app_config.dart';
import '../../../widgets/constants.dart';
import '../../../widgets/widgets.dart';
import 'about_the_program.dart';
import 'choose_problems_data.dart';

class ChooseYourProblemScreen extends StatefulWidget {
  const ChooseYourProblemScreen({Key? key}) : super(key: key);

  @override
  State<ChooseYourProblemScreen> createState() =>
      _ChooseYourProblemScreenState();
}

class _ChooseYourProblemScreenState extends State<ChooseYourProblemScreen> {

  List selectedProblems = [];
  late final Future myFuture;

  bool isLoading = false;

  String? deviceId;
  late ChooseProblemService _chooseProblemService;

  late SharedPreferences _prefs;

  @override
  void initState() {
    super.initState();

    // _chooseProblemService = Provider.of<ChooseProblemService>(context, listen: false);
    _chooseProblemService = ChooseProblemService(repository: repository);
    myFuture = getProblemList();
    getDeviceId();
  }

  getDeviceId() async{
    _prefs = await SharedPreferences.getInstance();
    await AppConfig().getDeviceId().then((id) {
      print("deviceId: $id");
      if(id != null){
        _prefs.setString(AppConfig().deviceId, id);
      }
      setState(() {
        deviceId = id;
      });
    });
  }

  getProblemList() async{
    return await _chooseProblemService.getProblems();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: Padding(
          padding:
              EdgeInsets.only(left: 4.w, right: 4.w, top: 2.h, bottom: 1.h),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              buildAppBar(() {
                Navigator.pop(context);
              }),
              SizedBox(
                height: 1.h,
              ),
              Text(
                "Choose Your Problem",
                textAlign: TextAlign.center,
                style: TextStyle(
                    fontFamily: "GothamRoundedBold_21016",
                    color: gPrimaryColor,
                    fontSize: 11.sp),
              ),
              SizedBox(
                height: 2.h,
              ),
              Expanded(
                child: buildChooseProblem(),
              ),
              Center(
                      child: GestureDetector(
                        onTap: () {
                          Navigator.of(context).push(
                            MaterialPageRoute(
                              builder: (context) => const AboutTheProgram(),
                            ),
                          );
                        },
                        child: Container(
                          padding: EdgeInsets.symmetric(
                              vertical: 1.h, horizontal: 15.w),
                          decoration: BoxDecoration(
                            color: selectedProblems.isEmpty ? gMainColor : gPrimaryColor,
                            borderRadius: BorderRadius.circular(8),
                            border: Border.all(color: gMainColor, width: 1),
                          ),
                          child: Text(
                            'Next',
                            style: TextStyle(
                              fontFamily: "GothamRoundedBold_21016",
                              color: selectedProblems.isEmpty ? gPrimaryColor : gWhiteColor,
                              fontSize: 11.sp,
                            ),
                          ),
                        ),
                      ),
                    ),
            ],
          ),
        ),
      ),
    );
  }

  buildChooseProblem() {
    return FutureBuilder(
        future: myFuture,
        builder: (_, snapshot){
          if(snapshot.hasData){
            log("getProblemList result: ${snapshot.data}");
            ChooseProblemModel model = snapshot.data as ChooseProblemModel;
            List<ChildChooseProblemModel>? problemList = model.data;
            return GridView.builder(
                scrollDirection: Axis.vertical,
                physics: const ScrollPhysics(),
                shrinkWrap: true,
                gridDelegate:
                const SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 3),
                itemCount: problemList?.length ?? 0,
                itemBuilder: (context, index) {
                  return InkWell(
                    onTap: () {
                      print("Problem: ${problemList?[index].name}");
                      buildChooseProblemOnClick(problemList![index]);
                    },
                    child: Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(5),
                        image: DecorationImage(
                            image: AssetImage("assets/images/Group 4855.png"),
                            fit: BoxFit.fill),
                      ),
                      child: Stack(
                        children: [
                          Center(
                            child: Column(
                              children: [
                                SizedBox(height: 2.h),
                                Image(
                                  height: 8.h,
                                  image: NetworkImage(problemList?[index].image ?? ''),
                                ),
                                SizedBox(height: 1.h),
                                Text(
                                  problemList?[index].name ?? '',
                                  style: TextStyle(
                                    fontFamily: "GothamMedium",
                                    color: gTextColor,
                                    fontSize: 9.sp,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          Positioned(
                            top: 10,
                            left: 10,
                            child: Visibility(
                              visible: selectedProblems.contains(problemList?[index].id),
                              child:  Align(
                                alignment: Alignment.topLeft,
                                child: Icon(
                                  Icons.check_circle,
                                  color: gsecondaryColor,
                                  size: 10.h,
                                ),
                              ),
                            ),
                          )
                        ],
                      ),
                    ),
                  );
                });
          }
          else if(snapshot.hasError){
            print("snap error: ${snapshot.error}");
            if(snapshot.error.toString().contains("SocketException")){
              return const SizedBox(
                width: double.infinity,
                child: Text("Problems Not Found"),
              );
            }

          }
          return buildCircularIndicator();
        }
    );
  }

  buildChooseProblemOnClick(ChildChooseProblemModel healthCheckBox){
    if(selectedProblems.contains(healthCheckBox.id)){
      setState(() {
        selectedProblems.remove(healthCheckBox.id);
      });
    }
    else{
      setState(() {
        selectedProblems.add(healthCheckBox.id);
      });
    }
  }


  final ChooseProblemRepository repository = ChooseProblemRepository(
    apiClient: ApiClient(
      httpClient: http.Client(),
    ),
  );
}
