import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:gwc_customer/screens/program_plans/meal_pdf.dart';
import 'package:gwc_customer/widgets/background_widget.dart';
import 'package:gwc_customer/widgets/open_alert_box.dart';
import 'package:gwc_customer/widgets/show_photo_viewer.dart';
import 'package:http/http.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path_provider/path_provider.dart';
import 'package:sizer/sizer.dart';
import 'package:url_launcher/url_launcher.dart';
import 'dart:io';
import '../../../model/dashboard_model/report_upload_model/child_report_list_model.dart';
import '../../../model/dashboard_model/report_upload_model/report_list_model.dart';
import '../../../model/dashboard_model/report_upload_model/report_upload_model.dart';
import '../../../model/error_model.dart';
import '../../../repository/api_service.dart';
import '../../../repository/consultation_repository/get_report_repository.dart';
import '../../../services/consultation_service/report_service.dart';
import '../../../utils/app_config.dart';
import '../../../widgets/constants.dart';
import '../../../widgets/widgets.dart';
import 'package:http/http.dart' as http;
import 'package:async/async.dart';

class UploadFiles extends StatefulWidget {
  bool isFromSettings;
  UploadFiles({Key? key, this.isFromSettings = false}) : super(key: key);

  @override
  State<UploadFiles> createState() => _UploadFilesState();
}

class _UploadFilesState extends State<UploadFiles> {
  final _pref = AppConfig().preferences;
  List<PlatformFile> files = [];
  List<File> fileFormatList = [];
  List<MultipartFile> newList = <MultipartFile>[];

  List<ChildReportListModel> doctorRequestedReports = [];
  /*
  reportsObject = {
    "name": X-ray,
    "id": reportId,
    "path": path
  }
   */
  List<ReportObject> reportsObject = [];

  List requestedReportsListByUser = [];

  File? _image;

