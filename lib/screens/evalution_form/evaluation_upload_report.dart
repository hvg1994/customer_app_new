import 'dart:io';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_vlc_player/flutter_vlc_player.dart';
import 'package:gwc_customer/model/error_model.dart';
import 'package:gwc_customer/model/evaluation_from_models/evaluation_model_format1.dart';
import 'package:gwc_customer/model/new_user_model/about_program_model/about_program_model.dart';
import 'package:gwc_customer/repository/api_service.dart';
import 'package:gwc_customer/repository/new_user_repository/about_program_repository.dart';
import 'package:gwc_customer/screens/evalution_form/personal_details_screen2.dart';
import 'package:gwc_customer/services/new_user_service/about_program_service.dart';
import 'package:gwc_customer/utils/app_config.dart';
import 'package:gwc_customer/widgets/constants.dart';
import 'package:gwc_customer/widgets/vlc_player/vlc_player_with_controls.dart';
import 'package:gwc_customer/widgets/widgets.dart';
import 'package:sizer/sizer.dart';
import 'package:appinio_video_player/appinio_video_player.dart';
import 'package:wakelock/wakelock.dart';
import 'package:http/http.dart' as http;



class EvaluationUploadReport extends StatefulWidget {
  final EvaluationModelFormat1 evaluationModelFormat1;
  const EvaluationUploadReport({Key? key, required this.evaluationModelFormat1}) : super(key: key);

  @override
  State<EvaluationUploadReport> createState() => _EvaluationUploadReportState();
}

class _EvaluationUploadReportState extends State<EvaluationUploadReport> {
  dynamic padding = EdgeInsets.symmetric(vertical: 1.h, horizontal: 5.w);

