import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:http/http.dart';
import '../../repository/uvdesk_repository/uvdesk_repo.dart';

class UvDeskService extends ChangeNotifier{
  late final UvDeskRepo uvDeskRepo;

  UvDeskService({required this.uvDeskRepo})
      : assert(uvDeskRepo != null);

  Future getTicketListService(String email) async{
    return await uvDeskRepo.getTicketListRepo(email);
  }

  Future getTicketDetailsByIdService(String id) async{
    return await uvDeskRepo.getTicketDetailsByIdRepo(id);
  }

  Future createTicketService(Map data, {List<File>? attachments}) async{
    return await uvDeskRepo.createTicketRepo(data, attachments: attachments);
  }

  Future getTicketsByCustomerIdService(String customerId, String statusId) async{
    return await uvDeskRepo.getTicketsByCustomerIdRepo(customerId, statusId);
  }

  Future sendReplyService(String ticketId, Map data, {List<File>? attachments}) async{
    return await uvDeskRepo.sendReplyRepo(ticketId, data, attachments: attachments);
  }

  Future reOpenTicketService(String ticketId) async{
    return await uvDeskRepo.reOpenTicketRepo(ticketId);
  }

}

///  1|2|3|4|5|6 for open,pending,answered,resolved,closed,spam
enum TicketStatusType {
  open,pending,answered,resolved,closed,spam
}

enum ThreadType{
  reply,forward,note
}

/// when we need to pass from customer than need to pass customer and also need to pass ActAsEmail
enum ActAsType{
  customer,agent
}