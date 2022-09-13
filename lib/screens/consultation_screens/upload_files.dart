import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:sizer/sizer.dart';
import 'dart:io';
import '../../widgets/constants.dart';
import '../../widgets/widgets.dart';

class UploadFiles extends StatefulWidget {
  const UploadFiles({Key? key}) : super(key: key);

  @override
  State<UploadFiles> createState() => _UploadFilesState();
}

class _UploadFilesState extends State<UploadFiles> {
  List<PlatformFile> files = [];

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
          padding: EdgeInsets.only(
            left: 4.w,
            right: 4.w,
            top: 4.h,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Align(
                alignment: Alignment.topLeft,
                child: buildAppBar(() {
                  Navigator.pop(context);
                }),
              ),
              SizedBox(height: 3.h),
              Image(
                image: const AssetImage("assets/images/Group 3306.png"),
                height: 15.h,
              ),
              SizedBox(height: 2.h),
              Text(
                "Lorem lpsum is simply dummy text of the printing and typesetting idustry.",
                textAlign: TextAlign.center,
                style: TextStyle(
                    height: 1.5,
                    fontFamily: "GothamMedium",
                    color: gTextColor,
                    fontSize: 11.sp),
              ),
              GestureDetector(
                onTap: () async {
                  final result = await FilePicker.platform
                      .pickFiles(withReadStream: true, allowMultiple: true);

                  if (result == null) return;
                  files.add(result.files.first);
                  setState(() {});
                },
                child: Container(
                  margin: EdgeInsets.symmetric(vertical: 3.h, horizontal: 3.w),
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
                height: 1.h,
              ),
              Align(
                alignment: Alignment.topLeft,
                child: Text(
                  "Uploaded Report",
                  textAlign: TextAlign.center,
                  style: TextStyle(
                      fontFamily: "GothamBold",
                      color: gTextColor,
                      fontSize: 10.sp),
                ),
              ),
              (files.isEmpty)
                  ? Container()
                  : ListView.builder(
                    itemCount: files.length,
                    shrinkWrap: true,
                    itemBuilder: (context, index) {
                      final file = files[index];
                      return buildFile(file, index);
                    },
                  ),
              SizedBox(
                height: 5.h,
              ),
              Center(
                child: GestureDetector(
                  onTap: () {
                    // Navigator.of(context).push(
                    //   MaterialPageRoute(
                    //       builder: (context) =>
                    //       const ReportsUploadedScreen()),
                    // );
                  },
                  child: Container(
                    padding:
                        EdgeInsets.symmetric(vertical: 1.h, horizontal: 10.w),
                    decoration: BoxDecoration(
                      color: gPrimaryColor,
                      borderRadius: BorderRadius.circular(8),
                      border: Border.all(color: gMainColor, width: 1),
                    ),
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
                    file.name,
                    style: TextStyle(
                        fontSize: 10.sp,
                        fontFamily: "GothamMedium",
                        color: gPrimaryColor),
                  ),
                  SizedBox(height: 0.5.h),
                  Text(
                    size,
                    style: TextStyle(
                        fontSize: 8.sp,
                        fontFamily: "GothamMedium",
                        color: gMainColor),
                  ),
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
    files.removeAt(index);
    setState(() {});
  }
}
