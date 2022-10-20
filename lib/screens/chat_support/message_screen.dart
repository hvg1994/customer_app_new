import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:grouped_list/grouped_list.dart';
import 'package:gwc_customer/screens/profile_screens/call_support_method.dart';
import 'package:gwc_customer/utils/app_config.dart';
import 'package:gwc_customer/widgets/unfocus_widget.dart';
import 'package:gwc_customer/widgets/widgets.dart';
import 'package:intl/intl.dart';
import 'package:sizer/sizer.dart';
import 'package:socket_io_client/socket_io_client.dart' as IO;
import '../../model/message_model/message_model.dart';
import '../../widgets/constants.dart';

class MessageScreen extends StatefulWidget {
  const MessageScreen({Key? key}) : super(key: key);

  @override
  State<MessageScreen> createState() => _MessageScreenState();
}

class _MessageScreenState extends State<MessageScreen> {
  final formKey = GlobalKey<FormState>();

  TextEditingController commentController = TextEditingController();
  ScrollController? _controller;
  IO.Socket? socket;

  static final _pref = AppConfig().preferences;

  void _sendMessage() {
    String messageText = commentController.text.trim();
    commentController.text = '';
    print(messageText);
    if (messageText != '') {
      var messagePost = {
        'message': messageText,
        'sender': 'Ganesh',
        // 'recipient': 'chat',
        'time': DateTime.now().toUtc().toString().substring(0, 16)
      };
      socket!.emit('chat', messagePost);
    }
  }

  @override
  void initState() {
    super.initState();
    commentController.addListener(() {
      setState(() {});
    });
    _controller = ScrollController();
    initSocket();
    WidgetsBinding.instance?.addPostFrameCallback((_) => {
      _controller!.animateTo(
        0.0,
        duration: Duration(milliseconds: 200),
        curve: Curves.easeIn,
      )
    });
  }

  Future<void> initSocket() async {
    final user_id = _pref?.getInt(AppConfig.USER_ID) ?? -1;
    print('Connecting to chat service with $user_id');
    // String registrationToken = await getFCMToken();
    socket = IO.io('https://gwc.disol.in:1333/socket.io/?user_id=$user_id&user_type=user&group_id=nN5oJI',
        <String, dynamic>{
      'transports': ['websocket'],
      'autoConnect': false,
      'query': {
        'user_id': user_id.toString(),
        'user_type': "user",
        'group_id': 'nN5oJI'
        // 'registrationToken': registrationToken
      }
    });
    socket!.connect();
    socket!.onConnect((_) {
      print('connected to websocket');
    });
    socket!.on('chat_message', (message) {
      print(message);
      setState(() {
        MessagesModel.updateMessages(message);
      });
    });
    // socket.on('allChats', (messages) {
    //   print(messages);
    //   setState(() {
    //     MessagesModel.messages.addAll(messages);
    //   });
    // });
  }

  @override
  void dispose() {
    commentController.dispose();
    socket!.disconnect();
    super.dispose();
  }

  List<Message> messages = [
    Message(
        text: "Hi!\nI have some question about my prescription.",
        date: DateTime.now().subtract(
          const Duration(minutes: 1, days: 10),
        ),
        sendMe: false,
        image: "assets/images/closeup-content-attractive-indian-business-lady.png"
    ),
    Message(
        text: "Hello, Adam!",
        date: DateTime.now().subtract(
          const Duration(minutes: 5, days: 10),
        ),
        sendMe: true,
        image: "assets/images/cheerful.png"
    ),
    Message(
        text: "Lorem ipsum  Is Simply Dummy Text",
        date: DateTime.now().subtract(
          const Duration(minutes: 1, days: 6),
        ),
        sendMe: false,
        image: "assets/images/closeup-content-attractive-indian-business-lady.png"
    ),
    Message(
        text: "done.",
        date: DateTime.now().subtract(
          const Duration(minutes: 5, days: 6),
        ),
        sendMe: true,
        image: "assets/images/cheerful.png"
    ),
    Message(
        text: "Lorem ipsum  Is Simply Dummy Text",
        date: DateTime.now().subtract(
          const Duration(minutes: 1, days: 3),
        ),
        sendMe: false,
        image: "assets/images/closeup-content-attractive-indian-business-lady.png"
    ),
    Message(
        text: "Okay,",
        date: DateTime.now().subtract(
          const Duration(minutes: 5, days: 3),
        ),
        sendMe: true,
        image: "assets/images/cheerful.png"
    ),
    Message(
        text: "Lorem ipsum  Is Simply Dummy Text",
        date: DateTime.now().subtract(
          const Duration(minutes: 1, days: 2),
        ),
        sendMe: false,
        image: "assets/images/closeup-content-attractive-indian-business-lady.png"
    ),
    Message(
        text: "Okay,",
        date: DateTime.now().subtract(
          const Duration(minutes: 5, days: 2),
        ),
        sendMe: true,
        image: "assets/images/cheerful.png"
    ),
    Message(
        text: "Lorem ipsum  Is Simply Dummy Text",
        date: DateTime.now().subtract(
          const Duration(minutes: 1, days: 0),
        ),
        sendMe: false,
        image:"assets/images/closeup-content-attractive-indian-business-lady.png"
    ),
    Message(
        text: "Okay,",
        date: DateTime.now().subtract(
          const Duration(minutes: 5, days: 0),
        ),
        sendMe: true,
        image: "assets/images/cheerful.png"
    ),
  ].toList();

