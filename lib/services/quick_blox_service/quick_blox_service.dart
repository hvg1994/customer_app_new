/*
  1.first we need to login
  2.wen eed to connect using userId, Password
  3. join dialog dialog id will get from api
  4. send message

 */
import 'dart:async';
import 'dart:collection';
import 'dart:convert';
import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'package:path_provider/path_provider.dart';
import 'package:quickblox_sdk/auth/module.dart';
import 'package:quickblox_sdk/chat/constants.dart';
import 'package:quickblox_sdk/mappers/qb_message_mapper.dart';
import 'package:quickblox_sdk/models/qb_attachment.dart';
import 'package:quickblox_sdk/models/qb_dialog.dart';
import 'package:quickblox_sdk/models/qb_file.dart';
import 'package:quickblox_sdk/models/qb_filter.dart';
import 'package:quickblox_sdk/models/qb_message.dart';
import 'package:quickblox_sdk/models/qb_session.dart';
import 'package:quickblox_sdk/models/qb_sort.dart';
import 'package:quickblox_sdk/models/qb_user.dart';
import 'package:quickblox_sdk/notifications/constants.dart';
import 'package:quickblox_sdk/quickblox_sdk.dart';
import 'package:quickblox_sdk/users/constants.dart';

import '../../repository/quick_blox_repository/message_wrapper.dart';
import '../../utils/app_config.dart';

class QuickBloxService extends ChangeNotifier{

  final _pref = AppConfig().preferences;

  int? _localUserId;
  String? _dialogId;
  bool hasMore = false;

  static const int PAGE_SIZE = 20;

  QBSession? qbSession;

  Map<int, QBUser> _participantsMap = HashMap<int, QBUser>();
  Set<QBMessageWrapper> _wrappedMessageSet = HashSet<QBMessageWrapper>();
  List<String> _typingUsersNames = <String>[];
  TypingStatusTimer? _typingStatusTimer = TypingStatusTimer();

  List<QBMessageWrapper> list = [];

  StreamController _stream = StreamController.broadcast();
  StreamController get  stream => _stream;

  StreamController typingStream = StreamController.broadcast();

  String? _messageId;

  StreamSubscription? _newMessageSubscription;
  StreamSubscription? _deliveredMessageSubscription;
  StreamSubscription? _readMessageSubscription;
  StreamSubscription? _userTypingSubscription;
  StreamSubscription? _userStopTypingSubscription;
  StreamSubscription? _connectedSubscription;
  StreamSubscription? _connectionClosedSubscription;
  StreamSubscription? _reconnectionFailedSubscription;
  StreamSubscription? _reconnectionSuccessSubscription;

  String _errorMsg = '';
  String get errorMsg => _errorMsg;

  QuickBloxService(){
    subscribe();
    getInstance();
  }

  subscribe(){
    subscribeConnected();
    subscribeConnectionClosed();
    subscribeMessageDelivered();
    subscribeMessageRead();
    subscribeNewMessage();
    subscribeUserTyping();
    subscribeUserStopTyping();
  }
  getInstance(){
    if(_pref!.getInt(AppConfig.QB_CURRENT_USERID) != null){
      _localUserId = _pref!.getInt(AppConfig.QB_CURRENT_USERID);
    }
  }

  @override
  void dispose() {
    // TODO: implement dispose
    _stream.close();
    typingStream.close();
    super.dispose();
    unsubscribeNewMessage();
    unsubscribeDeliveredMessage();
    unsubscribeReadMessage();
    unsubscribeUserTyping();
    unsubscribeUserStopTyping();
    unsubscribeConnected();
    unsubscribeConnectionClosed();
    unsubscribeReconnectionFailed();
    unsubscribeReconnectionSuccess();
  }