  dynamic padding = EdgeInsets.symmetric(vertical: 1.h, horizontal: 5.w);

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    if (!widget.isFromSettings) {
      getDoctorRequestedReportList();
    }
    else{
      getUserReportList();
    }
  }

  @override
  void didChangeDependencies() {
    // TODO: implement didChangeDependencies
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    return (widget.isFromSettings)
        ? showUserReports()
        : Container(
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
                    Padding(
                      padding: padding,
                      child: Image(
                        image: const AssetImage("assets/images/Group 3306.png"),
                        height: 15.h,
                      ),
                    ),
                    SizedBox(height: 2.h),
                    Padding(
                      padding: padding,
                      child: Text(
                        "Your Appointment has been Completed !\n Please upload the reports requested by Doctor.",
                        textAlign: TextAlign.center,
                        style: TextStyle(
                            height: 1.5,
                            fontFamily: "GothamRoundedBold_21016",
                            color: gTextColor,
                            fontSize: 12.sp),
                      ),
                    ),
                    Visibility(
                      visible: widget.isFromSettings,
                      child: Padding(
                        padding: padding,
                        child: GestureDetector(
                          onTap: () async {
                            showChooserSheet();
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
                    ),
                    SizedBox(
                      height: 1.8.h,
                    ),
                    (widget.isFromSettings)
                        ? showNormalReportList(context)
                        : showRequestedReports(context),
                    SizedBox(
                      height: 5.h,
                    ),
                    (widget.isFromSettings)
                        ? Visibility(
                            visible: fileFormatList.isNotEmpty,
                            child: Padding(
                              padding: padding,
                              child: Center(
                                child: GestureDetector(
                                  onTap: () async {
                                    uploadReport();

                                    // getReportList();
                                    // Navigator.of(context).push(
                                    //   MaterialPageRoute(
                                    //       builder: (context) =>
                                    //       const ReportsUploadedScreen()),
                                    // );
                                  },
                                  child: Container(
                                    width: 60.w,
                                    height: 5.h,
                                    // padding: EdgeInsets.symmetric(vertical: 1.h, horizontal: 10.w),
                                    decoration: BoxDecoration(
                                      color: eUser().buttonColor,
                                      borderRadius: BorderRadius.circular(eUser().buttonBorderRadius),
                                      // border: Border.all(color: eUser().buttonBorderColor,
                                      //     width: eUser().buttonBorderWidth),
                                    ),
                                    child: (showUploadProgress)
                                        ? buildThreeBounceIndicator(color: eUser().threeBounceIndicatorColor)
                                        : Center(
                                            child: Text(
                                              'Submit',
                                              style: TextStyle(
                                                fontFamily:
                                                    "GothamRoundedBold_21016",
                                                color: gWhiteColor,
                                                fontSize: 11.sp,
                                              ),
                                            ),
                                          ),
                                  ),
                                ),
                              ),
                            ),
                          )
                        : Padding(
                            padding: padding,
                            child: Center(
                              child: GestureDetector(
                                onTap: () async {
                                  Stream s = sendStream();
                                  print("s.length:${s.length}");
                                  // for(int i=0;i<reportsObject.length;i++){
                                  //   if(reportsObject[i].path.isNotEmpty){
                                  //     final res = await submitDoctorRequestedReport(reportsObject[i].path, reportsObject[i].id);
                                  //     print("button res: $res  ${res.runtimeType}");
                                  //
                                  //   }
                                  // }
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
                                                  "GothamRoundedBold_21016",
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

  Widget buildFile(File file, int index) {
    // final kb = file.size / 1024;
    // final mb = kb / 1024;
    // final size = (mb >= 1)
    //     ? '${mb.toStringAsFixed(2)} MB'
    //     : '${kb.toStringAsFixed(2)} KB';
    return Column(
      children: [
        Row(
          children: [
            Image(
              image: const AssetImage("assets/images/Group 2722.png"),
              height: 4.h,
            ),
            //   (file.extension == 'jpg' || file.extension == 'png')
            //     ? Image.file(
            //   File(file.path.toString()),
            //   width: 5.w,
            //   height: 5.h,
            // )
            //     : Container(),
            SizedBox(width: 3.w),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    file.path.split('/').last,
                    style: TextStyle(
                        fontSize: 10.sp,
                        fontFamily: "GothamMedium",
                        color: gPrimaryColor),
                  ),
                  SizedBox(height: 0.5.h),
                  // Text(
                  //   size,
                  //   style: TextStyle(
                  //       fontSize: 8.sp,
                  //       fontFamily: "GothamMedium",
                  //       color: gMainColor),
                  // ),
                ],
              ),
            ),
            InkWell(
              onTap: () {
                _delete(index);
                setState(() {});
              },
              child: SvgPicture.asset(
                "assets/images/DElete.svg",
                color: kPrimaryColor,
              ),
            ),
          ],
        ),
        Container(
          margin: EdgeInsets.symmetric(vertical: 1.5.h),
          height: 1,
          color: Colors.grey,
        ),
      ],
    );
  }

  void _delete(int index) {
    if (widget.isFromSettings) {
      files.removeAt(index);
      fileFormatList.removeAt(index);
    } else {
      reportsObject[index].path = '';
    }
    setState(() {});
  }

  bool showUploadProgress = false;

  getDoctorRequestedReportList() async {
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      openProgressDialog(context);
    });
    final res = await ReportService(repository: repository)
        .doctorRequestedReportListService();
    Navigator.pop(context);
    if (res.runtimeType == GetReportListModel) {
      GetReportListModel result = res;
      if(result.data != null){
        setState(() {
          showUploadProgress = false;
          doctorRequestedReports.addAll(result.data!);
        });
        Map reportObj = {};
        late ReportObject _reports;
        if (doctorRequestedReports.isNotEmpty) {
          doctorRequestedReports.forEach((element) {
            print("element.reportId:${element.reportId}");
            _reports = ReportObject(
                element.reportType!, element.id.toString() ?? '', '', false);
            // reportObj.putIfAbsent('name', () => element.reportType);
            // reportObj.putIfAbsent('id', () => element.reportId);
            // reportObj.putIfAbsent('path', () => '');
            reportsObject.add(_reports);
          });
        }
        doctorRequestedReports.forEach((element) {
          print("doc req: ${element.reportType}");
        });
        reportsObject.forEach((element) {
          print("req obj: ${element.name}");
        });
        print("result.data: ${result.data}");
        setState(() {});
      }
      else{
      }
      // AppConfig().showSnackbar(context, result.message ?? '');
    }
    else {
      ErrorModel result = res;
      AppConfig().showSnackbar(context, result.message ?? '', isError: true);
      setState(() {
        showUploadProgress = false;
      });
    }
  }

  getUserReportList() async {

    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      openProgressDialog(context);
    });
    final res = await ReportService(repository: repository)
        .getUploadedReportListListService();
    if (res.runtimeType == GetReportListModel) {
      GetReportListModel result = res;
      setState(() {
        showUploadProgress = false;
        doctorRequestedReports.addAll(result.data!);
      });
      print("uSER rEPORTS: $doctorRequestedReports");

      Map reportObj = {};
      late ReportObject _reports;
      if (doctorRequestedReports.isNotEmpty) {
        doctorRequestedReports.forEach((element) {
          _reports = ReportObject(
              element.reportType!, element.reportId ?? '', '', false);
          // reportObj.putIfAbsent('name', () => element.reportType);
          // reportObj.putIfAbsent('id', () => element.reportId);
          // reportObj.putIfAbsent('path', () => '');
          reportsObject.add(_reports);
        });
      }
      doctorRequestedReports.forEach((element) {
        print("doc req: ${element.reportType}");
      });
      reportsObject.forEach((element) {
        print("req obj: ${element.name}");
      });
      print("result.data: ${result.data}");
      setState(() {});
      // AppConfig().showSnackbar(context, result.message ?? '');
    } else {
      ErrorModel result = res;
      AppConfig().showSnackbar(context, result.message ?? '', isError: true);
      setState(() {
        showUploadProgress = false;
      });
    }
    Navigator.pop(context);
  }

  showUserReports() {
    return Scaffold(
      body: SingleChildScrollView(
        physics: const BouncingScrollPhysics(),
        child: Column(
          children: [
            Container(
              height: 1,
              color: Colors.grey.withOpacity(0.3),
            ),
            SizedBox(height: 2.h),
            ListView.builder(
              scrollDirection: Axis.vertical,
              physics: const BouncingScrollPhysics(),
              shrinkWrap: true,
              itemCount: doctorRequestedReports.length,
              itemBuilder: ((context, index) {
                return GestureDetector(
                  onTap: () async {
                    final url = doctorRequestedReports[index].report.toString();
                    if(url != null || url.isNotEmpty){
                      if(url.toLowerCase().contains(".jpg") || url.toLowerCase().contains(".png")){
                        Navigator.push(context, MaterialPageRoute(builder: (ctx)=> CustomPhotoViewer(url: url)));
                      }
                      // Navigator.push(context, MaterialPageRoute(builder: (ctx)=> MealPdf(pdfLink: url ,
                      //   heading: doctorRequestedReports[index]
                      //       .report
                      //       .toString()
                      //       .split("/")
                      //       .last
                      //   )));
                    }
                    // if (await canLaunch(url)) {
                    //   await launch(
                    //     url,
                    //     //forceSafariVC: true,
                    //     // forceWebView: true,
                    //     // enableJavaScript: true,
                    //   );
                    // }
                  },
                  child: Container(
                    margin: EdgeInsets.symmetric(
                        vertical: 1.h, horizontal: 2.w),
                    padding: EdgeInsets.symmetric(
                        vertical: 2.h, horizontal: 3.w),
                    decoration: BoxDecoration(
                      color: gWhiteColor,
                      boxShadow: [
                        BoxShadow(
                          color: Colors.grey.withOpacity(0.3),
                          blurRadius: 10,
                          offset: const Offset(2, 3),
                        ),
                      ],
                    ),
                    child: Row(
                      children: [
                        // Image(
                        //   height: 4.h,
                        //   image:
                        //       const AssetImage("assets/images/Group 2722.png"),
                        // ),
                        //   SizedBox(width: 3.w),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                doctorRequestedReports[index]
                                    .report
                                    .toString()
                                    .split("/")
                                    .last,
                                overflow: TextOverflow.ellipsis,
                                textAlign: TextAlign.start,
                                maxLines: 2,
                                style: TextStyle(
                                    height: 1.2,
                                    fontFamily: "GothamMedium",
                                    color: gPrimaryColor,
                                    fontSize: 9.sp),
                              ),
                              // SizedBox(height: 1.h),
                              // Text(
                              //   "2 MB",
                              //   style: TextStyle(
                              //       fontFamily: "GothamBook",
                              //       color: gMainColor,
                              //       fontSize: 9.sp),
                              // ),
                            ],
                          ),
                        ),
                        SizedBox(width: 3.w),
                        Icon(
                          Icons.arrow_forward_ios_outlined,
                          color: gMainColor,
                          size: 2.h,
                        ),
                      ],
                    ),
                  ),
                );
              }),
            ),

          ],
        ),
      ),
    );
  }

  void uploadReport() async {
    if (fileFormatList.isNotEmpty) {
      setState(() {
        showUploadProgress = true;
      });
      List reportList = fileFormatList.map((e) => e.path).toList();

      fileFormatList.forEach((element) {
        var size = element.lengthSync();
        num mb = size / (1024 * 1024);
        print("mb:$mb");
      });

      print("new list $newList");
      final res = await ReportService(repository: repository)
          .uploadReportListService(newList);
      print(res.runtimeType);
      if (res.runtimeType == ErrorModel) {
        ErrorModel result = res;
        AppConfig().showSnackbar(context, result.message ?? '', isError: true);
        setState(() {
          showUploadProgress = false;
        });
      } else {
        ReportUploadModel result = res;
        setState(() {
          showUploadProgress = false;
          fileFormatList.clear();
          newList.clear();
        });
        AppConfig().showSnackbar(context, result.errorMsg ?? '');
      }
    } else {
      AppConfig().showSnackbar(context, 'Please Upload at least 1 report' ?? '',
          isError: true);
    }
    setState(() {});
  }

  getFileSize(File file) {
    var size = file.lengthSync();
    num mb = num.parse((size / (1024 * 1024)).toStringAsFixed(2));
    return mb;
  }

  final ReportRepository repository = ReportRepository(
    apiClient: ApiClient(
      httpClient: http.Client(),
    ),
  );

  // showChooser() {
  //   return showDialog(
  //     context: context,
  //     builder: (context) => AlertDialog(
  //         content: Text("Choose File Source"),
  //         actions: [
  //           ElevatedButton(
  //             child: Text("Camera"),
  //             onPressed: () => Navigator.pop(context, ImageSource.camera),
  //           ),
  //           ElevatedButton(
  //             child: Text("File"),
  //             onPressed: () => Navigator.pop(context, ImageSource.gallery),
  //           ),
  //         ]
  //     ),
  //   );
  // }

  // string type will be used when we call from requested report
  showChooserSheet({String? type}) {
    return showModalBottomSheet(
        backgroundColor: Colors.transparent,
        context: context,
        enableDrag: false,
        builder: (ctx) {
          return Wrap(
            children: [
              Container(
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.only(
                      topRight: Radius.circular(20),
                      topLeft: Radius.circular(20)),
                ),
                child: Column(
                  children: [
                    Container(
                      padding: EdgeInsets.symmetric(horizontal: 2, vertical: 4),
                      child: Text('Choose File Source'),
                      decoration: BoxDecoration(
                          border: Border(
                        bottom: BorderSide(
                          color: gGreyColor,
                          width: 3.0,
                        ),
                      )),
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        TextButton(
                            onPressed: () {
                              getImageFromCamera();
                              Navigator.pop(context);
                            },
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Icon(
                                  Icons.camera_enhance_outlined,
                                  color: gMainColor,
                                ),
                                Text('Camera'),
                              ],
                            )),
                        Container(
                          width: 5,
                          height: 10,
                          decoration: BoxDecoration(
                              border: Border(
                            right: BorderSide(
                              color: gGreyColor,
                              width: 1,
                            ),
                          )),
                        ),
                        TextButton(
                            onPressed: () {
                              pickFromFile(type: type);
                              Navigator.pop(context);
                            },
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Icon(
                                  Icons.insert_drive_file,
                                  color: gMainColor,
                                ),
                                Text('File'),
                              ],
                            ))
                      ],
                    ),
                  ],
                ),
              )
            ],
          );
        });
  }

  void pickFromFile({String? type}) async {
    print('type: $type');
    final result = await FilePicker.platform.pickFiles(
      withReadStream: true,
      type: FileType.any,
      // allowedExtensions: ['pdf', 'jpg', 'png'],
      allowMultiple: false,
    );
    if (result == null) return;

    if (result.files.first.extension!.contains("pdf") ||
        result.files.first.extension!.contains("png") ||
        result.files.first.extension!.contains("jpg")) {
      if (getFileSize(File(result.paths.first!)) <= 2) {
        print("filesize: ${getFileSize(File(result.paths.first!))}Mb");
        files.add(result.files.first);
        addFilesToList(File(result.paths.first!));
        if (type != null) {
          if (reportsObject.isNotEmpty) {
            reportsObject.forEach((element) {
              if (element.id.toString().contains(type)) {
                element.path = result.paths.first ?? '';
              }
            });
          }
        }
      } else {
        AppConfig()
            .showSnackbar(context, "File size must be <2Mb", isError: true);
      }
    } else {
      AppConfig().showSnackbar(context, "Please select png/jpg/Pdf files",
          isError: true);
    }
    setState(() {});
  }

  addFilesToList(File file) async {
    newList.clear();
    setState(() {
      fileFormatList.add(file);
    });

    for (int i = 0; i < fileFormatList.length; i++) {
      var stream =
          http.ByteStream(DelegatingStream.typed(fileFormatList[i].openRead()));
      var length = await fileFormatList[i].length();
      var multipartFile = http.MultipartFile("files[]", stream, length,
          filename: fileFormatList[i].path);
      newList.add(multipartFile);
    }

    setState(() {});
  }

  Future getImageFromCamera() async {
    var image = await ImagePicker.platform.pickImage(
      source: ImageSource.camera,
    );

    setState(() {
      _image = File(image!.path);
      if (getFileSize(_image!) <= 2) {
        print("filesize: ${getFileSize(_image!)}Mb");
        addFilesToList(_image!);
      } else {
        print("filesize: ${getFileSize(_image!)}Mb");

        AppConfig()
            .showSnackbar(context, "File size must be <2Mb", isError: true);
      }
    });
    print("captured image: ${_image}");
  }

  buildReportList(String text,
      {String id = '', bool isSingleIcon = true,
      VoidCallback? onTap,
        VoidCallback? onSecondaryIconTap,
      bool isDoneIcon = false}) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        ListTile(
          onTap: null,
          minVerticalPadding: 0,
          dense: true,
          // contentPadding: EdgeInsets.only(left: 0.0, right: 0.0),
          title: Text(
            text,
            style: TextStyle(
                fontSize: 10.sp,
                fontFamily: "GothamBold",
                color: gPrimaryColor),
          ),
          trailing: (isDoneIcon)
              ? Icon(
                  Icons.done,
                  color: gPrimaryColor,
                )
              : (isSingleIcon)
                  ? GestureDetector(
                      onTap: onTap,
                      child: Icon(
                        Icons.upload_outlined,
                        color: gsecondaryColor,
                      ))
                  : Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        GestureDetector(
                          onTap: onTap,
                          child: Icon(
                            Icons.remove_red_eye_outlined,
                            color: gsecondaryColor,
                          ),
                        ),
                        SizedBox(
                          width: 5,
                        ),
                        GestureDetector(
                          onTap: onSecondaryIconTap,
                          child: Icon(
                            Icons.download_outlined,
                            color: gsecondaryColor,
                          ),
                        )
                      ],
                    ),
        ),
        (reportsObject.isNotEmpty)
            ? ListView.builder(
                itemCount: reportsObject.length,
                shrinkWrap: true,
                itemBuilder: (context, index) {
                  final file = File(reportsObject[index].path);
                  return Visibility(
                      visible: reportsObject[index].id == id &&
                          reportsObject[index].path.isNotEmpty,
                      child: buildFile(file, index));
                },
              )
            : Divider(),
      ],
    );
  }

  Future submitDoctorRequestedReport(String filePath, String reportId) async {
    openProgressDialog(context);

    var multipartFile = await http.MultipartFile.fromPath("file", filePath);
    final res = await ReportService(repository: repository)
        .submitDoctorRequestedReportService(reportId, multipartFile);
    print("submitDoctorRequestedReport res: $res");
    if (res.runtimeType == ErrorModel) {
      final result = res as ErrorModel;
      AppConfig().showSnackbar(context, result.message ?? '', isError: true);
    } else {
      final result = res as ReportUploadModel;
      print(result.errorMsg);
      reportsObject.forEach((element) {
        if (element.id == reportId) {
          element.isSubmited = true;
          element.path = '';
        }
      });
      setState(() {});
    }
    Navigator.pop(context);
  }

  bool getIsDone(List<ReportObject> reportsObjectList, index) {
    bool? isDone;
    if (reportsObjectList.isNotEmpty) {
      reportsObject.forEach((element) {
        // if(element.name == doctorRequestedReports[index].reportType){
        //   isDone =  element.isSubmited;
        // }
        if (element.path.isNotEmpty &&
            element.id.toString() == doctorRequestedReports[index].id.toString()) {
          isDone = true;
        }
      });
    } else {
      isDone = false;
    }
    return isDone ?? false;
  }

  showRequestedReports(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: padding,
          child: Align(
            alignment: Alignment.topLeft,
            child: Text(
              // "Uploaded Report",
              'Requested Report',
              textAlign: TextAlign.center,
              style: TextStyle(
                  fontFamily: "GothamRoundedBold_21016",
                  color: gTextColor,
                  fontSize: 11.sp),
            ),
          ),
        ),
        SizedBox(
          height: 10,
        ),
        (doctorRequestedReports.isEmpty)
            ? Padding(
                padding: padding,
                child: Container(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      buildReportList('Blood Report', onTap: () {
                        showChooserSheet();
                      }),
                      buildReportList('Xray Report', onTap: () async {
                        // var file = await getApplicationSupportDirectory();
                        // var packageRoot = file.path.substring(0, file.path.lastIndexOf('/'));
                        // var rootPath = packageRoot.substring(0, packageRoot.lastIndexOf('/'));
                        // print(rootPath);
                        // var directory = await Directory('$rootPath/Reports').create(recursive: true);
                        // print(directory.path);

                        // File file1 = new File('$rootPath/$filename');

                        showChooserSheet();
                      }),
                    ],
                  ),
                ),
              )
            : Padding(
                padding: padding,
                child: Container(
                  child: ListView.builder(
                      shrinkWrap: true,
                      itemCount: doctorRequestedReports.length,
                      itemBuilder: (_, index) {
                        print("reportsObject: $reportsObject");
                        // print(reportsObject[reportsObject.indexWhere((element) => element.name == doctorRequestedReports[index].reportType)].isSubmited);
                        return buildReportList(
                            doctorRequestedReports[index].reportType ?? '',
                            id: doctorRequestedReports[index].id.toString() ?? '',
                            isDoneIcon: getIsDone(reportsObject, index),
                            isSingleIcon: (doctorRequestedReports[index].reportType! != "prescription"),
                            onTap: () {
                              if(doctorRequestedReports[index].reportType == "prescription"){
                                Navigator.push(context, MaterialPageRoute(builder: (ctx)=> MealPdf(pdfLink: doctorRequestedReports[index].report! ,heading: "Prescription",)));
                              }
                              else{
                                reportsObject.forEach((element) {
                                  print(element.id);
                                  print(
                                      '${element.id} ${doctorRequestedReports[index].id}');
                                  print(element.id.toString() ==
                                      doctorRequestedReports[index].id.toString());
                                  if (element.id.toString() ==
                                      doctorRequestedReports[index].id.toString() &&
                                      element.path.isEmpty) {
                                    showChooserSheet(
                                        type:
                                        doctorRequestedReports[index].id.toString());
                                  } else if (element.name ==
                                      doctorRequestedReports[index].reportType &&
                                      element.path.isEmpty) {
                                    return;
                                  }
                                  // else{
                                  //   if(element.path .isNotEmpty){
                                  //     submitDoctorRequestedReport(element.path, element.id);
                                  //   }
                                  // }
                                });
                              }
                        },
                        );
                      }),
                ),
              ),
        SizedBox(
          height: 1.8.h,
        ),
        Divider(
          color: gGreyColor,
        ),
        Visibility(
          visible: false,
          child: Padding(
            padding: padding,
            child: buildReportList('Prescription', isSingleIcon: false,
                onTap: () async {
              //open code
              //     Navigator.push(context, MaterialPageRoute(builder: (ctx)=> MealPdf(pdfLink: url! ,)));
                  var file = await getExternalStorageDirectory();
              print(file!.path);
            }),
          ),
        ),
      ],
    );
  }

  showNormalReportList(BuildContext context) {
    return (fileFormatList.isEmpty)
        ? SizedBox()
        : Padding(
            padding: padding,
            child: ListView.builder(
              itemCount: fileFormatList.length,
              shrinkWrap: true,
              itemBuilder: (context, index) {
                final file = fileFormatList[index];
                return buildFile(file, index);
              },
            ),
          );
  }

  Stream sendStream() async* {
    for (int i = 0; i < reportsObject.length; i++) {
      if (reportsObject[i].path.isNotEmpty) {
        yield submitDoctorRequestedReport(
            reportsObject[i].path, reportsObject[i].id);
        // print("button res: $res  ${res.runtimeType}");
      }
    }
  }
}

class ReportObject {
  String name;
  String id;
  String path;
  bool isSubmited;
  ReportObject(this.name, this.id, this.path, this.isSubmited);
}
