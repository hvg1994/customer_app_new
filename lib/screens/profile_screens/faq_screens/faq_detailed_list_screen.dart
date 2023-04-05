import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:gwc_customer/model/faq_model/faq_list_model.dart';
import 'package:gwc_customer/widgets/constants.dart';
import 'package:gwc_customer/widgets/widgets.dart';
import 'package:sizer/sizer.dart';

import 'faq_screen.dart';

class FaqDetailedList extends StatefulWidget {
  List<FaqList>? faqList;
  FaqDetailedList({Key? key, this.faqList}) : super(key: key);

  @override
  State<FaqDetailedList> createState() => _FaqDetailedListState();
}

class _FaqDetailedListState extends State<FaqDetailedList> {

  List<FaqList> questions = [];

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    print("widget.faqList");
    print(widget.faqList);
    if(widget.faqList != null){
      questions.addAll(widget.faqList!);
    }
  }

  @override
  Widget build(BuildContext context) {
    return expansionQueries();
  }

  expansionQueries(){
    return SafeArea(
        child: Scaffold(
          body: Column(
            children: [
              buildAppBar(() {
                Navigator.pop(context);
              }),
              Expanded(child: (questions.isNotEmpty)
                  ? ListView.builder(
                  physics: NeverScrollableScrollPhysics(),
                  shrinkWrap: true,
                  scrollDirection: Axis.vertical,
                  itemCount: questions.length,
                  itemBuilder: (_, index) {
                    return ExpansionTile(
                      title: Text(
                        questions[index].question!,
                        style: TextStyle(
                          color: Colors.black87,
                          fontSize: headingFont,
                          fontFamily: kFontMedium,
                        ),
                      ),
                      // leading: Image(
                      //   image: AssetImage("assets/images/Group 2747.png"),
                      // ),
                      children: [
                        Padding(
                          padding: const EdgeInsets.only(left: 20),
                          child: buildMenuItem(
                            text: questions[index].answer!,
                          ),
                        )
                      ],
                    );
                  })
                  : Center(child: Text("List is Empty"),)
              )
            ],
          ),
        )
    );
  }

  Widget buildMenuItem({
    required String text,
    VoidCallback? onClicked,
  }) {
    const color = kPrimaryColor;
    const hoverColor = Colors.grey;

    return ListTile(
      title: Text(
        text,
        style: TextStyle(
          fontFamily: eUser().userTextFieldFont,
          color: eUser().userTextFieldColor,
          fontSize: eUser().userTextFieldFontSize,
        ),
      ),
      hoverColor: hoverColor,
      onTap: onClicked,
    );
  }

  // goto(FaqList faq) {
  //   Navigator.push(
  //       context,
  //       MaterialPageRoute(
  //           builder: (_) => FaqAnswerScreen(
  //             faqList: faq,
  //             // question: faq.questions,
  //             // icon: faq.path,
  //             // answer: faq.answers
  //           )));
  // }
}