  Future<bool> getSession() async{
    bool? _isExpired;
    int? expiry = _pref!.getInt(AppConfig.GET_QB_SESSION);
    if(expiry != null){
      if(DateTime.now().isAfter(DateTime.fromMillisecondsSinceEpoch(expiry))){
        _isExpired = true;
      }
      else{
        _isExpired = false;
      }
    }
    else {
      _isExpired = true;
    };
    return _isExpired;
  }
  // 1st login
  Future<bool> login(String userName) async {
    bool isLogin;
    try {
      // QBLoginResult result = await QB.auth.login(userName, AppConfig.QB_DEFAULT_PASSWORD);
      QBLoginResult result = await QB.auth.login("abc", AppConfig.QB_DEFAULT_PASSWORD);

      QBUser? qbUser = result.qbUser;
      _localUserId = qbUser?.id ?? -1;
      // connect(qbUser!.id!);
      //test
      connect(136562497);
      // on login success store username, password, userid to local
      // _pref!.setInt(AppConfig.QB_CURRENT_USERID, _localUserId!);

      QBSession? _qbSession = result.qbSession;
      qbSession = _qbSession;
      isLogin = true;
      _pref!.setBool(AppConfig.IS_QB_LOGIN, true);
      _pref!.setInt(AppConfig.GET_QB_SESSION, DateTime.parse(_qbSession!.expirationDate!).millisecondsSinceEpoch);
      print("login success..");
    } on PlatformException catch (e) {
      if (e.code == "Unauthorized" || e.code.contains('401')) {
        _errorMsg = "Need User";
      }
      else{
        _errorMsg = makeErrorMessage(e);
      }
      isLogin = false;
      print('login catch error: ${e.message}');
    }
    return isLogin;
  }

  Future<void> logout() async {
    try {
      await QB.auth.logout();
      _pref!.setBool(AppConfig.IS_QB_LOGIN, false);
      _pref!.remove(AppConfig.GET_QB_SESSION);
      _pref!.remove(AppConfig.QB_CURRENT_USERID);

      // SnackBarUtils.showResult(_scaffoldKey!, "Logout success");
    } on PlatformException catch (e) {
      print("logout error ${e.message}");
      // DialogUtils.showError(_scaffoldKey!.currentContext!, e);
    }
  }
  //2nd connect
  // PASS AppConfig.DEFAULT_PASSWORD IF PASSWORD NOT THERE
  connect(int userId) async {
    try {
      await QB.chat.connect(userId, AppConfig.QB_DEFAULT_PASSWORD);
      await QB.settings.enableAutoReconnect(true);
      print('The chat was connected');
      // SnackBarUtils.showResult(_scaffoldKey!, "The chat was connected");
    } on PlatformException catch (e) {
      print("connect error ${e}");
      // DialogUtils.showError(_scaffoldKey!.currentContext!, e);
    }
  }

  Future disconnect() async {
    try {
      await QB.chat.disconnect();
      print("The chat was disconnected}");
      // SnackBarUtils.showResult(_scaffoldKey!, "The chat was disconnected");
    } on PlatformException catch (e) {
      print("connect error ${e.message}");
      // DialogUtils.showError(_scaffoldKey!.currentContext!, e);
    }
  }

  isConnected() async {
    bool? connected;
    try {
      await QB.chat.isConnected().then((value) {
       connected = (value == true) ? true : false;
      });
      print("isConnected=> ${connected!}");
    } on PlatformException catch (e) {
      print("isConnected error ${e.message}");
      connected = false;
    }
    return connected;
  }

  Future joinDialog(String dialogId) async {
    try {
      await QB.chat.joinDialog(dialogId);
      print("The dialog $_dialogId was joined");

      loadMessages(dialogId);
    } on PlatformException catch (e) {
      print("join room error: ${e}");
      print(e.message);
      rethrow;
    }
  }


  void sendMessage(String chatRoomId, {String? message, List<QBAttachment>? attachments,}) async {
    try {
    //   Map<String, String> properties = Map();
    //   properties["testProperty1"] = "testPropertyValue1";
    //   properties["testProperty2"] = "testPropertyValue2";
    //   properties["testProperty3"] = "testPropertyValue3";

      /*To send push Notification
      String eventType = QBNotificationEventTypes.ONE_SHOT;
      String notificationEventType = QBNotificationTypes.PUSH;
      int pushType = QBNotificationPushTypes.GCM;
      int senderId = _pref!.getInt(AppConfig.QB_CURRENT_USERID)!;

      Map<String, Object> payload = new Map();
      payload["title"] = "You have New Message";
      payload["message"] = message!;
      payload["type"] = "chat";
            await QB.events.create(eventType, notificationEventType, senderId, payload, pushType: pushType);

*/
      await QB.chat.sendMessage(chatRoomId,
          attachments: attachments,
          body: message, saveToHistory: true,);

      String eventType = QBNotificationEventTypes.ONE_SHOT;
      String notificationEventType = QBNotificationTypes.PUSH;
      int pushType = QBNotificationPushTypes.GCM;
      // int senderId = _pref!.getInt(AppConfig.QB_CURRENT_USERID)!;
      int senderId = 82272762;
      // List<String> recipientsIds = ["82273007"];

      Map<String, Object> payload = new Map();
      payload["message"] = message!;
      payload["type"] = "chat";
      payload['senderId'] = senderId;
      await QB.events.create(eventType, notificationEventType, senderId, payload, pushType: pushType).then((value) {
        print("chat notification sent");
      }).onError((error, stackTrace) {
        print("Notification send error: ${error}");
      });

      print("The message was sent to dialog: $_dialogId");
      // SnackBarUtils.showResult(
      //     _scaffoldKey!, "The message was sent to dialog: $_dialogId");
    } on PlatformException catch (e) {
      print("send error: ${e.details}");
      print("send message error: ${e.toString()}");
      // DialogUtils.showError(_scaffoldKey!.currentContext!, e);
    }
  }

