 import 'dart:convert';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:gwc_customer/model/error_model.dart';
import 'package:gwc_customer/model/new_user_model/about_program_model/about_program_model.dart';
import 'package:gwc_customer/model/new_user_model/about_program_model/feedback_list_model.dart';
import 'package:gwc_customer/repository/api_service.dart';
import 'package:gwc_customer/repository/new_user_repository/about_program_repository.dart';
import 'package:gwc_customer/services/new_user_service/about_program_service.dart';
import 'package:gwc_customer/widgets/constants.dart';
import 'package:gwc_customer/widgets/widgets.dart';
import 'package:sizer/sizer.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';
class TestimonialListScreen extends StatefulWidget {
  const TestimonialListScreen({Key? key}) : super(key: key);

  @override
  State<TestimonialListScreen> createState() => _TestimonialListScreenState();

}

class _TestimonialListScreenState extends State<TestimonialListScreen> {

  List<TestimonilalDummy> dummyData = [
    TestimonilalDummy('Lorem Ipsum is simply dummy text of the print and typesetting industry. Lorem Ipsum '
  'has been the industry standard dummy text'
  'ever since the 1500s, when an unknown'
  'printer took a galley of type and scrambled it to make a type specimen book.'),
    TestimonilalDummy('Lorem Ipsum is simply dummy text of the print and typesetting industry.',
      image: 'http://dl.fujifilm-x.com/global/products/cameras/gfx100s/sample-images/gfx100s_sample_02_eibw.jpg?_ga=2.37751268.636017681.1669353692-1769152156.1669353692'
    ),
    TestimonilalDummy('Lorem Ipsum is simply dummy text of the print and typesetting industry. Lorem Ipsum '
        'has been the industry standard dummy text'
        'ever since the 1500s, when an unknown'
        'printer took a galley of type and scrambled it to make a type specimen book.'),
    TestimonilalDummy('Lorem Ipsum is simply dummy text of the print and typesetting industry.',
        image: 'http://dl.fujifilm-x.com/global/products/cameras/gfx100s/sample-images/gfx100s_sample_02_eibw.jpg?_ga=2.37751268.636017681.1669353692-1769152156.1669353692'
    ),
    TestimonilalDummy('Lorem Ipsum is simply dummy text of the print and typesetting industry. Lorem Ipsum '
        'has been the industry standard dummy text'
        'ever since the 1500s, when an unknown'
        'printer took a galley of type and scrambled it to make a type specimen book.'),
    TestimonilalDummy('Lorem Ipsum is simply dummy text of the print and typesetting industry.',
        image: 'http://dl.fujifilm-x.com/global/products/cameras/gfx100s/sample-images/gfx100s_sample_02_eibw.jpg?_ga=2.37751268.636017681.1669353692-1769152156.1669353692'
    ),

  ];

  late AboutProgramService _aboutProgramService;

  late Future _getTestimonialList;


