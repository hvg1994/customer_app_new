/*
Ticket details screen

Api's used:-
1. getting messages from the ticketId  (GET)
2027812 is ticketId
https://fembuddy.uvdesk.com/en/api/ticket/2027812/threads.json


2. send reply to that ticket  (POST)
api: https://fembuddy.uvdesk.com/en/api/ticket/2027812/threads.json
params:

threadType:reply  -> threadtype: reply|forward|note
reply:sdbk from agent  -> description
status:3  -> value: 1|2|3|4|5|6 for open|pending|resolved|closed|Spam|Answered repectively
//to:     -> in case of threadType:forward
//actAsType:customer  -> this is for customer
//actAsEmail:abc@gmail.com  -> provide with actAsType

 */

import 'dart:io';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_widget_from_html/flutter_widget_from_html.dart'
    hide ImageSource;
import 'package:gwc_customer/screens/uvdesk/ticket_pop_up_menu.dart';
import 'package:http/http.dart' as http;
import 'package:http/http.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:sizer/sizer.dart';
import 'package:grouped_list/grouped_list.dart';
import '../../../model/error_model.dart';
import '../../../widgets/widgets.dart';
import '../../model/uvdesk_model/new_ticket_details_model.dart';
import '../../repository/api_service.dart';
import '../../repository/uvdesk_repository/uvdesk_repo.dart';
import '../../services/uvdesk_service/uv_desk_service.dart';
import '../../utils/app_config.dart';
import '../../widgets/constants.dart';
import 'package:cached_network_image/cached_network_image.dart';

import 'attachments_view_screen.dart';

class TicketChatScreen extends StatefulWidget {
  final String userName;
  final String thumbNail;
  final String ticketId;
  final String subject;
  final String email;

  /// ticketStatus is to show/hide textfield and reopen ticket option
  final int ticketStatus;
  const TicketChatScreen(
      {Key? key,
      required this.userName,
      required this.thumbNail,
      required this.ticketId,
      required this.subject,
      required this.email,
      required this.ticketStatus})
      : super(key: key);

  @override
  State<TicketChatScreen> createState() => _TicketChatScreenState();
}