  Future<void> loadMessages(String dialogId) async {
    print("load messages");
    int skip = 0;
    if (_wrappedMessageSet.length > 0) {
      skip = _wrappedMessageSet.length;
    }
    List<QBMessage?>? messages;
    try {
      messages = await getDialogMessagesByDateSent(dialogId,
          limit: PAGE_SIZE, skip: skip);
    } on PlatformException catch (e) {
      print("excep error: ${e.message}");
    } on Exception catch (e) {
      print("excep error: ${e}");
    }

    if (messages != null || _localUserId != null) {
      List<QBMessageWrapper> wrappedMessages = await _wrapMessages(messages!);

      _wrappedMessageSet.addAll(wrappedMessages);
      hasMore = messages.length == PAGE_SIZE;
      print("hasmore: $hasMore");

      list = _wrappedMessageSet.toList();
      list.sort((first, second) => first.date.compareTo(second.date));
      _stream.sink.add(list);
      print('sink added from loadmessage:$list');
      notifyListeners();
    }
  }

  Future<List<QBMessage?>> getDialogMessagesByDateSent(String? dialogId,
      {int limit = 100, int skip = 0}) async {
    if (dialogId == null) {
      throw Exception();
    }
    QBSort sort = QBSort();
    sort.field = QBChatMessageSorts.DATE_SENT;
    sort.ascending = false;

    return await QB.chat
        .getDialogMessages(dialogId, sort: sort, limit: limit, skip: skip, markAsRead: false);
  }


  void subscribeNewMessage() async {
    if (_newMessageSubscription != null) {
      print("You already have a subscription for: " +
          QBChatEvents.RECEIVED_NEW_MESSAGE);
      // SnackBarUtils.showResult(
      //     _scaffoldKey!,
      //     "You already have a subscription for: " +
      //         QBChatEvents.RECEIVED_NEW_MESSAGE);
      return;
    }
    try {
      _newMessageSubscription = await QB.chat
          .subscribeChatEvent(QBChatEvents.RECEIVED_NEW_MESSAGE, _processIncomingMessageEvent, onErrorMethod: (error) {
            print("new message subscribe error ${error}");
        // DialogUtils.showError(_scaffoldKey!.currentContext!, error);
      });
      print( "Subscribed: " + QBChatEvents.RECEIVED_NEW_MESSAGE);
    } on PlatformException catch (e) {
      print("subscribe new message error: ${e.message}");
    }
  }
  void _processIncomingMessageEvent(dynamic data) async {
    Map<String, Object> map = Map<String, Object>.from(data);
    Map<String?, Object?> payload =
    Map<String?, Object?>.from(map["payload"] as Map<Object?, Object?>);

    String? dialogId = payload["dialogId"] as String;
    print("new message recieved$payload");
    QBMessage? message = QBMessageMapper.mapToQBMessage(payload);
    // print(message!.attachments!.first);
    print('_wrappedMessageSet.length: ${_wrappedMessageSet.length}');
    print("list.length: ${list.length}");

    _wrappedMessageSet.addAll(await _wrapMessages([message]));

    list = _wrappedMessageSet.toList();
    list.sort((first, second) => first.date.compareTo(second.date));
    _stream.sink.add(list);
    // _stream.add(list);
    hasMore = true;
    print('sink added:$list');
    list.forEach((element) {
      if(element.qbMessage.attachments != null){
        print('element.qbMessage.attachments!.first!.url!: ${element.qbMessage.attachments!.first!.id}');
      }
    });
    loadMessages(dialogId);
    notifyListeners();
  }

