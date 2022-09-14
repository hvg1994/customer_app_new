import 'dart:io';
import 'package:dotted_border/dotted_border.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:gwc_customer/screens/reports_uploaded_screen.dart';
import 'package:sizer/sizer.dart';
import 'package:file_picker/file_picker.dart';

import '../widgets/constants.dart';
import '../widgets/widgets.dart';

class UploadReportsScreen extends StatefulWidget {
  const UploadReportsScreen({Key? key}) : super(key: key);

  @override
  State<UploadReportsScreen> createState() => _UploadReportsScreenState();
}

class _UploadReportsScreenState extends State<UploadReportsScreen> {
  List<PlatformFile> files = [];

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: SingleChildScrollView(
          physics: const BouncingScrollPhysics(),
          child: Padding(
            padding:
                EdgeInsets.only(left: 4.w, right: 4.w, top: 1.h, bottom: 5.h),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    buildAppBar(() {
                      Navigator.pop(context);
                    }),
                    GestureDetector(
                      onTap: () {},
                      child: const Icon(
                        Icons.camera_enhance_outlined,
                        color: gMainColor,
                      ),
                    ),
                  ],
                ),
                SizedBox(
                  height: 3.h,
                ),
                Text(
                  "Upload Report",
                  textAlign: TextAlign.center,
                  style: TextStyle(
                      fontFamily: "GothamRoundedBold_21016",
                      color: gPrimaryColor,
                      fontSize: 11.sp),
                ),
                Container(
                  padding: const EdgeInsets.all(8),
                  margin: EdgeInsets.symmetric(vertical: 2.h),
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
                  child: DottedBorder(
                    color: gMainColor,
                    strokeWidth: 1,
                    dashPattern: const [8, 5],
                    child: Container(
                      color: gContentColor,
                      child: Center(
                        child: Padding(
                          padding: EdgeInsets.symmetric(
                              vertical: 3.h, horizontal: 7.w),
                          child: Column(
                            children: [
                              Image(
                                height: 8.h,
                                image: const AssetImage(
                                    "assets/images/splash_screen/Folder.png"),
                              ),
                              SizedBox(height: 3.h),
                              Text(
                                'Upload your Reports in JPG,\nPDF & PNG',
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                  height: 1.5,
                                  fontFamily: "GothamMedium",
                                  color: gWhiteColor,
                                  fontSize: 10.sp,
                                ),
                              ),
                              SizedBox(height: 2.h),
                              GestureDetector(
                                onTap: () async {
                                  final result = await FilePicker.platform
                                      .pickFiles(
                                          withReadStream: true,
                                          allowMultiple: true);

                                  if (result == null) return;
                                  files.add(result.files.first);
                                  setState(() {});
                                },
                                child: Container(
                                  padding: EdgeInsets.symmetric(
                                      vertical: 1.h, horizontal: 5.w),
                                  decoration: BoxDecoration(
                                    color: gsecondaryColor,
                                    borderRadius: BorderRadius.circular(8),
                                    border:
                                        Border.all(color: gMainColor, width: 1),
                                  ),
                                  child: Text(
                                    'Browse',
                                    style: TextStyle(
                                      fontFamily: "GothamRoundedBold_21016",
                                      color: gWhiteColor,
                                      fontSize: 10.sp,
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
                SizedBox(height: 1.h),
                Text("Upload files",
                    textAlign: TextAlign.center,
                    style: TextStyle(
                        fontFamily: "GothamRoundedBold_21016",
                        color: gPrimaryColor,
                        fontSize: 11.sp)),
                SizedBox(
                  height: 2.h,
                ),
                (files.isEmpty)
                    ? Container()
                    : SizedBox(
                        width: double.maxFinite,
                        child: ListView.builder(
                          itemCount: files.length,
                          shrinkWrap: true,
                          itemBuilder: (context, index) {
                            final file = files[index];
                            return buildFile(file, index);
                          },
                        ),
                      ),
                SizedBox(
                  height: 5.h,
                ),
                Center(
                  child: GestureDetector(
                    onTap: () {
                      Navigator.of(context).push(
                        MaterialPageRoute(
                            builder: (context) =>
                                const ReportsUploadedScreen()),
                      );
                    },
                    child: Container(
                      padding:
                          EdgeInsets.symmetric(vertical: 1.h, horizontal: 25.w),
                      decoration: BoxDecoration(
                        color: gPrimaryColor,
                        borderRadius: BorderRadius.circular(8),
                        border: Border.all(color: gMainColor, width: 1),
                      ),
                      child: Text(
                        'Next',
                        style: TextStyle(
                          fontFamily: "GothamRoundedBold_21016",
                          color: gWhiteColor,
                          fontSize: 12.sp,
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
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
    return Column(
      children: [
        Container(
          margin: EdgeInsets.symmetric(vertical: 1.h),
          child: ListTile(
            leading: (file.extension == 'jpg' || file.extension == 'png')
                ? Image.file(
                    File(file.path.toString()),
                    width: 5.w,
                    height: 5.h,
                  )
                : Container(),
            title: Text(
              file.name,
              style: TextStyle(
                  fontSize: 10.sp, fontFamily: "GothamBook", color: gMainColor),
            ),
            subtitle: Text(
              size,
              style: TextStyle(
                  fontSize: 8.sp, fontFamily: "GothamBook", color: gMainColor),
            ),
            trailing: InkWell(
              onTap: () {
                _delete(index);
                setState(() {});
              },
              child: SvgPicture.asset(
                "assets/images/DElete.svg",
                color: kPrimaryColor,
              ),
            ),
          ),
        ),
        Container(
          height: 1,
          color: Colors.grey,
        ),
      ],
    );
  }

  void _delete(int index) {
    files.removeAt(index);
    setState(() {});
  }
}