  List<PlatformFile> medicalRecords = [];


  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getVideoUrl();
  }


  @override
  void dispose(){
    disposePlayer();
    super.dispose();
  }




  getVideoUrl() async{
    final res = await AboutProgramService(repository: repository).serverAboutProgramService();

    if(res.runtimeType == ErrorModel){
      final msg = res as ErrorModel;
      Future.delayed(Duration.zero).whenComplete(() {
        AppConfig().showSnackbar(context, msg.message ?? '', isError: true);
      });
    }
    else{
      final result = res as AboutProgramModel;
      if(result.uploadReportVideo != null && result.uploadReportVideo!.isNotEmpty){
        addUrlToVideoPlayer(result.uploadReportVideo ?? '');
      }
      else{
        Future.delayed(Duration.zero).whenComplete(() {
          AppConfig().showSnackbar(context, AppConfig.oopsMessage, isError: true);
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        image: DecorationImage(
            image: const AssetImage("assets/images/eval_bg.png"),
            fit: BoxFit.fitWidth,
            colorFilter: ColorFilter.mode(kPrimaryColor, BlendMode.lighten)),
      ),
      child: SafeArea(
        child: Scaffold(
          backgroundColor: Colors.transparent,
          body: showUI(context),
        ),
      ),
    );
  }

  showUI(BuildContext context) {
    return Column(
      children: [
        SizedBox(height: 1.h),
        Padding(
          padding: EdgeInsets.only(left: 4.w, right: 4.w, top: 3.h),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              buildAppBar(() {
                Navigator.pop(context);
              }),
              SizedBox(
                width: 3.w,
              ),
              // FittedBox(
              //   child: Text(
              //     "Gut Wellness Club \nEvaluation Form",
              //     textAlign: TextAlign.start,
              //     style: TextStyle(
              //         fontFamily: "PoppinsMedium",
              //         color: Colors.white,
              //         fontSize: 12.sp),
              //   ),
              // ),
            ],
          ),
        ),
        SizedBox(
          height: 4.h,
        ),
        Expanded(
          child: Container(
              width: double.maxFinite,
              padding:
              EdgeInsets.symmetric(horizontal: 3.w, vertical: 3.h),
              decoration: BoxDecoration(
                color: Colors.white,
                boxShadow: [
                  BoxShadow(
                      blurRadius: 2, color: Colors.grey.withOpacity(0.5))
                ],
                borderRadius: const BorderRadius.only(
                  topLeft: Radius.circular(30),
                  topRight: Radius.circular(30),
                ),
              ),
              child: buildUI(context)
          ),
        ),
      ],
    );
  }

  buildUI(BuildContext context){
    return SingleChildScrollView(
      child: Column(
        mainAxisSize: MainAxisSize.max,
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Text(
            "Upload your reports here",
            textAlign: TextAlign.center,
            style: TextStyle(
                fontFamily: eUser().mainHeadingFont,
                color: eUser().mainHeadingColor,
                fontSize: eUser().mainHeadingFontSize
            ),
          ),
          SizedBox(
            height: 1.h,
          ),
          buildVideoPlayer(),
          SizedBox(height: 2.h),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 5.w),
            child: Text(
              "Your prior medical reports help us analyse the root cause & contributing factor. Do upload all possible reports",
              textAlign: TextAlign.center,
              style: TextStyle(
                  height: 1.5,
                  fontFamily: kFontBold,
                  color: gTextColor,
                  fontSize: 10.sp),
            ),
          ),
          // upload button
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 5.w),
            child: GestureDetector(
              onTap: () async {
                final result = await FilePicker.platform
                    .pickFiles(withReadStream: true, allowMultiple: false);

                if (result == null) return;
                if (result.files.first.extension!.contains("pdf") ||
                    result.files.first.extension!.contains("png") ||
                    result.files.first.extension!.contains("jpg")) {
                  medicalRecords.add(result.files.first);
                } else {
                  AppConfig().showSnackbar(
                      context, "Please select png/jpg/Pdf files",
                      isError: true);
                }
                setState(() {});
              },
              child: Container(
                margin: EdgeInsets.symmetric(
                    vertical: 3.h, horizontal: 3.w),
                padding: EdgeInsets.symmetric(vertical: 2.h),
                decoration: BoxDecoration(
                  color: gMainColor,
                  borderRadius: BorderRadius.circular(5),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.grey.withOpacity(0.5),
                      blurRadius: 20,
                      offset: const Offset(2, 10),
                    ),
                  ],
                ),
                child: Center(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Image(
                        image: const AssetImage(
                            "assets/images/Group 3323.png"),
                        height: 2.5.h,
                      ),
                      Text(
                        "   Choose file",
                        style: TextStyle(
                            fontFamily: "GothamMedium",
                            color: Colors.black,
                            fontSize: 10.sp),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
          SizedBox(
            height: 0.5.h,
          ),
          if(medicalRecords.isNotEmpty)
            SizedBox(
              width: double.maxFinite,
              child: ListView.builder(
                physics: NeverScrollableScrollPhysics(),
                itemCount: medicalRecords.length,
                shrinkWrap: true,
                itemBuilder: (context, index) {
                  final file = medicalRecords[index];
                  return buildFile(file, index);
                },
              ),
            ),
          SizedBox(
            height: 5.h,
          ),
          //submit button
          Visibility(
            visible: medicalRecords.isNotEmpty,
            child: Padding(
              padding: padding,
              child: Center(
                child: GestureDetector(
                  onTap: () async {
                    // final res = await _videoPlayerController?.isPlaying();
                    // if(res != null && res == true){
                    //
                    // }
                    if(medicalRecords.isNotEmpty){
                      showUploadReportPopup();

                      if(_videoPlayerController != null){
                        _videoPlayerController!.stop();
                      }
                      // Navigator.push(
                      //     context,
                      //     MaterialPageRoute(
                      //         builder: (ctx) => PersonalDetailsScreen2(
                      //             evaluationModelFormat1: widget.evaluationModelFormat1,
                      //             medicalReportList:
                      //             medicalRecords.map((e) => e.path).toList())
                      //     ));
                    }
                  },
                  child: Container(
                    width: 40.w,
                    height: 5.h,
                    margin: EdgeInsets.symmetric(vertical: 4.h),
                    padding:
                    EdgeInsets.symmetric(vertical: 1.h, horizontal: 10.w),
                    decoration: BoxDecoration(
                      color: eUser().buttonColor,
                      borderRadius: BorderRadius.circular(eUser().buttonBorderRadius),
                      // border: Border.all(
                      //     color: eUser().buttonBorderColor,
                      //     width: eUser().buttonBorderWidth
                      // ),
                    ),
                    child: (showUploadProgress)
                        ? buildThreeBounceIndicator()
                        : Center(
                      child: Text(
                        'Done',
                        style: TextStyle(
                          fontFamily: eUser().buttonTextFont,
                          color: eUser().buttonTextColor,
                          fontSize: eUser().buttonTextSize,
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ),
          Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Center(
                child: Text("Don't have any reports?",
                  style: TextStyle(
                    fontFamily: kFontBook,
                    color: gHintTextColor,
                  ),
                ),
              ),
              MediaQuery(
                data: MediaQuery.of(context).copyWith(textScaleFactor: 0.8),
                child: Center(child:  GestureDetector(
                    onTap: (){
                      if(_videoPlayerController != null){
                        _videoPlayerController!.stop();
                      }
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (ctx) => PersonalDetailsScreen2(
                                  evaluationModelFormat1: widget.evaluationModelFormat1,
                                  medicalReportList: null)
                          ));
                    },
                    child: Container(
                      width: 30.w,
                      height: 4.h,
                      margin: EdgeInsets.symmetric(vertical: 2.h),
                      padding: EdgeInsets.symmetric(vertical: 1.h, horizontal: 10.w),
                      decoration: BoxDecoration(
                        color: eUser().buttonColor,
                        borderRadius: BorderRadius.circular(eUser().buttonBorderRadius),
                        // border: Border.all(
                        //     color: eUser().buttonBorderColor,
                        //     width: eUser().buttonBorderWidth
                        // ),
                      ),
                      child: Center(
                        child: Text(
                          'Skip',
                          style: TextStyle(
                            fontFamily: eUser().buttonTextFont,
                            color: eUser().buttonTextColor,
                            fontSize: eUser().buttonTextSize,
                          ),
                        ),
                      ),
                    )
                ),),
              ),
            ],
          ),
        ],
      ),
    );
  }


  uiLikeUpload(){
    return Container(
      decoration: const BoxDecoration(
        gradient: LinearGradient(
            colors: [Color(0xffFFE889), Color(0xffFFF3C2)],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter),
      ),
      child: Scaffold(
        backgroundColor: Colors.transparent,
        body: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.max,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Padding(
                padding: padding,
                child: Align(
                  alignment: Alignment.topLeft,
                  child: buildAppBar(() {
                    Navigator.pop(context);
                  }),
                ),
              ),
              SizedBox(height: 5.h),
              Text(
                "User Reports",
                textAlign: TextAlign.center,
                style: TextStyle(
                    fontFamily: eUser().mainHeadingFont,
                    color: eUser().mainHeadingColor,
                    fontSize: eUser().mainHeadingFontSize
                ),
              ),
              SizedBox(
                height: 2.h,
              ),
              buildVideoPlayer(),
              SizedBox(height: 2.h),
              Padding(
                padding: padding,
                child: Text(
                  "Please Upload Any & All Medical Records That Might Be Helpful To Evaluate Your Condition Better",
                  textAlign: TextAlign.center,
                  style: TextStyle(
                      height: 1.5,
                      fontFamily: kFontBold,
                      color: gTextColor,
                      fontSize: 12.sp),
                ),
              ),
              // upload button
              Padding(
                padding: padding,
                child: GestureDetector(
                  onTap: () async {
                    final result = await FilePicker.platform
                        .pickFiles(withReadStream: true, allowMultiple: false);

                    if (result == null) return;
                    if (result.files.first.extension!.contains("pdf") ||
                        result.files.first.extension!.contains("png") ||
                        result.files.first.extension!.contains("jpg")) {
                      medicalRecords.add(result.files.first);
                    } else {
                      AppConfig().showSnackbar(
                          context, "Please select png/jpg/Pdf files",
                          isError: true);
                    }
                    setState(() {});
                  },
                  child: Container(
                    margin: EdgeInsets.symmetric(
                        vertical: 5.h, horizontal: 3.w),
                    padding: EdgeInsets.symmetric(vertical: 2.h),
                    decoration: BoxDecoration(
                      color: gMainColor,
                      borderRadius: BorderRadius.circular(5),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.grey.withOpacity(0.5),
                          blurRadius: 20,
                          offset: const Offset(2, 10),
                        ),
                      ],
                    ),
                    child: Center(
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Image(
                            image: const AssetImage(
                                "assets/images/Group 3323.png"),
                            height: 2.5.h,
                          ),
                          Text(
                            "   Choose file",
                            style: TextStyle(
                                fontFamily: "GothamMedium",
                                color: Colors.black,
                                fontSize: 10.sp),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
              SizedBox(
                height: 1.8.h,
              ),
              if(medicalRecords.isNotEmpty)
                SizedBox(
                  width: double.maxFinite,
                  child: ListView.builder(
                    itemCount: medicalRecords.length,
                    shrinkWrap: true,
                    itemBuilder: (context, index) {
                      final file = medicalRecords[index];
                      return buildFile(file, index);
                    },
                  ),
                ),
              SizedBox(
                height: 5.h,
              ),
              //submit button
              Padding(
                padding: padding,
                child: Center(
                  child: GestureDetector(
                    onTap: () async {
                      if(medicalRecords.isNotEmpty){
                        if(_videoPlayerController != null){
                          _videoPlayerController!.stop();
                        }
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (ctx) => PersonalDetailsScreen2(
                                    evaluationModelFormat1: widget.evaluationModelFormat1,
                                    medicalReportList:
                                    medicalRecords.map((e) => e.path).toList())
                            ));
                      }
                    },
                    child: Container(
                      width: 60.w,
                      height: 5.h,
                      // padding: EdgeInsets.symmetric(vertical: 1.h, horizontal: 10.w),
                      decoration: BoxDecoration(
                        color: gPrimaryColor,
                        borderRadius: BorderRadius.circular(8),
                        border:
                        Border.all(color: gMainColor, width: 1),
                      ),
                      child: (showUploadProgress)
                          ? buildThreeBounceIndicator()
                          : Center(
                        child: Text(
                          'Submit',
                          style: TextStyle(
                            fontFamily:
                            kFontMedium,
                            color: gWhiteColor,
                            fontSize: 11.sp,
                          ),
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
  Widget buildFile(PlatformFile file, int index) {
    final kb = file.size / 1024;
    final mb = kb / 1024;
    final size = (mb >= 1)
        ? '${mb.toStringAsFixed(2)} MB'
        : '${kb.toStringAsFixed(2)} KB';
    return buildRecordList(file, index: index);

    // return Wrap(
    //   children: [
    //     RawChip(
    //         label: Text(file.name),
    //       deleteIcon: Icon(
    //         Icons.cancel,
    //       ),
    //       deleteIconColor: gMainColor,
    //       onDeleted: (){
    //         medicalRecords.removeAt(index);
    //         setState(() {});
    //       },
    //     )
    //   ],
    // );
  }

  buildRecordList(PlatformFile filename, {int? index}) {
    return ListTile(
      shape: Border(
        bottom: BorderSide()
      ),
      leading: SizedBox(
          width: 50,
          height: 50,
          child: Image.file(File(filename.path!))
      ),
      title: Text(
        filename.name.split("/").last,
        textAlign: TextAlign.start,
        maxLines: 2,
        overflow: TextOverflow.ellipsis,
        style: TextStyle(
          fontFamily: kFontBold,
          fontSize: 11.sp,
        ),
      ),
      trailing: GestureDetector(
          onTap: () {
            medicalRecords.removeAt(index!);
            setState(() {});
          },
          child: const Icon(
            Icons.delete_outline_outlined,
            color: gMainColor,
          )),
    );
    // return Padding(
    //   padding: EdgeInsets.symmetric(vertical: 1.5.h),
    //   child: OutlinedButton(
    //     onPressed: () {},
    //     style: ButtonStyle(
    //       overlayColor: getColor(Colors.white, const Color(0xffCBFE86)),
    //       backgroundColor: getColor(Colors.white, const Color(0xffCBFE86)),
    //     ),
    //     child: Row(
    //       children: [
    //         Expanded(
    //           child: Text(
    //             filename.split("/").last,
    //             textAlign: TextAlign.start,
    //             maxLines: 2,
    //             overflow: TextOverflow.ellipsis,
    //             style: TextStyle(
    //               fontFamily: "PoppinsBold",
    //               fontSize: 11.sp,
    //             ),
    //           ),
    //         ),
    //         (widget.showData)
    //             ? SvgPicture.asset(
    //           'assets/images/attach_icon.svg',
    //           fit: BoxFit.cover,
    //         )
    //             : GestureDetector(
    //             onTap: () {
    //               medicalRecords.removeAt(index!);
    //               setState(() {});
    //             },
    //             child: const Icon(
    //               Icons.delete_outline_outlined,
    //               color: gMainColor,
    //             )),
    //       ],
    //     ),
    //   ),
    // );
  }

  VlcPlayerController? _videoPlayerController;
  final _key = GlobalKey<VlcPlayerWithControlsState>();

  // VideoPlayerController? _videoPlayerController;
  // CustomVideoPlayerController? _customVideoPlayerController;
  // final CustomVideoPlayerSettings _customVideoPlayerSettings =
  // CustomVideoPlayerSettings(
  //   controlBarAvailable: false,
  //   showPlayButton: true,
  //   playButton: Center(child: Icon(Icons.play_circle, color: Colors.white,),),
  //   settingsButtonAvailable: false,
  //   playbackSpeedButtonAvailable: false,
  //   placeholderWidget: Container(child: Center(child: CircularProgressIndicator()),color: gBlackColor,),
  // );

  bool showUploadProgress = false;

  addUrlToVideoPlayer(String url) async {
    print("url"+ url);
    // _videoPlayerController = VideoPlayerController.network(Uri.parse(url).toString());
    // _videoPlayerController!.initialize().then((value) => setState(() {}));
    // _customVideoPlayerController = CustomVideoPlayerController(
    //   context: context,
    //   videoPlayerController: _videoPlayerController!,
    //   customVideoPlayerSettings: _customVideoPlayerSettings,
    // );
    // _videoPlayerController!.play();
    // Wakelock.enable();

    _videoPlayerController = VlcPlayerController.network(
      Uri.parse(url).toString(),
      // url,
      // 'http://samples.mplayerhq.hu/MPEG-4/embedded_subs/1Video_2Audio_2SUBs_timed_text_streams_.mp4',
      // 'https://media.w3.org/2010/05/sintel/trailer.mp4',
      hwAcc: HwAcc.auto,
      autoPlay: true,
      options: VlcPlayerOptions(
        advanced: VlcAdvancedOptions([
          VlcAdvancedOptions.networkCaching(2000),
        ]),
        subtitle: VlcSubtitleOptions([
          VlcSubtitleOptions.boldStyle(true),
          VlcSubtitleOptions.fontSize(30),
          VlcSubtitleOptions.outlineColor(VlcSubtitleColor.yellow),
          VlcSubtitleOptions.outlineThickness(VlcSubtitleThickness.normal),
          // works only on externally added subtitles
          VlcSubtitleOptions.color(VlcSubtitleColor.navy),
        ]),
        http: VlcHttpOptions([
          VlcHttpOptions.httpReconnect(true),
        ]),
        rtp: VlcRtpOptions([
          VlcRtpOptions.rtpOverRtsp(true),
        ]),
      ),
    )..initialize()..play();
    if (!await Wakelock.enabled) {
      Wakelock.enable();
    }
    setState(() {

    });
  }


  buildVideoPlayer() {
    print("_videoPlayerController: $_videoPlayerController");
    if(_videoPlayerController != null){
      return Stack(
        children: [
          AspectRatio(
            aspectRatio: 16/9,
            child: Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(5),
                border: Border.all(color: gPrimaryColor, width: 1),
                // boxShadow: [
                //   BoxShadow(
                //     color: Colors.grey.withOpacity(0.3),
                //     blurRadius: 20,
                //     offset: const Offset(2, 10),
                //   ),
                // ],
              ),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(5),
                child: Center(
                  // child: CustomVideoPlayer(
                  //   customVideoPlayerController: _customVideoPlayerController!,
                  // ),
                    child: VlcPlayerWithControls(
                      key: _key,
                      controller: _videoPlayerController!,
                      showVolume: false,
                      showVideoProgress: false,
                      seekButtonIconSize: 10.sp,
                      playButtonIconSize: 14.sp,
                      replayButtonSize: 10.sp,
                    )
                ),
              ),
            ),
          ),
          // Positioned(child:
          // AspectRatio(
          //   aspectRatio: 16/9,
          //   child: GestureDetector(
          //     onTap: (){
          //       print("onTap");
          //       if(_videoPlayerController != null){
          //         if(_customVideoPlayerController!.videoPlayerController.value.isPlaying){
          //           _customVideoPlayerController!.videoPlayerController.pause();
          //         }
          //         else{
          //           _customVideoPlayerController!.videoPlayerController.play();
          //         }
          //       }
          //     },
          //   ),
          // )
          // )

        ],
      );
    }
    else {
      return SizedBox.shrink();
    }
  }

  showUploadReportPopup() {
    return showDialog(
        context: context,
        builder: (_){
          return StatefulBuilder(
              builder: (_, setState){
                return Dialog(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20.0),
                  ),
                  child: showReportUploadStatus(setState),
                );
              }
          );
        }
    );
  }

  showReportUploadStatus(Function setState){
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 14, vertical: 10),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          showRadioList("Uploaded all report.", setState),
          showRadioList("Not all reports uploaded.", setState),
          SizedBox(
            height: 2.h,
          ),
          MediaQuery(
            data: MediaQuery.of(context).copyWith(textScaleFactor: 0.75),
            child: Center(child:  GestureDetector(
                onTap: (){
                  EvaluationModelFormat1 model = widget.evaluationModelFormat1;
                  model.allReportsUploaded = selectedUploadRadio;
                  // 28 items if other is null
                  print(model.toMap());
                  if(_videoPlayerController != null){
                    _videoPlayerController!.stop();
                  }
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (ctx) => PersonalDetailsScreen2(
                              evaluationModelFormat1: model,
                              medicalReportList:
                              medicalRecords.map((e) => e.path).toList())
                      ));
                },
                child: Container(
                  width: 35.w,
                  height: 4.h,
                  margin: EdgeInsets.symmetric(vertical: 2.h),
                  padding: EdgeInsets.symmetric(vertical: 1.h, horizontal: 10.w),
                  decoration: BoxDecoration(
                    color: eUser().buttonColor,
                    borderRadius: BorderRadius.circular(eUser().buttonBorderRadius),
                    // border: Border.all(
                    //     color: eUser().buttonBorderColor,
                    //     width: eUser().buttonBorderWidth
                    // ),
                  ),
                  child: Center(
                    child: Text(
                      'SUBMIT',
                      style: TextStyle(
                        fontFamily: eUser().buttonTextFont,
                        color: eUser().buttonTextColor,
                        fontSize: eUser().buttonTextSize,
                      ),
                    ),
                  ),
                )
            ),),
          )
        ],
      ),
    );
  }

  String selectedUploadRadio = "";

  showRadioList(String name, Function setstate){
    return GestureDetector(
      onTap: (){
        setstate((){
          selectedUploadRadio = name;
        });
      },
      child: Row(
        children: [
          SizedBox(
            width: 10,
            child: Radio(
              value: name,
              activeColor: kPrimaryColor,
              groupValue: selectedUploadRadio,
              onChanged: (value){
                setstate(() {
                  selectedUploadRadio = name;
                });
              },
            ),
          ),
          SizedBox(
            width: 10,
          ),
          Expanded(
            child: Text(
              name,
              style: buildTextStyle(color: name == selectedUploadRadio ? kTextColor : gHintTextColor,
                  fontFamily: name == selectedUploadRadio ? kFontMedium : kFontBook
              ),
            ),
          ),
        ],
      ),
    );
  }

  final AboutProgramRepository repository = AboutProgramRepository(
    apiClient: ApiClient(
      httpClient: http.Client(),
    ),
  );

  Future<void> disposePlayer() async {
    if(_videoPlayerController != null){
      _videoPlayerController!.dispose();
    }
    // if(_customVideoPlayerController != null){
    //   _customVideoPlayerController!.dispose();
    // }
    if(await Wakelock.enabled){
      Wakelock.disable();
    }
  }

}
