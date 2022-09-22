import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:gwc_customer/widgets/constants.dart';
import 'package:sizer/sizer.dart';
import 'package:http/http.dart' as http;
import '../../model/error_model.dart';
import '../../model/profile_model/user_profile/child_user_model.dart';
import '../../model/profile_model/user_profile/user_profile_model.dart';
import '../../repository/api_service.dart';
import '../../repository/profile_repository/get_user_profile_repo.dart';
import '../../services/profile_screen_service/user_profile_service.dart';
import '../../utils/app_config.dart';
import '../../widgets/widgets.dart';

class MyProfileDetails extends StatefulWidget {
  const MyProfileDetails({Key? key}) : super(key: key);

  @override
  State<MyProfileDetails> createState() => _MyProfileDetailsState();
}

class _MyProfileDetailsState extends State<MyProfileDetails> {

  TextEditingController nameController = TextEditingController();
  TextEditingController ageController = TextEditingController();
  TextEditingController genderController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  TextEditingController mobileController = TextEditingController();

  Future? getProfileDetails;

  bool isEdit = false;

  @override
  void setState(VoidCallback fn) {
    // TODO: implement setState
    if(mounted){
      super.setState(fn);
    }
  }
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getProfileData();
  }

  getProfileData(){
    getProfileDetails = UserProfileService(repository: repository).getUserProfileService();
  }


  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;
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
                  "My Profile",
                  textAlign: TextAlign.center,
                  style: TextStyle(
                      fontFamily: "GothamRoundedBold_21016",
                      color: gPrimaryColor,
                      fontSize: 12.sp),
                ),
                SizedBox(
                  height: height * 0.62,
                  child: FutureBuilder(
                    future: getProfileDetails,
                    builder: (_, snapshot){
                      if(snapshot.hasData){
                        if(snapshot.data.runtimeType == UserProfileModel){
                          UserProfileModel data = snapshot.data as UserProfileModel;
                          ChildUserModel? subData = data.data;
                          return LayoutBuilder(
                            builder: (context, constraints) {
                              return Stack(
                                fit: StackFit.expand,
                                children: [
                                  Positioned(
                                    bottom: 0,
                                    left: 0,
                                    right: 0,
                                    top: 11.h,
                                    child: Container(
                                      padding: EdgeInsets.symmetric(horizontal: 3.w),
                                      margin: EdgeInsets.symmetric(horizontal: 2.w),
                                      decoration: BoxDecoration(
                                        color: Colors.white,
                                        borderRadius: BorderRadius.circular(10),
                                        boxShadow: [
                                          BoxShadow(
                                            color: Colors.grey.withOpacity(0.3),
                                            blurRadius: 20,
                                            offset: const Offset(2, 10),
                                          ),
                                        ],
                                      ),
                                      child: SingleChildScrollView(
                                        child: Column(
                                          crossAxisAlignment: CrossAxisAlignment.start,
                                          children: [
                                            InkWell(
                                              onTap: () {
                                                toggleEdit();
                                                if(isEdit){
                                                  setState(() {
                                                    ChildUserModel data = subData!;
                                                    print("${data.name}, ${data.age}");
                                                    nameController.text = data.name!;
                                                    ageController.text = data.age!;
                                                    genderController.text = data.gender!;
                                                    emailController.text = data.email!;
                                                    mobileController.text = data.phone!;
                                                  });
                                                }
                                                // Navigator.of(context).push(
                                                //   MaterialPageRoute(
                                                //     builder: (context) =>
                                                //     const RegisterScreen(),
                                                //   ),
                                                // );
                                              },
                                              child: Padding(
                                                padding: EdgeInsets.only(top: 2.h, right: 3.w),
                                                child: Align(
                                                  alignment: Alignment.topRight,
                                                  child: SvgPicture.asset(
                                                    "assets/images/Icon feather-edit.svg",
                                                    color: Colors.grey,
                                                    fit: BoxFit.contain,
                                                  ),
                                                ),
                                              ),
                                            ),
                                            SizedBox(
                                              height: 4.h,
                                            ),
                                            profileTile("Name: ", subData?.name ?? "Gut-Wellness Club", controller: nameController),
                                            Container(
                                              height: 1,
                                              color: Colors.grey,
                                            ),
                                            profileTile("Age: ", subData?.age ?? '', controller: ageController),
                                            Container(
                                              height: 1,
                                              color: Colors.grey,
                                            ),
                                            profileTile("Gender: ", subData?.gender ?? "", controller: genderController),
                                            Container(
                                              height: 1,
                                              color: Colors.grey,
                                            ),
                                            profileTile(
                                                "Email: ", subData?.email ?? '', controller: emailController),
                                            Container(
                                              height: 1,
                                              color: Colors.grey,
                                            ),
                                            profileTile("Mobile Number: ", subData?.phone ?? '', controller: mobileController),
                                            Container(
                                              height: 1,
                                              color: Colors.grey,
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                                  ),
                                  Positioned(
                                    top: 5.h,
                                    left: 0,
                                    right: 0,
                                    child: Center(
                                      child: (subData?.profile == null) ?
                                      CircleAvatar(
                                        radius: 6.h,
                                        backgroundColor: Colors.black45,
                                        backgroundImage: const AssetImage(
                                            "assets/images/cheerful.png"),
                                      )
                                          : CircleAvatar(
                                        radius: 6.h,
                                        backgroundColor: Colors.black45,
                                        backgroundImage: NetworkImage(
                                            subData!.profile!
                                        ),
                                      ),
                                    ),
                                  ),
                                ],
                              );
                            },
                          );
                        }
                        else{
                          ErrorModel data = snapshot.data as ErrorModel;
                          AppConfig().showSnackbar(context, data.message ?? 'Unauthenticated', isError: true);
                          errorDisplayLayout();
                        }
                      }
                      else if(snapshot.hasError){
                        AppConfig().showSnackbar(context, snapshot.error.toString(), isError: true);
                        errorDisplayLayout();
                      }
                      return buildCircularIndicator();
                    },
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  profileTile(String title, String subTitle, {TextEditingController? controller}) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 3.h, horizontal: 3.w),
      child: Row(
        // mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            title,
            style: TextStyle(
              color: gTextColor,
              fontFamily: 'GothamBold',
              fontSize: 11.sp,
            ),
          ),
          (isEdit) ? Expanded(
            child: TextField(
              controller: controller,
              readOnly: !isEdit,
              decoration: InputDecoration(
                contentPadding: EdgeInsets.all(0.0),
                isDense: true,
                // border: InputBorde,
              ),
              minLines: 1,
              maxLines: 1,
              // onSaved: (String value) {
              //   // This optional block of code can be used to run
              //   // code when the user saves the form.
              // },
              // validator: (value) {
              //   if(value!.isEmpty){
              //     return 'Name filed can\'t be empty';
              //   }
              // },
            ),
          ) :
          Text(
            subTitle,
            style: TextStyle(
              color: gTextColor,
              fontFamily: 'GothamMedium',
              fontSize: 10.sp,
            ),
          ),

        ],
      ),
    );
  }

  errorDisplayLayout() {
    return LayoutBuilder(
      builder: (context, constraints) {
        return Stack(
          fit: StackFit.expand,
          children: [
            Positioned(
              bottom: 0,
              left: 0,
              right: 0,
              top: 11.h,
              child: Container(
                padding: EdgeInsets.symmetric(horizontal: 3.w),
                margin: EdgeInsets.symmetric(horizontal: 2.w),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(10),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.grey.withOpacity(0.3),
                      blurRadius: 20,
                      offset: const Offset(2, 10),
                    ),
                  ],
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    InkWell(
                      onTap: () {
                        // Navigator.of(context).push(
                        //   MaterialPageRoute(
                        //     builder: (context) =>
                        //     const RegisterScreen(),
                        //   ),
                        // );
                      },
                      child: Padding(
                        padding:
                        EdgeInsets.only(top: 2.h, right: 3.w),
                        child: Align(
                          alignment: Alignment.topRight,
                          child: SvgPicture.asset(
                            "assets/images/Icon feather-edit.svg",
                            color: Colors.grey,
                            fit: BoxFit.contain,
                          ),
                        ),
                      ),
                    ),
                    SizedBox(
                      height: 4.h,
                    ),
                    profileTile("Name: ", ""),
                    Container(
                      height: 1,
                      color: Colors.grey,
                    ),
                    profileTile("Age: ", ""),
                    Container(
                      height: 1,
                      color: Colors.grey,
                    ),
                    profileTile("Gender: ", ""),
                    Container(
                      height: 1,
                      color: Colors.grey,
                    ),
                    profileTile(
                        "Email: ", ""),
                    Container(
                      height: 1,
                      color: Colors.grey,
                    ),
                    profileTile("Mobile Number: ", ""),
                    Container(
                      height: 1,
                      color: Colors.grey,
                    ),
                  ],
                ),
              ),
            ),
            Positioned(
              top: 5.h,
              left: 0,
              right: 0,
              child: Center(
                child: CircleAvatar(
                  backgroundColor: Colors.transparent,
                  child: const Icon(
                      Icons.account_circle
                  ),
                  radius: 6.h,
                ),
              ),
            ),
          ],
        );
      },
    );
  }

  final UserProfileRepository repository = UserProfileRepository(
    apiClient: ApiClient(
      httpClient: http.Client(),
    ),
  );


  toggleEdit() {
    setState(() {
      if(isEdit){
        isEdit = false;
      }
      else{
        isEdit = true;
      }
    });
  }

}