  final AboutProgramRepository repository = AboutProgramRepository(
    apiClient: ApiClient(
      httpClient: http.Client(),
    ),
  );
  

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _aboutProgramService = AboutProgramService(repository: repository);
    getFuture();
  }
  getFuture(){
    _getTestimonialList =  _aboutProgramService.serverAboutProgramService();
  }
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            children: [
              buildAppBar(() => null,
                isBackEnable: false
              ),
              Expanded(
                child: newUI()
              )
            ],
          ),
        ),
      ),
    );
  }

  oldUI(){
    return ListView.builder(
        itemCount: dummyData.length,
        itemBuilder: (_, index){
          return showCardViews(feedback:dummyData[index].mainText, imagePath: dummyData[index].image);
        }
    );
  }
  newUI(){
    return FutureBuilder(
      future: _getTestimonialList,
        builder: (_, snapshot){
        if(snapshot.connectionState == ConnectionState.done){
          if(snapshot.hasData){
            if(snapshot.data.runtimeType == ErrorModel){
              var model = snapshot.data as ErrorModel;
              return Center(
                child: Text(model.message ?? '',
                  style: TextStyle(
                      fontFamily: 'GothamMedium',
                      fontSize: 10.sp
                  ),
                ),
              );
            }
            else{
              var model = snapshot.data as AboutProgramModel;
              List<FeedbackList> feedbackList = model.data?.feedbackList ?? [];
              if(feedbackList.isEmpty){
                return noData();
              }
              else{
                return ListView.builder(
                    itemCount: feedbackList.length,
                    itemBuilder: (_, index){
                      print("feedbackList[index].file: ${feedbackList[index].file.runtimeType}");
                      return showCardViews(
                        userProfile: feedbackList[index].addedBy?.profile ?? '',
                          feedbackTime: DateFormat('yyyy/MM/dd, hh:mm a').format(DateTime.parse(feedbackList[index].addedBy?.createdAt ?? '').toLocal()),
                          feedbackUser: feedbackList[index].addedBy?.name ?? '',
                          feedback: feedbackList[index].feedback,
                          imagePath: (feedbackList[index].file == null) ? null : feedbackList[index].file?.first
                      );
                    }
                );
              }
            }
          }
          else if(snapshot.hasError){
            return Center(
              child: Text(snapshot.error.toString(),
                style: TextStyle(
                  fontFamily: 'GothamMedium',
                  fontSize: 10.sp
                ),
              ),
            );
          }
        }
        return Center(child: buildCircularIndicator(),);
        }
    );
  }

  noData(){
    return const Center(
      child: Image(
        image: AssetImage("assets/images/no_data_found.png"),
        fit: BoxFit.scaleDown,
      ),
    );
  }

  showCardViews({String? userProfile, String? feedbackUser, String? feedbackTime, String? feedback, String? imagePath}){
    return Container(
      margin: EdgeInsets.symmetric(vertical: 7, horizontal: 5),
      padding: EdgeInsets.symmetric(horizontal: 5, vertical: 8),
      decoration: BoxDecoration(
        color: gWhiteColor,
        borderRadius: BorderRadius.circular(10),
        boxShadow: [
          BoxShadow(
            color: gGreyColor.withOpacity(0.35),
            // spreadRadius: 0.3,
            blurRadius: 5
          )
        ]
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ListTile(
            minVerticalPadding: 0,
            dense: true,
            minLeadingWidth: 30,
            leading: CircleAvatar(
              backgroundImage: CachedNetworkImageProvider(userProfile ?? ''),
              onBackgroundImageError: (obj, _){
                print(obj.toString());
              },
              maxRadius: 14.sp,
            ),
            title: Text(feedbackUser ??'',
              style: TextStyle(
                fontSize: 11.sp,
                fontFamily: 'GothamBold'
              ),
            ),
            subtitle: Text(feedbackTime ?? '',
              style: TextStyle(
                  fontSize: 9.5.sp,
                  fontFamily: 'GothamLight'
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8),
            child: Text(feedback ?? 'Lorem Ipsum is simply dummy text of the print and typesetting industry',
              style: TextStyle(
                  fontSize: 10.5.sp,
                  fontFamily: 'GothamMedium',
                height: 1.5
              ),
            ),
          ),
          Visibility(
            visible: imagePath != null,
            child: Center(
              child: Container(
                width: 70.w,
                height: 30.h,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(14),
                  image: DecorationImage(
                    image: CachedNetworkImageProvider(
                      imagePath ?? '',
                      errorListener: (){
                        Image.asset('assets/images/top-view-indian-food-assortment.png');
                      },
                      // placeholder: (_, __){
                      //   return Image.asset('assets/images/top-view-indian-food-assortment.png');
                      // },
                    )
                  )
                ),
                // child: Card(
                //   child: CachedNetworkImage(
                //     imageUrl: imagePath ?? '',
                //     placeholder: (_, __){
                //       return Image.asset('assets/images/top-view-indian-food-assortment.png');
                //     },
                //   ),
                // ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  loadAsset(String name)  {
    rootBundle.load('assets/images/$name').then((value) {
      if(value != null){
        return value.buffer.asUint8List();
      }
    });
  }


}

class TestimonilalDummy{
  String mainText;
  String? image;
  TestimonilalDummy(this.mainText, {this.image});
}