  Future getQbAttachmentUrl(String id) async{
    print("getqbUrl $id");
    try {
      QBFile? _file = await QB.content.getInfo(int.parse(id));
      print("_file: ${_file} id: ${id}");
      String? url = await QB.content.getPrivateURL(_file!.uid!);
      print("url: ${url} id: ${id}");
      Map map = {
        'file': _file,
        'url': url
      };
      return map;
    } catch (e) {
      print("attchurl error: ${e}");
      rethrow;
      // Some error occurred, look at the exception message for more details
    }
  }


  Future<List<QBMessageWrapper>> _wrapMessages(List<QBMessage?> messages) async {
    List<QBMessageWrapper> wrappedMessages = [];
    for (QBMessage? message in messages) {
      if (message == null) {
        break;
      }

      QBUser? sender = _getParticipantById(message.senderId);
      if (sender == null && message.senderId != null) {
        List<QBUser?> users = await getUsersByIds([message.senderId!]);
        if (users.length > 0) {
          sender = users[0];
          _saveParticipants(users);
        }
      }
      String senderName = sender?.fullName ?? sender?.login ?? "DELETED User";
      print(_localUserId);
      // test
      wrappedMessages.add(QBMessageWrapper(senderName, message, 82272762));

      // wrappedMessages.add(QBMessageWrapper(senderName, message, _pref!.getInt(AppConfig.QB_CURRENT_USERID)!));
    }
    return wrappedMessages;
  }

  Future<List<QBUser?>> getUsersByIds(List<int>? userIds) async {
    String? filterValue = userIds?.join(",");
    QBFilter filter = QBFilter();
    filter.field = QBUsersFilterFields.ID;
    filter.operator = QBUsersFilterOperators.IN;
    filter.value = filterValue;
    filter.type = QBUsersFilterTypes.STRING;

    return await QB.users.getUsers(filter: filter);
  }

  void _saveParticipants(List<QBUser?> users) {
    for (QBUser? user in users) {
      if (user?.id != null) {
        if (_participantsMap.containsKey(user?.id)) {
          _participantsMap.update(user!.id!, (value) => user);
        } else {
          _participantsMap[user!.id!] = user;
        }
      }
    }
  }

  QBUser? _getParticipantById(int? userId) {
    return _participantsMap.containsKey(userId) ? _participantsMap[userId] : null;
  }

  void _processIsTypingEvent(dynamic data) async {
    Map<String, Object> map = Map<String, Object>.from(data);
    Map<String?, Object?> payload =
    Map<String?, Object?>.from(map["payload"] as Map<Object?, Object?>);
    print("started typing");

    String dialogId = payload["dialogId"] as String;
    int userId = payload["userId"] as int;

    if (userId == _localUserId) {
      return;
    }
    // if (dialogId == this._dialogId) {
    //   var user = _getParticipantById(userId);
    //   if (user == null) {
    //     List<QBUser?> users = await getUsersByIds([userId]);
    //     if (users.length > 0) {
    //       _saveParticipants(users);
    //       user = users[0];
    //     }
    //   }
    //
    //   String? userName = user?.fullName ?? user?.login;
    //   if (userName == null || userName.isEmpty) {
    //     userName = "Unknown";
    //   }
    //   _typingUsersNames.remove(userName);
    //   _typingUsersNames.insert(0, userName);
    //   _typingStatusTimer?.cancelWithDelay(() {
    //     _typingUsersNames.remove(userName);
    //   });
    //   print("_typingUsersNames:$_typingUsersNames");
    // }

    var user = _getParticipantById(userId);
    if (user == null) {
      List<QBUser?> users = await getUsersByIds([userId]);
      if (users.length > 0) {
        _saveParticipants(users);
        user = users[0];
      }
    }

    String? userName = user?.fullName ?? user?.login;
    if (userName == null || userName.isEmpty) {
      userName = "Unknown";
    }
    _typingUsersNames.remove(userName);
    _typingUsersNames.insert(0, userName);
    _typingStatusTimer?.cancelWithDelay(() {
      _typingUsersNames.remove(userName);
    });
    print("_typingUsersNames:$_typingUsersNames");
    typingStream.sink.add(_typingUsersNames);
    notifyListeners();
  }

