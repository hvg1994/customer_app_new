import 'package:flutter/material.dart';
import 'package:gwc_customer/model/faq_model/faq_list_model.dart';
import 'package:gwc_customer/widgets/widgets.dart';
import 'package:sizer/sizer.dart';
import 'package:flutter_vlc_player/flutter_vlc_player.dart';

import '../../../widgets/constants.dart';


class FaqAnswerScreen extends StatefulWidget {
  final FaqList faqList;
  FaqAnswerScreen({Key? key, required this.faqList}) : super(key: key);

  @override
  State<FaqAnswerScreen> createState() => _FaqAnswerScreenState();
}

class _FaqAnswerScreenState extends State<FaqAnswerScreen> {
  // String question;
  VlcPlayerController? _videoPlayerController;


  FaqList? _faqList;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _faqList = widget.faqList;

    if(_faqList!.type != null && _faqList?.type == 'video'){
      _videoPlayerController = VlcPlayerController.network(
        'https://media.w3.org/2010/05/sintel/trailer.mp4',
        hwAcc: HwAcc.full,
        autoPlay: false,
        options: VlcPlayerOptions(),
      );
    }
  }
  @override
  void dispose() async {
    super.dispose();
    await _videoPlayerController?.stopRendererScanning();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
        child: Scaffold(
          body: Container(
            // width: 60.w,
            // height: 60.w,
            foregroundDecoration: BoxDecoration(
              image: DecorationImage(
                alignment: Alignment.topLeft,
                fit: BoxFit.scaleDown,
                // width: 60.w,
                // height: 60.w,
                // scale: 5.5,
                image: AssetImage('assets/images/Ellipse 2.png',
                ),
              )
            ),
            child: Column(
              children: [
                Padding(padding: EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                  child: buildAppBar((){
                    Navigator.pop(context);
                  }),
                ),
                Expanded(
                  child: Padding(
                    padding: EdgeInsets.symmetric(horizontal: 5.w, vertical: 15),
                    child: (widget.faqList.type == 'text')
                        ? textWidget()
                        : (widget.faqList.type == 'video')
                        ? videoWidget()
                        : imageWidget(),
                  ),
                )
              ],
            ),
          ),
        )
    );
  }

  textWidget(){
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Text(_faqList?.question ?? '',
          style: TextStyle(
              fontFamily: 'GothamBold',
              fontSize: 12.sp,
              height: 1.5
          ),
        ),
        SizedBox(
          height: 10,
        ),
        Text(_faqList?.answer ?? '',
          style: TextStyle(
              height: 1.5,
              fontFamily: 'GothamMedium',
              fontSize: 10.sp
          ),
        ),
      ],
    );
  }

  videoWidget(){
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(_faqList?.question ?? '',
          style: TextStyle(
              fontFamily: 'GothamBold',
              fontSize: 12.sp,
              height: 1.5
          ),
        ),
        SizedBox(
          height: 15,
        ),
        Container(
          width: 75.w,
          height: 40.h,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(12),
            boxShadow: [
              BoxShadow(
                blurRadius: 0.5,
                spreadRadius: 0.1
              )
            ]
          ),
          child: VlcPlayer(
            controller: _videoPlayerController!,
            aspectRatio: 16 / 9,
            placeholder: Center(child: CircularProgressIndicator()),
          ),
        ),
        SizedBox(
          height: 15,
        ),
      ],
    );
  }

  imageWidget(){
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        SizedBox(
          height: 15,
        ),
        Flexible(
          child: Image.network(
            _faqList?.answer ?? '',
            width: 75.w,
            height: 40.h,
            errorBuilder: (_, obj, __){
              return Center(child: Text('⚠ ${obj.toString()}',
                style: TextStyle(
                  color: Colors.red,
                  fontFamily: 'GothamLight'
                ),
              ));
            },
          ),
        ),
        SizedBox(
          height: 15,
        ),
      ],
    );
  }


  // oldUI(BuildContext context){
  //   return SafeArea(
  //       child: Scaffold(
  //         body: Column(
  //           children: [
  //             Padding(padding: EdgeInsets.symmetric(horizontal: 8, vertical: 8),
  //               child: buildAppBar((){
  //                 Navigator.pop(context);
  //               }),
  //             ),
  //             Expanded(
  //               child: Padding(
  //                 padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 15),
  //                 child: Column(
  //                   mainAxisAlignment: MainAxisAlignment.center,
  //                   children: [
  //                     Text(this.question,
  //                       style: TextStyle(
  //                           fontFamily: 'GothamBold',
  //                           fontSize: 12.sp,
  //                           height: 1.5
  //                       ),
  //                     ),
  //                     SizedBox(
  //                       height: 15,
  //                     ),
  //                     Image.asset(this.icon,
  //                       width: 75.w,
  //                       height: 40.h,
  //                     ),
  //                     SizedBox(
  //                       height: 15,
  //                     ),
  //                     Text(this.answer,
  //                       style: TextStyle(
  //                           height: 1.5,
  //                           fontFamily: 'GothamMedium',
  //                           fontSize: 10.sp
  //                       ),
  //                     ),
  //                   ],
  //                 ),
  //               ),
  //             )
  //           ],
  //         ),
  //       )
  //   );
  // }
}
