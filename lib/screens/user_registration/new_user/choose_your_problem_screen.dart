import 'dart:collection';
import 'dart:developer';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sizer/sizer.dart';
import '../../../model/error_model.dart';
import '../../../model/new_user_model/choose_your_problem/child_choose_problem.dart';
import '../../../model/new_user_model/choose_your_problem/choose_your_problem_model.dart';
import '../../../model/new_user_model/choose_your_problem/submit_problem_response.dart';
import '../../../repository/api_service.dart';
import '../../../repository/new_user_repository/choose_problem_repository.dart';
import '../../../services/new_user_service/choose_problem_service.dart';
import '../../../utils/app_config.dart';
import '../../../widgets/constants.dart';
import '../../../widgets/widgets.dart';
import 'about_the_program.dart';
import 'choose_problems_data.dart';
import 'package:gwc_customer/widgets/dart_extensions.dart';

class ChooseYourProblemScreen extends StatefulWidget {
  const ChooseYourProblemScreen({Key? key}) : super(key: key);

  @override
  State<ChooseYourProblemScreen> createState() =>
      _ChooseYourProblemScreenState();
}

class _ChooseYourProblemScreenState extends State<ChooseYourProblemScreen> {

  List selectedProblems = [];
  Future? myFuture;

  bool isLoading = false;

  String? deviceId;
  ChooseProblemService? _chooseProblemService;

  SharedPreferences? _prefs;

  @override
  void setState(VoidCallback fn) {
    // TODO: implement setState
    if(mounted){
      super.setState(fn);
    }
  }
  @override
  void initState() {
    super.initState();

    // _chooseProblemService = Provider.of<ChooseProblemService>(context, listen: false);
    WidgetsBinding.instance!.addPostFrameCallback((timeStamp) {
      _chooseProblemService = ChooseProblemService(repository: repository);
      myFuture = getProblemList();
      getDeviceId();
    });
  }


  getDeviceId() async{
    _prefs = await SharedPreferences.getInstance();
    await AppConfig().getDeviceId().then((id) {
      print("deviceId: $id");
      if(id != null){
        _prefs!.setString(AppConfig().deviceId, id);
      }
      setState(() {
        deviceId = id;
      });
    });
  }


  getProblemList() async{
    return await _chooseProblemService!.getProblems();
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
                        onTap: selectedProblems.isEmpty ? () => AppConfig().showSnackbar(context, "Please Select your Problem") : () {
                          submitProblems();
                        },
                        child: Container(
                          width: 40.w,
                          height: 5.h,
                          // padding: EdgeInsets.symmetric(
                          //     vertical: 1.h, horizontal: 15.w),
                          decoration: BoxDecoration(
                            color: selectedProblems.isEmpty ? gMainColor : gPrimaryColor,
                            borderRadius: BorderRadius.circular(8),
                            border: Border.all(color: gMainColor, width: 1),
                          ),
                          child: (isLoading) ? buildThreeBounceIndicator()
                              : Center(
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
            if(snapshot.data.runtimeType == ChooseProblemModel){
              ChooseProblemModel model = snapshot.data as ChooseProblemModel;
              List<ChildChooseProblemModel>? problemList = model.data;
              return GridView.builder(
                  scrollDirection: Axis.vertical,
                  physics: const ScrollPhysics(),
                  shrinkWrap: true,
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 3, crossAxisSpacing: 6, mainAxisSpacing: 6),
                  // gridDelegate:SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 3),
                  itemCount: problemList?.length ?? 0,
                  itemBuilder: (context, index) {
                    return InkWell(
                      onTap: () {
                        print("Problem: ${problemList?[index].name}");
                        buildChooseProblemOnClick(problemList![index]);
                      },
                      child: Container(
                        margin: EdgeInsets.symmetric(horizontal: 2, vertical: 2),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(5),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.grey.withOpacity(0.3),
                              blurRadius: 5,
                              offset: const Offset(2, 5),
                            ),
                          ],
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
                                  SizedBox(height: 1.5.h),
                                  Text(
                                    problemList?[index].name.toString().capitalize() ?? '',
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
                                    color: gMainColor,
                                    size: 20,
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
            else{
              return const SizedBox(
                width: double.infinity,
                child: Text("Problems Not Found"),
              );
            }
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

  void submitProblems() async {
    setState(() {
      isLoading = true;
    });
    final res = await _chooseProblemService!.postProblems(selectedProblems, deviceId!);
    print(res);
    print(res.runtimeType);
    setState(() {
      isLoading = false;
    });
    if(res.runtimeType == SubmitProblemResponse){
      SubmitProblemResponse _submitResponse = res;
      print(_submitResponse);
      if(_submitResponse.status == "200"){
        print(_submitResponse.message);
        // AppConfig().showSnackbar(context, _submitResponse.message!);
        Navigator.of(context).push(
          MaterialPageRoute(
            builder: (context) => const AboutTheProgram(),
          ),
        );
      }
      else {
        print(_submitResponse.message);
        AppConfig().showSnackbar(context, _submitResponse.message!, isError: true);
        // Navigator.of(context).push(
        //   MaterialPageRoute(
        //     builder: (context) =>
        //     const GivenDetailsScreen(),
        //   ),
        // );
      }
    }
    else if(res.runtimeType == ErrorModel){
      ErrorModel response = res;
      AppConfig().showSnackbar(context, response.message!, isError: true);
    }

    // if(res){
    //   Navigator.of(context).push(
    //     MaterialPageRoute(
    //       builder: (context) =>
    //       const GivenDetailsScreen(),
    //     ),
    //   );
    // }
  }

}