  void _processStopTypingEvent(dynamic data) {
    Map<String, Object> map = Map<String, Object>.from(data);
    Map<String?, Object?> payload =
    Map<String?, Object?>.from(map["payload"] as Map<Object?, Object?>);

    print("stopped typing");
    String dialogId = payload["dialogId"] as String;
    int userId = payload["userId"] as int;

    var user = _getParticipantById(userId);
    var userName = user?.fullName ?? user?.login;

    _typingUsersNames.remove(userName);
    typingStream.sink.add(_typingUsersNames);

    // if (dialogId == _dialogId) {
    // }
  }

  void unsubscribeNewMessage() {
    if (_newMessageSubscription != null) {
      _newMessageSubscription!.cancel();
      _newMessageSubscription = null;
      print("Unsubscribed: " + QBChatEvents.RECEIVED_NEW_MESSAGE);
    }
  }
  void markMessageRead() async {
    QBMessage qbMessage = QBMessage();
    qbMessage.dialogId = _dialogId;
    qbMessage.id = _messageId;
    qbMessage.senderId = (_localUserId == null) ? _pref!.getInt(AppConfig.QB_CURRENT_USERID) : _localUserId;

    try {
      await QB.chat.markMessageRead(qbMessage);
      hasMore = true;
      print("The message " + _messageId! + " was marked read");
    } on PlatformException catch (e) {
      print('mark message read error: ${e.message}');
    }
  }

  void markMessageDelivered() async {
    QBMessage qbMessage = QBMessage();
    qbMessage.dialogId = _dialogId;
    qbMessage.id = _messageId;
    qbMessage.senderId = (_localUserId == null) ? _pref!.getInt(AppConfig.QB_CURRENT_USERID) : _localUserId;

    try {
      await QB.chat.markMessageDelivered(qbMessage);
      hasMore = true;
      print("The message " + _messageId! + " was marked delivered");
    } on PlatformException catch (e) {
      print("message delivered error :${e.message}");
    }
  }

  void subscribeMessageDelivered() async {
    if (_deliveredMessageSubscription != null) {
      print("You already have a subscription for: " +
              QBChatEvents.MESSAGE_DELIVERED);
      return;
    }
    try {
      _deliveredMessageSubscription = await QB.chat
          .subscribeChatEvent(QBChatEvents.MESSAGE_DELIVERED, _processMessageDeliveredEvent, onErrorMethod: (error) {
        print("subscribe message delivered error :${error}");
      });
      print("Subscribed: " + QBChatEvents.MESSAGE_DELIVERED);
    } on PlatformException catch (e) {
      print("subscribe message delivered error :${e.message}");
    }
  }
  void _processMessageDeliveredEvent(dynamic data) {
    LinkedHashMap<dynamic, dynamic> messageStatusMap = data;
    Map<String, Object> payloadMap = Map<String, Object>.from(messageStatusMap["payload"]);

    String? dialogId = payloadMap["dialogId"] as String;
    String? messageId = payloadMap["messageId"] as String;
    int? userId = payloadMap["userId"] as int;

    if (_dialogId == dialogId) {
      for (QBMessageWrapper message in _wrappedMessageSet) {
        if (message.id == messageId) {
          message.qbMessage.deliveredIds?.add(userId);
          break;
        }
      }
      list = _wrappedMessageSet.toList();
      list.sort((first, second) => first.date.compareTo(second.date));
      _stream.sink.add(list);
    }
  }


  void subscribeMessageRead() async {
    if (_readMessageSubscription != null) {
      print("You already have a subscription for: " + QBChatEvents.MESSAGE_READ);
      return;
    }
    try {
      _readMessageSubscription =
      await QB.chat.subscribeChatEvent(QBChatEvents.MESSAGE_READ, _processMessageReadEvent, onErrorMethod: (error) {
        print("subscribeMessageRead error : $error");
      });

      print("Subscribed: " + QBChatEvents.MESSAGE_READ);
    } on PlatformException catch (e) {
      print("subscribeMessageRead error: ${e.message}");
    }
  }

