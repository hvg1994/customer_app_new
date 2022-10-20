import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:http/http.dart';
import 'package:image_picker/image_picker.dart';
import 'package:sizer/sizer.dart';
import 'dart:io';
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
  const UploadFiles({Key? key}) : super(key: key);

  @override
  State<UploadFiles> createState() => _UploadFilesState();
}

class _UploadFilesState extends State<UploadFiles> {
  List<PlatformFile> files = [];
  List<File> fileFormatList = [];
  List<MultipartFile> newList = <MultipartFile>[];

  File? _image;


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
              colors: [Color(0xffFFE889), Color(0xffFFF3C2)],
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter),
        ),
        child: Padding(
          padding: EdgeInsets.symmetric(vertical: 1.h, horizontal: 5.w),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Align(
                alignment: Alignment.topLeft,
                child: buildAppBar(() {
                  Navigator.pop(context);
                }),
              ),
              SizedBox(height: 5.h),
              Image(
                image: const AssetImage("assets/images/Group 3306.png"),
                height: 15.h,
              ),
              SizedBox(height: 2.h),
              Text(
                "Your Appointment has been Completed !\n Please upload the reports requested by Doctor.",
                textAlign: TextAlign.center,
                style: TextStyle(
                    height: 1.5,
                    fontFamily: "GothamRoundedBold_21016",
                    color: gTextColor,
                    fontSize: 12.sp),
              ),
              GestureDetector(
                onTap: () async {
                  showChooserSheet();
                },
                child: Container(
                  margin: EdgeInsets.symmetric(vertical: 5.h, horizontal: 3.w),
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
                          image:
                              const AssetImage("assets/images/Group 3323.png"),
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
              SizedBox(
                height: 1.8.h,
              ),
              Align(
                alignment: Alignment.topLeft,
                child: Text(
                  "Uploaded Report",
                  textAlign: TextAlign.center,
                  style: TextStyle(
                      fontFamily: "GothamRoundedBold_21016",
                      color: gTextColor,
                      fontSize: 11.sp),
                ),
              ),
              SizedBox(
                height: 20,
              ),
              (fileFormatList.isEmpty)
                  ? Container()
                  : ListView.builder(
                    itemCount: fileFormatList.length,
                    shrinkWrap: true,
                    itemBuilder: (context, index) {
                      final file = fileFormatList[index];
                      return buildFile(file, index);
                    },
                  ),
              SizedBox(
                height: 5.h,
              ),
              Center(
                child: GestureDetector(
                  onTap: () {
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
                      color: gPrimaryColor,
                      borderRadius: BorderRadius.circular(8),
                      border: Border.all(color: gMainColor, width: 1),
                    ),
                    child: (showUploadProgress) ? buildThreeBounceIndicator() : Center(
                      child: Text(
                        'Submit',
                        style: TextStyle(
                          fontFamily: "GothamRoundedBold_21016",
                          color: gWhiteColor,
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
            ), //   (file.extension == 'jpg' || file.extension == 'png')
            //     ? Image.file(
            //   File(file.path.toString()),
            //   width: 5.w,
            //   height: 5.h,
            // )
            //     : Container(),
            SizedBox(width: 3.w),
            Expanded(
              child: Column(crossAxisAlignment: CrossAxisAlignment.start,
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
    // files.removeAt(index);
    fileFormatList.removeAt(index);
    setState(() {});
  }

  bool showUploadProgress = false;

  getReportList() async{
    setState(() {
      showUploadProgress = true;
    });
    final res = await ReportService(repository: repository).getUploadedReportListListService();
    if(res.runtimeType == GetReportListModel){
      GetReportListModel result = res;
      setState(() {
        showUploadProgress = false;
      });
      print(result.data);
      // AppConfig().showSnackbar(context, result.message ?? '');
    }
    else{
      ErrorModel result = res;
      AppConfig().showSnackbar(context, result.message ?? '', isError: true);
      setState(() {
        showUploadProgress = false;
      });
    }
  }

  void uploadReport() async{
    if(fileFormatList.isNotEmpty){
      setState(() {
        showUploadProgress = true;
      });
      List reportList = fileFormatList.map((e) => e.path).toList();

      fileFormatList.forEach((element) {
        var size = element.lengthSync();
        num mb = size / (1024*1024);
        print("mb:$mb");
      });

      print("new list $newList");
      final res = await ReportService(repository: repository).uploadReportListService(newList);
      print(res.runtimeType);
      if(res.runtimeType == ErrorModel){
        ErrorModel result = res;
        AppConfig().showSnackbar(context, result.message ?? '', isError: true);
        setState(() {
          showUploadProgress = false;
        });
      }
      else {
        ReportUploadModel result = res;
        setState(() {
          showUploadProgress = false;
          fileFormatList.clear();
          newList.clear();
        });
        AppConfig().showSnackbar(context, result.errorMsg ?? '');
        // Navigator.of(context).push(
        //   MaterialPageRoute(
        //       builder: (context) =>
        //       const ReportsUploadedScreen()),
        // );
      }
    }
    else{
      AppConfig().showSnackbar(context, 'Please Upload at least 1 report' ?? '', isError: true);
    }
    setState(() {

    });
  }

  getFileSize(File file){
    var size = file.lengthSync();
    num mb = num.parse((size / (1024*1024)).toStringAsFixed(2));
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

  showChooserSheet(){
    return showModalBottomSheet(
      backgroundColor: Colors.transparent,
      context: context,
      enableDrag: false,
      builder: (ctx){
        return Wrap(
          children: [
            Container(
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.only(
                  topRight: Radius.circular(20),
                  topLeft: Radius.circular(20)
                ),
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
                        )
                    ),
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      TextButton(
                          onPressed: (){
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
                          )
                      ),
                      Container(
                        width: 5,
                        height: 10,
                        decoration: BoxDecoration(
                            border: Border(
                              right: BorderSide(
                                color: gGreyColor,
                                width: 1,
                              ),
                            )
                        ),
                      ),
                      TextButton(
                          onPressed: (){
                            pickFromFile();
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
                          )
                      )
                    ],
                  ),
                ],
              ),
            )
          ],
        );
      }
    );
  }


  void pickFromFile() async{
    final result = await FilePicker.platform
        .pickFiles(
      withReadStream: true,
      type: FileType.any,
      // allowedExtensions: ['pdf', 'jpg', 'png'],
      allowMultiple: false,
    );
    if (result == null) return;

    if(result.files.first.extension!.contains("pdf") || result.files.first.extension!.contains("png") || result.files.first.extension!.contains("jpg")){
      if(getFileSize(File(result.paths.first!)) <= 2){
        print("filesize: ${getFileSize(File(result.paths.first!))}Mb");
        files.add(result.files.first);
        addFilesToList(File(result.paths.first!));
      }
      else{
        AppConfig().showSnackbar(context, "File size must be <2Mb", isError: true);
      }
    }
    else{
      AppConfig().showSnackbar(context, "Please select png/jpg/Pdf files", isError: true);
    }
    setState(() {});
  }

  addFilesToList(File file) async{
    newList.clear();
    setState(() {
      fileFormatList.add(file);
    });

    for (int i = 0; i < fileFormatList.length; i++) {
      var stream = http.ByteStream(DelegatingStream.typed(fileFormatList[i].openRead()));
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
      if(getFileSize(_image!) <= 2){
        print("filesize: ${getFileSize(_image!)}Mb");
        addFilesToList(_image!);
      }
      else{
        print("filesize: ${getFileSize(_image!)}Mb");

        AppConfig().showSnackbar(context, "File size must be <2Mb", isError: true);
      }

    });
    print("captured image: ${_image}");
  }

}