class _TicketChatScreenState extends State<TicketChatScreen>
    with WidgetsBindingObserver {
  final formKey = GlobalKey<FormState>();
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  TextEditingController commentController = TextEditingController();
  bool showProgress = false;
  bool isLoading = false;

  NewTicketDetailsModel? threadsListModel;
  List<Threads>? threadList;

  late final UvDeskService _uvDeskService =
      UvDeskService(uvDeskRepo: repository);

  final ScrollController _scrollController = ScrollController();

  final String imageBaseUrl = "https://support.gutandhealth.com/public";
  @override
  void initState() {
    super.initState();
    commentController.addListener(() {
      setState(() {});
    });
    getThreadsList();
  }

  @override
  void dispose() {
    commentController.removeListener(() {});
    super.dispose();
  }

  getThreadsList() async {
    setState(() {
      showProgress = true;
    });
    callProgressStateOnBuild(true);
    final result =
        await _uvDeskService.getTicketDetailsByIdService(widget.ticketId);
    print("result: $result");

    if (result.runtimeType == NewTicketDetailsModel) {
      print("Threads List");
      NewTicketDetailsModel model = result as NewTicketDetailsModel;
      threadsListModel = model;
      threadList = model.ticket!.threads;
      print("threads List : $threadList");
    } else {
      ErrorModel model = result as ErrorModel;
      print("error: ${model.message}");
    }
    setState(() {
      showProgress = false;
    });
    print(result);
  }

  callProgressStateOnBuild(bool value) {
    Future.delayed(Duration.zero).whenComplete(() {
      setState(() {
        showProgress = value;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: gBackgroundColor,
      body: SafeArea(
        key: _scaffoldKey,
        child: Column(
          children: [
            Padding(
              padding: EdgeInsets.only(top: 1.h, left: 2.w, right: 4.w),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  GestureDetector(
                    onTap: () async {
                      Navigator.pop(context);
                    },
                    child: Padding(
                      padding: EdgeInsets.only(top: 0.5.h),
                      child: const Icon(
                        Icons.arrow_back_ios,
                        color: gsecondaryColor,
                      ),
                    ),
                  ),
                  widget.thumbNail.isEmpty
                      ? CircleAvatar(
                          radius: 2.h,
                          backgroundColor: kNumberCircleRed,
                          child: Text(
                            getInitials(widget.userName, 2),
                            style: TextStyle(
                              fontSize: 8.sp,
                              fontFamily: kFontBold,
                              color: gWhiteColor,
                            ),
                          ),
                        )
                      : CircleAvatar(
                          radius: 2.h,
                          backgroundImage: NetworkImage(widget.thumbNail),
                        ),
                  SizedBox(width: 2.w),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          widget.userName,
                          style: TextStyle(
                            fontSize: headingFont,
                            fontFamily: kFontBold,
                          ),
                        ),
                        Text(
                          widget.ticketId,
                          style: TextStyle(
                            fontSize: subHeadingFont,
                            fontFamily: kFontMedium,
                          ),
                        ),
                        Text(
                          widget.subject,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: TextStyle(
                            fontSize: smTextFontSize,
                            color: gHintTextColor,
                            fontFamily: kFontBook,
                          ),
                        ),
                      ],
                    ),
                  ),
                  TicketPopUpMenu(
                      ticketId: widget.ticketId,
                      ticketStatus: widget.ticketStatus)
                  // popupMenu()
                ],
              ),
            ),
            SizedBox(height: 1.h),
            Expanded(
              child: Container(
                padding: EdgeInsets.symmetric(vertical: 1.h),
                width: double.maxFinite,
                decoration: BoxDecoration(
                  color: gBackgroundColor,
                  boxShadow: [
                    BoxShadow(
                      blurRadius: 5,
                      color: Colors.grey.withOpacity(0.5),
                    ),
                  ],
                  borderRadius: const BorderRadius.only(
                    topLeft: Radius.circular(30),
                    topRight: Radius.circular(30),
                  ),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(
                      child: RawScrollbar(
                        thumbVisibility: false,
                        thickness: 3,
                        controller: _scrollController,
                        radius: const Radius.circular(3),
                        thumbColor: gMainColor,
                        child: showProgress
                            ? buildCircularIndicator()
                            : buildMessageList(
                                threadsListModel!.ticket!.threads!),
                        // StreamBuilder(
                        //   stream: _uvDeskService.stream.asBroadcastStream(),
                        //   builder: (_, snapshot) {
                        //     print("snap.data: ${snapshot.data}");
                        //     if (snapshot.hasData) {
                        //       return buildMessageList();
                        //     } else if (snapshot.hasError) {
                        //       return Center(
                        //         child: Text(snapshot.error.toString()),
                        //       );
                        //     }
                        //     return const Center(
                        //       child: CircularProgressIndicator(),
                        //     );
                        //   },
                        // ),
                      ),
                    ),
                    if (widget.ticketStatus != 4) _buildEnterMessageRow(),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  popupMenu() {
    return PopupMenuButton(
      offset: const Offset(0, 30),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(5)),
      itemBuilder: (context) => [
        PopupMenuItem(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(height: 0.6.h),
              buildDummyTabView(
                  index: 1,
                  title: "ReOpen Ticket",
                  isEnabled:
                      (widget.ticketStatus == 4 || widget.ticketStatus == 3)),
              SizedBox(height: 0.6.h),
            ],
          ),
        ),
      ],
      child: Icon(
        Icons.more_vert,
        color: gHintTextColor,
        size: 2.h,
      ),
    );
  }

  Widget buildDummyTabView(
      {required int index, required String title, bool isEnabled = true}) {
    return GestureDetector(
      onTap: isEnabled
          ? () {
              Navigator.pop(context);
            }
          : null,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            title,
            style: TextStyle(
              fontFamily: kFontBook,
              color: gTextColor,
              fontSize: 8.sp,
            ),
          ),
          Container(
            margin: EdgeInsets.symmetric(vertical: 1.h),
            height: 1,
            color: gHintTextColor.withOpacity(0.3),
          ),
        ],
      ),
    );
  }

  Widget _buildEnterMessageRow() {
    return SafeArea(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (fileFormatList.isNotEmpty)
            Flexible(
                child: SizedBox(
              height: 70,
              child: ListView.builder(
                  scrollDirection: Axis.horizontal,
                  shrinkWrap: true,
                  itemCount: fileFormatList.length,
                  itemBuilder: (_, index) {
                    return _imageListView(fileFormatList[index], index);
                  }),
            )),
          Row(
            children: [
              Expanded(
                child: Container(
                  margin: EdgeInsets.only(left: 3.w, top: 0.5.h),
                  // padding: EdgeInsets.symmetric(horizontal: 2.w),
                  decoration: BoxDecoration(
                    boxShadow: [
                      BoxShadow(
                        color: Colors.grey.withOpacity(0.3),
                        blurRadius: 10,
                      ),
                    ],
                    color: gWhiteColor,
                    borderRadius: BorderRadius.circular(100),
                  ),
                  child: Form(
                    key: formKey,
                    child: TextFormField(
                      cursorColor: gsecondaryColor,
                      controller: commentController,
                      textAlignVertical: TextAlignVertical.center,
                      decoration: InputDecoration(
                        // hintText: "Say Something ...",
                        alignLabelWithHint: true,
                        hintStyle: TextStyle(
                          color: gMainColor,
                          fontSize: 10.sp,
                          fontFamily: "GothamBook",
                        ),
                        border: InputBorder.none,
                        prefixIcon: InkWell(
                          onTap: () {},
                          child: const Icon(
                            Icons.sentiment_satisfied_alt_sharp,
                            color: gBlackColor,
                          ),
                        ),
                        suffixIcon: InkWell(
                          onTap: () {
                            showChooserSheet();
                          },
                          child: const Icon(
                            Icons.attach_file_sharp,
                            color: gBlackColor,
                          ),
                        ),
                      ),
                      style: TextStyle(
                          fontFamily: "GothamBook",
                          color: gBlackColor,
                          fontSize: 10.sp),
                      maxLines: 3,
                      minLines: 1,
                      textInputAction: TextInputAction.none,
                      textAlign: TextAlign.start,
                      keyboardType: TextInputType.text,
                    ),
                  ),
                ),
              ),
              SizedBox(width: 2.w),
              commentController.text.toString().isEmpty
                  ? Container(
                      width: 0,
                    )
                  : GestureDetector(
                      onTap: () {
                        sendReply();
                        // final message = Message(
                        //     text: commentController.text.toString(),
                        //     date: DateTime.now(),
                        //     sendMe: true,
                        //     image:
                        //         "assets/images/closeup-content-attractive-indian-business-lady.png");
                        setState(() {
                          // messages.add(message);
                        });
                        commentController.clear();
                      },
                      child: Container(
                        margin: EdgeInsets.only(right: 2.w),
                        padding: const EdgeInsets.only(
                            left: 8, right: 5, top: 5, bottom: 6),
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          boxShadow: [
                            BoxShadow(
                              color: Colors.grey.withOpacity(1),
                              blurRadius: 10,
                              offset: const Offset(2, 5),
                            ),
                          ],
                          color: gsecondaryColor,
                        ),
                        child: Icon(
                          Icons.send,
                          color: gWhiteColor,
                          size: 2.5.h,
                        ),
                      ),
                    ),
            ],
          ),
        ],
      ),
    );
  }

  _imageListView(File loc, int index) {
    return Stack(
      children: [
        Container(
          height: 65,
          width: 80,
          decoration:
              BoxDecoration(image: DecorationImage(image: FileImage(loc))),
        ),
        Positioned(
            top: 2,
            right: 2,
            child: IconButton(
              icon: Icon(Icons.close),
              onPressed: () {
                setState(() {
                  fileFormatList.removeAt(index);
                });
              },
            ))
      ],
    );
  }

  buildMessageList(List<Threads> threads) {
    return GroupedListView<Threads, DateTime>(
      elements: threads,
      order: GroupedListOrder.ASC,
      reverse: false,
      floatingHeader: true,
      useStickyGroupSeparators: true,
      padding: EdgeInsets.symmetric(horizontal: 2.w),
      keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
      groupBy: (Threads message) {
        // final f = DateFormat(message.formatedCreatedAt.toString());
        // DateTime d = DateTime.parse(message.formatedCreatedAt.toString());
        return DateTime(2023, 7, 17);
      },
      // padding: EdgeInsets.symmetric(horizontal: 0.w),
      groupHeaderBuilder: (Threads message) => Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            margin: const EdgeInsets.only(top: 7, bottom: 7),
            padding: EdgeInsets.symmetric(horizontal: 3.w, vertical: 0.5.h),
            decoration: const BoxDecoration(
              color: Color(0xffd9e3f7),
              borderRadius: BorderRadius.all(
                Radius.circular(11),
              ),
            ),
            child: Text(
              "Today",
              // _buildHeaderDate(int.parse(message.formatedCreatedAt.toString())),
              style: TextStyle(
                fontFamily: "GothamBook",
                color: gBlackColor,
                fontSize: 8.sp,
              ),
            ),
          ),
        ],
      ),
      itemBuilder: (context, Threads message) => Row(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Container(
          //     child: message.isIncoming
          //         ? _generateAvatarFromName(message.senderName)
          //         : null),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.only(top: 15),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: message.createdBy == "agent"
                    ? CrossAxisAlignment.start
                    : CrossAxisAlignment.end,
                children: [
                  FittedBox(
                    fit: BoxFit.fitWidth,
                    child: Container(
                      width: double.maxFinite,
                      padding: EdgeInsets.only(
                          left: 3.5.w, right: 3.5.w, bottom: 1.5.h, top: 1.5.h),
                      constraints: BoxConstraints(maxWidth: 65.w, minWidth: 0),
                      margin: message.createdBy == "agent"
                          ? EdgeInsets.only(
                              top: 0.5.h, bottom: 0.5.h, left: 5, right: 20.w)
                          : EdgeInsets.only(
                              top: 0.5.h, bottom: 0.5.h, right: 5, left: 20.w),
                      decoration: BoxDecoration(
                          color: message.createdBy == "agent"
                              ? (message.cc != null)
                                  ? kNumberCircleRed
                                  : gWhiteColor
                              : gsecondaryColor,
                          boxShadow: [
                            BoxShadow(
                                blurRadius: 1.0,
                                color: Colors.grey.withAlpha(60),
                                spreadRadius: 1.0,
                                offset: Offset(0.0, 1.0))
                          ],
                          borderRadius: BorderRadius.only(
                              topLeft: Radius.circular(18),
                              topRight: Radius.circular(18),
                              bottomLeft: message.createdBy == "agent"
                                  ? Radius.circular(0)
                                  : Radius.circular(18),
                              bottomRight: message.createdBy == "agent"
                                  ? Radius.circular(18)
                                  : Radius.circular(0))),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          if (message.createdBy == "agent")
                            IntrinsicWidth(
                              child: Align(
                                alignment: Alignment.centerLeft,
                                child: HtmlWidget(
                                  (message.user!.name != null)
                                      ? "${message.user?.name}"
                                      : "",
                                  textStyle: TextStyle(
                                      fontSize: smTextFontSize,
                                      color: gHintTextColor,
                                      fontFamily: kFontBold),
                                ),
                              ),
                            ),
                          if (message.createdBy == "agent")
                            SizedBox(
                              height: 1.h,
                            ),
                          ...message.attachments!.map(
                            (e) => (message.attachments != null &&
                                    message.attachments!.isNotEmpty)
                                ? InkWell(
                                    onTap: () {
                                      buildAttachmentView(
                                          imageBaseUrl + e.relativePath!);
                                    },
                                    child: Padding(
                                      padding:  EdgeInsets.symmetric(vertical: 1.h),
                                      child: ClipRRect(
                                        borderRadius: BorderRadius.circular(10.0),
                                        child: Image(
                                          image: NetworkImage(
                                              imageBaseUrl + e.relativePath!),
                                          fit: BoxFit.contain,
                                          height: 15.h,
                                        ),
                                      ),
                                    )
                                    // child: Align(
                                    //   alignment: Alignment.topLeft,
                                    //   child: Container(
                                    //     constraints: const BoxConstraints(
                                    //       maxHeight: 120,maxWidth: 70,
                                    //     ),
                                    //     decoration: BoxDecoration(
                                    //         image: DecorationImage(
                                    //             image: NetworkImage(
                                    //                 imageBaseUrl +
                                    //                     e.relativePath!),
                                    //             fit: BoxFit.contain)),
                                    //     // child: Image.network(imageBaseUrl+e.relativePath! ?? ''),
                                    //   ),
                                    // ),
                                  )
                                : const SizedBox(),
                          ),
                          HtmlWidget(
                            message.message ?? "",
                            textStyle: TextStyle(
                              color: message.createdBy == "agent"
                                  ? (message.cc != null)
                                      ? gWhiteColor
                                      : gTextColor
                                  : gWhiteColor,
                            ),
                          ),
                          // Align(
                          //   alignment: Alignment.bottomRight,
                          //   child: Padding(
                          //     padding: EdgeInsets.only(top: 0.5.h),
                          //     child: Row(
                          //       mainAxisSize: MainAxisSize.min,
                          //       mainAxisAlignment:
                          //           MainAxisAlignment.spaceBetween,
                          //       children: _buildNameTimeHeader(message),
                          //     ),
                          //   ),
                          // ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
      controller: _scrollController,
    );
  }

  String _buildHeaderDate(int? timeStamp) {
    String completedDate = "";
    DateFormat dayFormat = DateFormat("d MMMM");
    DateFormat lastYearFormat = DateFormat("dd.MM.yy");

    DateTime now = DateTime.now();
    var today = DateTime(now.year, now.month, now.day);
    var yesterday = DateTime(now.year, now.month, now.day - 1);

    timeStamp ??= 0;
    DateTime messageTime =
        DateTime.fromMicrosecondsSinceEpoch(timeStamp * 1000);
    DateTime messageDate =
        DateTime(messageTime.year, messageTime.month, messageTime.day);

    if (today == messageDate) {
      completedDate = "Today";
    } else if (yesterday == messageDate) {
      completedDate = "Yesterday";
    } else if (now.year == messageTime.year) {
      completedDate = dayFormat.format(messageTime);
    } else {
      completedDate = lastYearFormat.format(messageTime);
    }

    return completedDate;
  }

  // List<Widget> _buildNameTimeHeader(message) {
  //   return <Widget>[
  //     // const Padding(padding: EdgeInsets.only(left: 16)),
  //     // _buildSenderName(message),
  //     // const Padding(padding: EdgeInsets.only(left: 7)),
  //     // const Expanded(child: SizedBox.shrink()),
  //     //  const Padding(padding: EdgeInsets.only(left: 3)),
  //     _buildDateSent(message),
  //     Padding(padding: EdgeInsets.only(left: 1.w)),
  //     message.isIncoming
  //         ? const SizedBox.shrink()
  //         : _buildMessageStatus(message),
  //   ];
  // }
  //
  // Widget _buildMessageStatus(message) {
  //   var deliveredIds = message.qbMessage.deliveredIds;
  //   var readIds = message.qbMessage.readIds;
  //   // if (_dialogType == QBChatDialogTypes.PUBLIC_CHAT) {
  //   //   return SizedBox.shrink();
  //   // }
  //   if (readIds != null && readIds.length > 1) {
  //     return const Icon(
  //       Icons.done_all,
  //       color: Colors.blue,
  //       size: 14,
  //     );
  //   } else if (deliveredIds != null && deliveredIds.length > 1) {
  //     return const Icon(Icons.done_all, color: gGreyColor, size: 14);
  //   } else {
  //     return const Icon(Icons.done, color: gGreyColor, size: 14);
  //   }
  // }
  //
  // Widget _buildDateSent(message) {
  //   // print("DateTime:${message.qbMessage.dateSent!}");
  //   return Text(
  //     _buildTime(message.qbMessage.dateSent!),
  //     maxLines: 1,
  //     style: TextStyle(
  //       fontSize: 7.sp,
  //       color: gTextColor,
  //       fontFamily: "GothamBook",
  //     ),
  //   );
  // }

  String _buildTime(int timeStamp) {
    DateTime dateTime = DateTime.fromMicrosecondsSinceEpoch(timeStamp * 1000);
    String amPm = 'AM';
    if (dateTime.hour >= 12) {
      amPm = 'PM';
    }

    String hour = dateTime.hour.toString();
    if (dateTime.hour > 12) {
      hour = (dateTime.hour - 12).toString();
    }

    String minute = dateTime.minute.toString();
    if (dateTime.minute < 10) {
      minute = '0${dateTime.minute}';
    }
    return '$hour:$minute $amPm';
  }

  Widget _generateAvatarFromName(String? name) {
    name ??= "No name";
    return Container(
      width: 20,
      height: 20,
      decoration: BoxDecoration(
          color: gMainColor.withOpacity(0.18),
          borderRadius: const BorderRadius.all(Radius.circular(20))),
      child: Center(
        child: Text(
          name.substring(0, 1).toUpperCase(),
          style: const TextStyle(
              color: gPrimaryColor,
              fontWeight: FontWeight.bold,
              fontFamily: 'GothamMedium'),
        ),
      ),
    );
  }

  static String getInitials(String string, int limitTo) {
    var buffer = StringBuffer();
    var wordList = string.trim().split(' ');

    if (string.isEmpty) {
      return string;
    }

    if (wordList.length <= 1) {
      return string.characters.first;
    }

    if (limitTo > wordList.length) {
      for (var i = 0; i < wordList.length; i++) {
        buffer.write(wordList[i][0]);
      }
      return buffer.toString();
    }

    // Handle all other cases
    for (var i = 0; i < (limitTo); i++) {
      buffer.write(wordList[i][0]);
    }
    return buffer.toString();
  }

  final UvDeskRepo repository = UvDeskRepo(
    apiClient: ApiClient(
      httpClient: http.Client(),
    ),
  );

  sendReply() async {
    setState(() {
      isLoading = true;
    });
    print("---------Send reply---------");

    Map m = {
      'message': commentController.text,
      'threadType': ThreadType.reply.name,
      'actAsType': ActAsType.customer.name,
      'actAsEmail': widget.email,
      'status_id': (TicketStatusType.answered.index + 1).toString()
    };

    final result = await _uvDeskService.sendReplyService(widget.ticketId, m,
        attachments: fileFormatList);

    if (result.runtimeType != ErrorModel) {
      // SentReplyModel model = result as SentReplyModel;
      setState(() {
        isLoading = false;
      });
      // GwcApi().showSnackBar(context, model.message!, isError: true);
      commentController.clear();
      fileFormatList.clear();
      getThreadsList();
    } else {
      setState(() {
        isLoading = false;
      });
      ErrorModel response = result as ErrorModel;
      AppConfig().showSnackbar(context, response.message!, isError: true);
      // Navigator.of(context).pushReplacement(
      //   MaterialPageRoute(
      //     builder: (context) => const DashboardScreen(),
      //   ),
      // );
    }
  }

  /*
  Attachment codes
   */

  showChooserSheet() {
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
                          color: gHintTextColor,
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
                              color: gHintTextColor,
                              width: 1,
                            ),
                          )),
                        ),
                        TextButton(
                            onPressed: () {
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

  getFileSize(File file) {
    var size = file.lengthSync();
    num mb = num.parse((size / (1024 * 1024)).toStringAsFixed(2));
    return mb;
  }

  List<MultipartFile> newList = <MultipartFile>[];
  List<File> fileFormatList = [];

  void pickFromFile() async {
    final result = await FilePicker.platform.pickFiles(
      withReadStream: true,
      type: FileType.any,
      // allowedExtensions: ['pdf', 'jpg', 'png', 'jpeg'],
      allowMultiple: true,
    );
    if (result == null) return;

    /// if allowMultiple: true
    List<File> _files = result.paths.map((path) => File(path!)).toList();

    _files.forEach((element) {
      print(element.path.split('.').last);
      if (element.path.split('.').last.toLowerCase().contains("pdf") ||
          element.path.split('.').last.toLowerCase().contains("png") ||
          element.path.split('.').last.toLowerCase().contains("jpg") ||
          element.path.split('.').last.toLowerCase().contains("jpeg")) {
        if (getFileSize(element) <= 12) {
          print("filesize: ${getFileSize(File(result.paths.first!))}Mb");
          print(element.path);
          addFilesToList(element);
          // addToMultipartList();
        } else {
          AppConfig()
              .showSnackbar(context, "File size must be <12Mb", isError: true);
        }
      } else {
        AppConfig().showSnackbar(context, "Please select png/jpg/Pdf files",
            isError: true);
      }
    });

    /// single file select for this  allowMultiple should be false allowMultiple: false
    // if (result.files.first.extension!.contains("pdf") ||
    //     result.files.first.extension!.contains("png") ||
    //     result.files.first.extension!.contains("jpg") ||
    //     result.files.first.extension!.contains("jpeg")) {
    //   if (getFileSize(File(result.paths.first!)) <= 12) {
    //     print("filesize: ${getFileSize(File(result.paths.first!))}Mb");
    //     files.add(result.files.first);
    //     // addFilesToList(File(result.paths.first!));
    //     if (type != null) {
    //       if (reportsObject.isNotEmpty) {
    //         reportsObject.forEach((element) {
    //           if (element.id.toString().contains(type)) {
    //             element.path.add(result.paths.first!);
    //           }
    //         });
    //       }
    //       if (type == "others") {
    //         otherFilesObject.add(result.paths.first ?? '');
    //       }
    //       print("otherFilesObject: $otherFilesObject");
    //     }
    //   }
    //   else {
    //     AppConfig()
    //         .showSnackbar(context, "File size must be <12Mb", isError: true);
    //   }
    // }
    // else {
    //   AppConfig().showSnackbar(context, "Please select png/jpg/Pdf files",
    //       isError: true);
    // }
    setState(() {});
  }

  addFilesToList(File file) async {
    print(
        "contains: ${fileFormatList.any((element) => element.path == file.path)}");

    if (!fileFormatList.any((element) => element.path == file.path)) {
      fileFormatList.add(file);
    }
    setState(() {});
  }

  addToMultipartList() async {
    print("addToMultipartList");
    newList.clear();

    // for (int i = 0; i < fileFormatList.length; i++) {
    //   var length = await fileFormatList[i].length();
    //   print("cleard: $i");
    //   print("newList for: ${newList.length} ${fileFormatList.length}");
    //   var stream =
    //   http.ByteStream(DelegatingStream.typed(fileFormatList[i].openRead()));
    //   var multipartFile = http.MultipartFile("attachments[]", stream, length,
    //       filename: fileFormatList[i].path);
    //   newList.add(multipartFile);
    //   print("newList after: ${newList.length}");
    // }

    print("fileFormatList: ${fileFormatList.length}");

    print("newList: ${newList.length}");
  }

  File? _image;

  Future getImageFromCamera({String? type}) async {
    var image = await ImagePicker.platform
        .pickImage(source: ImageSource.camera, imageQuality: 40);

    setState(() {
      _image = File(image!.path);
      if (getFileSize(_image!) <= 12) {
        print("filesize: ${getFileSize(_image!)}Mb");

        addFilesToList(_image!);
      } else {
        print("filesize: ${getFileSize(_image!)}Mb");

        AppConfig()
            .showSnackbar(context, "File size must be <12Mb", isError: true);
      }
    });
    print("captured image: ${_image} ${_image!.path}");
  }

  isExists(File file) {
    fileFormatList.map((element) {
      if (element.absolute.path == file.absolute.path) {
        print("found :: path exists file: ${file.path} ele: ${element.path}");
        return true;
      } else {
        print(
            "found :: path not exists file: ${file.path} ele: ${element.path}");
        return false;
      }
    });
  }

  Future buildAttachmentView(String attachmentUrl) {
    return showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: Colors.transparent,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.all(
            Radius.circular(15.0.sp),
          ),
        ),
        contentPadding: EdgeInsets.only(top: 1.h),
        content: AttachmentsViewScreen(
          attachmentUrl: attachmentUrl,
        ),
      ),
    );
  }
}

class Message {
  final String text;
  final DateTime date;
  final bool sendMe;
  final String image;

  Message(
      {required this.text,
      required this.date,
      required this.sendMe,
      required this.image});
}