  void _processMessageReadEvent(dynamic data) {
    LinkedHashMap<dynamic, dynamic> messageStatusHashMap = data;
    Map<String, Object> payloadMap = Map<String, Object>.from(messageStatusHashMap["payload"]);

    String? dialogId = payloadMap["dialogId"] as String;
    String? messageId = payloadMap["messageId"] as String;
    int? userId = payloadMap["userId"] as int;

    if (_dialogId == dialogId) {
      for (QBMessageWrapper message in _wrappedMessageSet) {
        if (message.id == messageId) {
          print("message read");
          message.qbMessage.readIds?.add(userId);
          break;
        }
      }
      list = _wrappedMessageSet.toList();
      list.sort((first, second) => first.date.compareTo(second.date));
      _stream.sink.add(list);    }
  }


  void unsubscribeDeliveredMessage() async {
    if (_deliveredMessageSubscription != null) {
      _deliveredMessageSubscription!.cancel();
      _deliveredMessageSubscription = null;
      print("Unsubscribed: " + QBChatEvents.MESSAGE_DELIVERED);
    }
  }

  void unsubscribeReadMessage() async {
    if (_readMessageSubscription != null) {
      _readMessageSubscription!.cancel();
      _readMessageSubscription = null;
      print("Unsubscribed: " + QBChatEvents.MESSAGE_READ);
    }
  }

  void sendIsTyping() async {
    try {
      await QB.chat.sendIsTyping(_dialogId!);
      print("Sent is typing for dialog: " + _dialogId!);
    } on PlatformException catch (e) {
      print("sendIsTyping: ${e.message}");
    }
  }

  void sendStoppedTyping() async {
    try {
      await QB.chat.sendStoppedTyping(_dialogId!);
      print("Sent stopped typing for dialog: " + _dialogId!);
    } on PlatformException catch (e) {
      print("Sent stopped typing error: ${e.message}");
    }
  }

  void subscribeUserTyping() async {
    if (_userTypingSubscription != null) {
      print("You already have a subscription for: " +
              QBChatEvents.USER_IS_TYPING);
      return;
    }
    try {
      _userTypingSubscription =
      await QB.chat.subscribeChatEvent(QBChatEvents.USER_IS_TYPING,
          _processIsTypingEvent);
      print("Subscribed: " + QBChatEvents.USER_IS_TYPING);
    } on PlatformException catch (e) {
      print("subscribeUserTyping error: ${e.message}");
    }
  }

  void subscribeUserStopTyping() async {
    if (_userStopTypingSubscription != null) {
      print("You already have a subscription for: " +
              QBChatEvents.USER_STOPPED_TYPING);
      return;
    }
    try {
      _userStopTypingSubscription = await QB.chat
          .subscribeChatEvent(QBChatEvents.USER_STOPPED_TYPING,
          _processStopTypingEvent);
      print("Subscribed: " + QBChatEvents.USER_STOPPED_TYPING);
    } on PlatformException catch (e) {
      print("subscribeUserStopTyping error: ${e.message}");
      // DialogUtils.showError(_scaffoldKey!.currentContext!, e);
    }
  }

  void unsubscribeUserTyping() async {
    if (_userTypingSubscription != null) {
      _userTypingSubscription!.cancel();
      _userTypingSubscription = null;
      print("Unsubscribed: " + QBChatEvents.USER_IS_TYPING);
    }
  }

  void unsubscribeUserStopTyping() async {
    if (_userStopTypingSubscription != null) {
      _userStopTypingSubscription!.cancel();
      _userStopTypingSubscription = null;
      print("Unsubscribed: " + QBChatEvents.USER_STOPPED_TYPING);
    }
  }

  void getDialogMessages() async {
    try {
      List<QBMessage?> messages = await QB.chat.getDialogMessages(_dialogId!);
      int countMessages = messages.length;

      if (countMessages > 0) {
        _messageId = messages[0]!.id;
      }

      print("Loaded messages: " + countMessages.toString());
    } on PlatformException catch (e) {
      print("getdialog message: ${e.message}");
      // DialogUtils.showError(_scaffoldKey!.currentContext!, e);
    }
  }

  void subscribeConnected() async {
    if (_connectedSubscription != null) {
      print("You already have a subscription for: " + QBChatEvents.CONNECTED);
      return;
    }
    try {
      _connectedSubscription =
      await QB.chat.subscribeChatEvent(QBChatEvents.CONNECTED, (data) {
        print("Received: " + QBChatEvents.CONNECTED);
      }, onErrorMethod: (error) {
        print("subscribeConnected error ${error}");
      });
      print("Subscribed: " + QBChatEvents.CONNECTED);
    } on PlatformException catch (e) {
      print("error: ${e.message}");
    }
  }

