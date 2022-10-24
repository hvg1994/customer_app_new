import 'dart:async';
import 'dart:collection';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:quickblox_sdk/auth/module.dart';
import 'package:quickblox_sdk/chat/constants.dart';
import 'package:quickblox_sdk/mappers/qb_message_mapper.dart';
import 'package:quickblox_sdk/models/qb_attachment.dart';
import 'package:quickblox_sdk/models/qb_dialog.dart';
import 'package:quickblox_sdk/models/qb_filter.dart';
import 'package:quickblox_sdk/models/qb_message.dart';
import 'package:quickblox_sdk/models/qb_session.dart';
import 'package:quickblox_sdk/models/qb_sort.dart';
import 'package:quickblox_sdk/models/qb_user.dart';
import 'package:quickblox_sdk/quickblox_sdk.dart';
import 'package:quickblox_sdk/users/constants.dart';

import '../../repository/quick_blox_repository/message_wrapper.dart';
import '../../utils/app_config.dart';

class QuickBloxService extends ChangeNotifier{

  final _pref = AppConfig().preferences;

  int? currentUser;
  int? _localUserId;
  String? _dialogId;
  bool hasMore = false;
  QBDialog? _dialog;
  bool _isNewChat = false;
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

  GlobalKey<ScaffoldState>? _scaffoldKey;
  QuickBloxService({GlobalKey<ScaffoldState>? scaffoldKey}){
    if(scaffoldKey != null){
      _scaffoldKey = scaffoldKey;
    }
    subscribe();
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

  getSession() async{
    bool? _isExpired;
    int? expiry = _pref!.getInt(AppConfig.GET_QB_SESSION);
    if(DateTime.now().isAfter(DateTime.fromMillisecondsSinceEpoch(expiry!))){
      _isExpired = true;
    }
    else{
      _isExpired = false;
    }
    return _isExpired;
  }
  // 1st login
  Future<void> login(String userName, {String? password}) async {
    try {
      QBLoginResult result = await QB.auth.login(userName, (password == null) ? AppConfig.DEFAULT_PASSWORD : password);

      QBUser? qbUser = result.qbUser;
      currentUser = qbUser?.id ?? -1;
      _localUserId = qbUser?.id ?? -1;
      connect(qbUser!.id!, (password == null) ? AppConfig.DEFAULT_PASSWORD : password);

      _pref!.setInt(AppConfig.QB_CURRENT_USERID, currentUser!);
      QBSession? _qbSession = result.qbSession;
      qbSession = _qbSession;
      _pref!.setInt(AppConfig.GET_QB_SESSION, DateTime.parse(_qbSession!.expirationDate!).millisecondsSinceEpoch);
      _qbSession.applicationId = int.parse(AppConfig.QB_APP_ID);
      print("login success..");
    } on PlatformException catch (e) {
      print('login catch error: ${e.message}');
    }
  }

  Future<void> logout() async {
    try {
      await QB.auth.logout();
      // SnackBarUtils.showResult(_scaffoldKey!, "Logout success");
    } on PlatformException catch (e) {
      print("logout error ${e.message}");
      // DialogUtils.showError(_scaffoldKey!.currentContext!, e);
    }
  }
  //2nd connect
  // PASS AppConfig.DEFAULT_PASSWORD IF PASSWORD NOT THERE
  void connect(int userId, String password) async {
    try {
      await QB.chat.connect(userId, password);
      print('The chat was connected');
      // SnackBarUtils.showResult(_scaffoldKey!, "The chat was connected");
    } on PlatformException catch (e) {
      print("connect error ${e.message}");
      // DialogUtils.showError(_scaffoldKey!.currentContext!, e);
    }
  }

  void disconnect() async {
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
    try {
      bool ? connected = await QB.chat.isConnected();
      print("isConnected=> ${connected}");
    } on PlatformException catch (e) {
      print("isConnected error ${e.message}");
    }
  }

  joinDialog(String dialogId) async {
    try {
      await QB.chat.joinDialog(dialogId);
      print("The dialog $_dialogId was joined");
      // SnackBarUtils.showResult(
      //     _scaffoldKey!, "The dialog $_dialogId was joined");
      loadMessages(dialogId);
    } on PlatformException catch (e) {
      print("join room error: ${e.message}");
      // DialogUtils.showError(_scaffoldKey!.currentContext!, e);
    }
  }

  void sendMessage(String chatRoomId, {String? message, List<QBAttachment>? attachments,}) async {
    // String messageBody =
    //     "Hello from flutter!" + "\n From user: " + LOGGED_USER_ID.toString();

    try {
    //   Map<String, String> properties = Map();
    //   properties["testProperty1"] = "testPropertyValue1";
    //   properties["testProperty2"] = "testPropertyValue2";
    //   properties["testProperty3"] = "testPropertyValue3";

      await QB.chat.sendMessage(chatRoomId,
          attachments: attachments,
          body: message, saveToHistory: true,);
      print("The message was sent to dialog: $_dialogId");
      // SnackBarUtils.showResult(
      //     _scaffoldKey!, "The message was sent to dialog: $_dialogId");
    } on PlatformException catch (e) {
      print("send message error: ${e.toString()}");
      // DialogUtils.showError(_scaffoldKey!.currentContext!, e);
    }
  }

  Future<void> loadMessages(String dialogId) async {
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
      print('sink added:$list');
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
    _wrappedMessageSet.addAll(await _wrapMessages([message]));
    list = _wrappedMessageSet.toList();
    list.sort((first, second) => first.date.compareTo(second.date));
    _stream.sink.add(list);
    hasMore = true;
    print('sink added:$list');
    notifyListeners();
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
      wrappedMessages.add(QBMessageWrapper(senderName, message, _pref!.getInt(AppConfig.QB_CURRENT_USERID)!));
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
    qbMessage.senderId = (currentUser == null) ? _pref!.getInt(AppConfig.QB_CURRENT_USERID) : currentUser;

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
    qbMessage.senderId = (currentUser == null) ? _pref!.getInt(AppConfig.QB_CURRENT_USERID) : currentUser;

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