  @override
  Widget build(BuildContext context) {
    return UnfocusWidget(
      child: Scaffold(
        body: Container(
          color: gsecondaryColor,
          child: Column(
            children: [
              Padding(
                padding: EdgeInsets.only(top: 2.h, left: 4.w, right: 4.w),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    buildAppBar(() {
                      Navigator.pop(context);
                    }),
                    Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          "Ms. Lorem Ipsum Daries",
                          style: TextStyle(
                              fontFamily: "PoppinsRegular",
                              color: gWhiteColor,
                              fontSize: 10.sp),
                        ),
                        SizedBox(height: 0.5.h),
                        Text(
                          "Age : 26 Female",
                          style: TextStyle(
                              fontFamily: "PoppinsLight",
                              color: gWhiteColor,
                              fontSize: 9.sp),
                        ),
                        SizedBox(height: 2.h),
                      ],
                    ),
                    GestureDetector(
                      onTap: () {
                        callSupport();
                      },
                      child: Container(
                        padding: const EdgeInsets.all(5),
                        decoration: BoxDecoration(
                          color: gWhiteColor.withOpacity(0.3),
                          borderRadius: BorderRadius.circular(50),
                        ),
                        child: const Icon(
                          Icons.local_phone,
                          color: gPrimaryColor,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(height: 3.h),
              Expanded(
                child: Container(
                  padding: EdgeInsets.symmetric(horizontal: 2.w, vertical: 1.h),
                  width: double.maxFinite,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    boxShadow: [
                      BoxShadow(
                          blurRadius: 2, color: Colors.grey.withOpacity(0.5))
                    ],
                    borderRadius: const BorderRadius.only(
                      topLeft: Radius.circular(20),
                      topRight: Radius.circular(20),
                    ),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Expanded(
                        child: buildMessageList(),
                      ),
                      Row(
                        children: [
                          Expanded(
                            child: Container(
                              // height: 5.h,
                              padding: EdgeInsets.symmetric(horizontal: 2.w),
                              decoration: BoxDecoration(
                                color: const Color(0xffF8F4F4),
                                borderRadius: BorderRadius.circular(10),
                              ),
                              child: Form(
                                key: formKey,
                                child: TextFormField(
                                  // cursorColor: kPrimaryColor,
                                  controller: commentController,
                                  textAlignVertical: TextAlignVertical.center,
                                  decoration: InputDecoration(
                                    hintText: "Say Something ...",
                                    alignLabelWithHint: true,
                                    hintStyle: TextStyle(
                                      color: gMainColor,
                                      fontSize: 10.sp,
                                      fontFamily: "GothamBook",
                                    ),
                                    border: InputBorder.none,
                                    suffixIcon: InkWell(
                                            onTap: () {
                                              showAttachmentSheet();
                                            },
                                            child: const Icon(
                                              Icons.add,
                                              color: gPrimaryColor,
                                            ),
                                          ),
                                  ),
                                  style: TextStyle(
                                      fontFamily: "GothamMedium",
                                      color: gTextColor,
                                      fontSize: 11.sp
                                  ),
                                  maxLines: 3,
                                  minLines: 1,
                                  textInputAction: TextInputAction.none,
                                  textAlign: TextAlign.start,
                                  keyboardType: TextInputType.text,
                                ),
                              ),
                            ),
                          ),
                          commentController.text.toString().isNotEmpty
                              ? SizedBox(
                                  width: 2.w,
                                )
                              : SizedBox(width: 0),
                          commentController.text.toString().isEmpty
                              ? SizedBox(
                                  width: 0,
                                )
                              : InkWell(
                                  onTap: () {
                                    final message = Message(
                                        text: commentController.text.toString(),
                                        date: DateTime.now(),
                                        sendMe: true,
                                        image: "assets/images/closeup-content-attractive-indian-business-lady.png"
                                    );
                                    setState(() {
                                      messages.add(message);
                                    });
                                    _sendMessage();
                                    // commentController.clear();
                                  },
                                  child: const Icon(
                                    Icons.send,
                                    color: kPrimaryColor,
                                  ),
                                ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  buildMessageList() {
    return GroupedListView<dynamic, DateTime>(
      elements: MessagesModel.messages,
      groupBy: (message) =>
          DateTime(message.date.year, message.date.month, message.date.day),
      physics: const BouncingScrollPhysics(),
      padding: EdgeInsets.symmetric(horizontal: 0.w),
      groupHeaderBuilder: (dynamic message) => Center(
        child: Container(
          margin: EdgeInsets.symmetric(vertical: 1.h),
          child: Text(
            DateFormat.yMMMd().format(message.date),
            style: TextStyle(
                fontFamily: "GothamBook",
                height: 1.5,
                color: gGreyColor.withOpacity(0.5),
                fontSize: 9.sp),
          ),
        ),
      ),
      itemBuilder: (context, dynamic message) => Align(
        alignment:
            message.sendMe ? Alignment.centerRight : Alignment.centerLeft,
        child: Stack(
          overflow: Overflow.visible,
          clipBehavior: Clip.none,
          children: [
            Container(
              margin: message.sendMe
                  ? EdgeInsets.only(top: 1.h, bottom: 1.h, left: 10.w)
                  : EdgeInsets.only(top: 1.h, bottom: 1.h, right: 10.w),
              padding: EdgeInsets.symmetric(horizontal: 5.w, vertical: 1.5.h),
              decoration: BoxDecoration(
                  color: message.sendMe
                      ? gGreyColor.withOpacity(0.2)
                      : gsecondaryColor,
                  borderRadius: BorderRadius.circular(10)),
              child: Text(
                message.text.toString(),
                style: TextStyle(
                    fontFamily: "GothamBook",
                    height: 1.5,
                    color: message.sendMe ? gTextColor : gWhiteColor,
                    fontSize: 10.sp),
              ),
            ),
            message.sendMe
                ? Positioned(
                    bottom: 0,
                    right: -1,
                    child: Align(
                      alignment: Alignment.bottomRight,
                      child: Container(
                        // padding: const EdgeInsets.all(4),
                        decoration: BoxDecoration(
                          color: gsecondaryColor,
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(8),
                          child: Center(
                            child: Image(
                              image: AssetImage(message.image),
                              height: 2.h,
                            ),
                          ),
                        ),
                      ),
                    ),
                  )
                : Positioned(
              bottom: 0,
              left: -3,
                    child: Container(
                      padding: const EdgeInsets.all(4),
                      decoration: BoxDecoration(
                        color: gWhiteColor,
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(8),
                        child: Image(
                          image: AssetImage(message.image),
                          height: 2.h,
                        ),
                      ),
                    ),
                  ),
          ],
        ),
      ),
    );
  }

  showAttachmentSheet() {
    return showModalBottomSheet(
        backgroundColor: Colors.transparent,
        context: context,
        enableDrag: false,
        builder: (ctx){
          return Wrap(
            children: [
              Container(
                padding: EdgeInsets.symmetric(horizontal: 8, vertical: 10),
                margin: EdgeInsets.only(left: 10, right: 10, bottom: 10),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.only(
                      topRight: Radius.circular(20),
                      topLeft: Radius.circular(20),
                      bottomRight: Radius.circular(20),
                      bottomLeft: Radius.circular(20)
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
                    SizedBox(
                      height: 10,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        iconWithText( Icons.insert_drive_file, 'Document', () {
                          // getImageFromCamera();
                          Navigator.pop(context);
                        }),
                        iconWithText( Icons.camera_enhance_outlined, 'Camera', () {
                          // getImageFromCamera();
                          Navigator.pop(context);
                        }),
                        iconWithText( Icons.image, 'Gallery', () {
                          // getImageFromCamera();
                          Navigator.pop(context);
                        }),
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

  iconWithText(IconData assetName, String optionName, VoidCallback onPress){
    return GestureDetector(
      onTap: onPress,
      child: SizedBox(
        child: Column(
          children: [
            Container(
              padding: EdgeInsets.all(10),
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: gPrimaryColor
              ),
              child:Center(
                child: Icon(assetName,
                  color: gMainColor,
                ),
              ),
            ),
            SizedBox(
              height: 4,
            ),
            Text(
              optionName,
              style: TextStyle(
                color: gTextColor,
                fontSize: 10.sp,
                fontFamily: "GothamMedium",
              ),
            )
          ],
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