  void subscribeConnectionClosed() async {
    if (_connectionClosedSubscription != null) {
      print("You already have a subscription for: " +
              QBChatEvents.CONNECTION_CLOSED);
      return;
    }
    try {
      _connectionClosedSubscription = await QB.chat
          .subscribeChatEvent(QBChatEvents.CONNECTION_CLOSED, (data) {
        print("Received: " + QBChatEvents.CONNECTION_CLOSED);
      }, onErrorMethod: (error) {
        print(error);
      });
      print("Subscribed: " + QBChatEvents.CONNECTION_CLOSED);
    } on PlatformException catch (e) {
      print("error: ${e.message}");
    }
  }

  void subscribeReconnectionFailed() async {
    if (_reconnectionFailedSubscription != null) {
      print("You already have a subscription for: " +
              QBChatEvents.RECONNECTION_FAILED);
      return;
    }
    try {
      _reconnectionFailedSubscription = await QB.chat
          .subscribeChatEvent(QBChatEvents.RECONNECTION_FAILED, (data) {
        print("Received: " + QBChatEvents.RECONNECTION_FAILED);
      }, onErrorMethod: (error) {
        print("error: ${error}");
      });
      print("Subscribed: " + QBChatEvents.RECONNECTION_FAILED);
    } on PlatformException catch (e) {
      print("error: ${e.message}");
    }
  }

  void subscribeReconnectionSuccess() async {
    if (_reconnectionSuccessSubscription != null) {
      print("You already have a subscription for: " +
              QBChatEvents.RECONNECTION_SUCCESSFUL);
      return;
    }
    try {
      _reconnectionSuccessSubscription = await QB.chat
          .subscribeChatEvent(QBChatEvents.RECONNECTION_SUCCESSFUL, (data) {
        print("Received: " + QBChatEvents.RECONNECTION_SUCCESSFUL);
      }, onErrorMethod: (error) {
        print("error: ${error}");
      });
      print("Subscribed: " + QBChatEvents.RECONNECTION_SUCCESSFUL);
    } on PlatformException catch (e) {
      print("error: ${e.message}");
    }
  }

  void unsubscribeConnected() {
    if (_connectedSubscription != null) {
      _connectedSubscription!.cancel();
      _connectedSubscription = null;
      print("Unsubscribed: " + QBChatEvents.CONNECTED);
    }
  }

  void unsubscribeConnectionClosed() {
    if (_connectionClosedSubscription != null) {
      _connectionClosedSubscription!.cancel();
      _connectionClosedSubscription = null;
      print("Unsubscribed: " + QBChatEvents.CONNECTION_CLOSED);
    }
  }

  void unsubscribeReconnectionFailed() {
    if (_reconnectionFailedSubscription != null) {
      _reconnectionFailedSubscription!.cancel();
      _reconnectionFailedSubscription = null;
      print("Unsubscribed: " + QBChatEvents.RECONNECTION_FAILED);
    }
  }

  void unsubscribeReconnectionSuccess() {
    if (_reconnectionSuccessSubscription != null) {
      _reconnectionSuccessSubscription!.cancel();
      _reconnectionSuccessSubscription = null;
      print("Unsubscribed: " + QBChatEvents.RECONNECTION_SUCCESSFUL);
    }
  }

  Future downloadFile(String url, String filename) async {
    var httpClient = new HttpClient();
    try{
      var request = await httpClient.getUrl(Uri.parse(url));
      var response = await request.close();
      var bytes = await consolidateHttpClientResponseBytes(response);
      final dir = await getTemporaryDirectory();
      //(await getApplicationDocumentsDirectory()).path;
      File file = new File('${dir.path}/$filename');
      await file.writeAsBytes(bytes);
      print('downloaded file path = ${file.path}');
      return file;
    }catch(error){
      print('pdf downloading error = $error');
      return error;
    }
  }
  String makeErrorMessage(PlatformException? e) {
    String message = e?.message ?? "";
    String code = e?.code ?? "";
    return code + " : " + message;
  }

}

class TypingStatusTimer {
  static const int TIMER_DELAY = 30;
  Timer? _timer;

  cancelWithDelay(VoidCallback callback) {
    _timer?.cancel();
    _timer = Timer(Duration(seconds: TIMER_DELAY), callback);
  }

  cancel() {
    _timer?.cancel();
  }


}
