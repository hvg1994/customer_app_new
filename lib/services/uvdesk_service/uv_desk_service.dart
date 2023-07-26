import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:http/http.dart';
import '../../repository/uvdesk_repository/uvdesk_repo.dart';

class UvDeskService extends ChangeNotifier{
  late final UvDeskRepo uvDeskRepo;

  UvDeskService({required this.uvDeskRepo})
      : assert(uvDeskRepo != null);

  Future getTicketListService() async{
    return await uvDeskRepo.getTicketListRepo();
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

///  1|2|3|4|5|6 for open|pending|resolved|closed|Spam|Answered
enum TicketStatusType {
  open,pending,resolved,closed,Spam,Answered
}

enum ThreadType{
  reply,forward,note
}

enum ActAsType{
  customer,agent
}