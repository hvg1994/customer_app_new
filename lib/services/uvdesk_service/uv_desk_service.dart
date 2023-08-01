import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:http/http.dart';
import '../../model/uvdesk_model/get_ticket_list_model.dart';
import '../../repository/uvdesk_repository/uvdesk_repo.dart';

class UvDeskService extends ChangeNotifier{
  late final UvDeskRepo uvDeskRepo;

  int perPage = 10;
  int start = 0;

  bool hasMore = false;

  List<Tickets> _allTickets = [];
  List<Tickets> get allTickets => _allTickets;

  List<Tickets> _fetchedTickets = [];
  List<Tickets> get fetchedTickets => _fetchedTickets;

  setAllTickets(List<Tickets> tickets){
    _allTickets.addAll(tickets);
  }

  getLoadedTickets(){
    if(_fetchedTickets.length != _allTickets.length){
      if(start+perPage >= _allTickets.length){
        _fetchedTickets.addAll(_allTickets.getRange(start, _allTickets.length));
        start = start + (_allTickets.length-start);
      }
      else{
        _fetchedTickets.addAll(_allTickets.getRange(start, perPage));
        start = start + perPage;
      }
      hasMore = true;
    }
    else{
      hasMore = false;
    }
    notifyListeners();
  }


  UvDeskService({required this.uvDeskRepo});

  Future getTicketListService(String email, int index) async{
    return await uvDeskRepo.getTicketListRepo(email, index);
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