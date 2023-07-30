/*
********* Ticket List **************

* Api used:
* Get Ticket List


 */

import 'package:flutter/material.dart';
import 'package:gwc_customer/model/uvdesk_model/get_ticket_threads_list_model.dart';
import 'package:gwc_customer/screens/uvdesk/ticket_details_screen.dart';
import 'package:http/http.dart' as http;
import 'package:sizer/sizer.dart';

import '../../model/error_model.dart';
import '../../model/uvdesk_model/get_ticket_list_model.dart';
import '../../repository/api_service.dart';
import '../../repository/uvdesk_repository/uvdesk_repo.dart';
import '../../services/uvdesk_service/uv_desk_service.dart';
import '../../utils/app_config.dart';
import '../../widgets/constants.dart';
import '../../widgets/widgets.dart';
import 'create_ticket.dart';



class TicketListScreen extends StatefulWidget {
  const TicketListScreen({Key? key}) : super(key: key);

  @override
  State<TicketListScreen> createState() => _TicketListScreenState();
}

class _TicketListScreenState extends State<TicketListScreen> {

  late UvDeskService _uvDeskService = UvDeskService(uvDeskRepo: repository);
  
  bool isLoading = false;

  final ScrollController _scrollController = ScrollController();

  final _pref = AppConfig().preferences;

  late String email = _pref?.getString(AppConfig.User_Email) ?? '';

  // String customerId = "1795084";
  String customerId = "3229";


  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    // getTickets();
  }

  // getTickets() async{
  //   callProgressStateOnBuild(true);
  //   final res = await _uvDeskService.getTicketListService();
  //
  //   if(res.runtimeType == ErrorModel){
  //
  //   }
  // }
  
  callProgressStateOnBuild(bool value){
    Future.delayed(Duration.zero).whenComplete(() {
      setState(() {
        isLoading = value;
      });
    });
  }
  
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 2.w, vertical: 1.h),
            child: buildAppBar(
                    (){},
                customAction: true,
              actions: [
                GestureDetector(
                  child: Icon(
                    Icons.add,
                    color: gHintTextColor,
                  ),
                  onTap: (){
                    Navigator.push(context, MaterialPageRoute(
                        builder: (_) => CreateTicket()
                    )).then((value) {
                      if(true){
                        setState(() {

                        });
                      }
                    });
                  },
                )
              ]
            ),
          ),
          Expanded(
              child: showTabsView(context)
          )
        ],
      ),
    );
  }

  showTabsView(BuildContext context){
    return DefaultTabController(
        length: 4,
        child: Column(
          children: [
            TabBar(
                labelColor: eUser().userFieldLabelColor,
                unselectedLabelColor: eUser().userTextFieldColor,
                padding: EdgeInsets.symmetric(horizontal: 3.w),
                isScrollable: true,
                indicatorColor: gsecondaryColor,
                labelStyle: TextStyle(
                    fontFamily: kFontMedium,
                    color: gPrimaryColor,
                    fontSize: 12.sp),
                unselectedLabelStyle: TextStyle(
                    fontFamily: kFontBook,
                    color: gHintTextColor,
                    fontSize: 10.sp),
                labelPadding: EdgeInsets.only(
                    right: 10.w, left: 2.w, top: 1.h, bottom: 1.h),
                indicatorPadding: EdgeInsets.only(right: 7.w),
                tabs: const [
                  Text('Open'),
                  Text('Answered'),
                  Text('Resolved'),
                  Text('Closed'),
                ]),
            const SizedBox(
              height: 12,
            ),
            Expanded(
                child: TabBarView(
                  children: [
                    showRespectiveTabView(context, TicketStatusType.open),
                    showRespectiveTabView(context, TicketStatusType.answered),
                    showRespectiveTabView(context, TicketStatusType.resolved),
                    showRespectiveTabView(context, TicketStatusType.closed),
                  ],))
          ],
        )
    );
  }

  showRespectiveTabView(BuildContext context, TicketStatusType type){
    return FutureBuilder(
      // future: _uvDeskService.getTicketsByCustomerIdService(customerId, statusId),
      future: _uvDeskService.getTicketListService(email),
      builder: (_, snap){
        if(snap.connectionState == ConnectionState.waiting){
          return Center(
            child: buildCircularIndicator(),
          );
        }
        else if(snap.connectionState == ConnectionState.done){
          if(snap.hasData){
            print(snap.data.runtimeType);
            if(snap.data.runtimeType == ErrorModel){
              ErrorModel model = snap.data as ErrorModel;
              return Padding(
                padding: EdgeInsets.symmetric(vertical: 15.h),
                child: Text(model.message ?? ''),
              );
            }
            else{
              GetTicketListModel _model = snap.data as GetTicketListModel;
              return buildUI(context, _model, type);
            }
          }
          else if(snap.hasError){
            return Padding(
              padding: EdgeInsets.symmetric(vertical: 15.h),
              child: Image(
                image: const AssetImage("assets/images/Group 5294.png"),
                height: 25.h,
              ),
            );
          }
        }
        return SizedBox();
      },
    );
  }

  Widget buildUI(BuildContext context, GetTicketListModel model, TicketStatusType type) {
    Labels? labels = model.labels;
    List<Tickets> tickets = model.tickets?.where((element) => element.status!.name == type.name) .toList() ?? [];
    int _totalLabels = -1;

    if(labels != null){
      if(labels.predefind != null){
        _totalLabels = labels.predefind?.all?? -1;
      }
    }

    if(tickets.isEmpty && (_totalLabels == 0)){
      return Center(
        child: Text("Click On '+' Icon to Raise a Ticket",
        style: TextStyle(
          fontSize: headingFont,
          fontFamily: kFontBold
        ),),
      );
    }
    else{
      return showList(tickets, type);
    }
  }
  
  showList(List<Tickets> tickets, TicketStatusType type){
    if(tickets.isEmpty){
      return const Center(
        child: Image(
          image: AssetImage("assets/images/no_data_found.png"),
          fit: BoxFit.scaleDown,
        ),
      );
    }
    else{
      return ListView.separated(
        shrinkWrap: true,
        controller: _scrollController,
        itemCount: tickets.length,
        itemBuilder: (context, index) {
          Tickets currentTicket = tickets[index];
          return Material(
            child: InkWell(
              onTap: () {
                _onPressTicket(currentTicket);
              },
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 12),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          currentTicket.id.toString(),
                          style: otherText9(),
                        ),
                        Text(
                          currentTicket.formatedCreatedAt ?? '',
                          style: otherText9(),
                        ),
                      ],
                    ),
                    SizedBox(height: 0.3.h),
                    (currentTicket.subject != null)
                        ? Text(
                      currentTicket.subject ?? '',
                      style: listMainHeading(),
                    )
                        : const SizedBox(),
                    // SizedBox(height: 0.3.h),
                    // Row(
                    //   crossAxisAlignment: CrossAxisAlignment.start,
                    //   children: [
                    //     Text(
                    //       "Replied By : ",
                    //       style: otherText9(),
                    //     ),
                    //     Expanded(
                    //       child: Text(
                    //         currentTicket.lastThreadUserType ?? "",
                    //         style: listSubHeading(),
                    //       ),
                    //     ),
                    //   ],
                    // ),
                    // SizedBox(height: 0.3.h),
                    // Text(
                    //   currentTicket.lastReplyAgentTime ?? '',
                    //   style: otherText9(),
                    // ),
                    SizedBox(height: 0.5.h),
                    Row(
                      children: [
                        Text(
                          currentTicket.customer?.name ?? '',
                          style: listSubHeading(),
                          maxLines: 2,
                          softWrap: true,
                          overflow: TextOverflow.ellipsis,
                        ),
                        SizedBox(width: 3.w),
                        currentTicket.status?.name == "open"
                            ? Image(
                          image: const AssetImage(
                              "assets/images/dashboard_stages/open_ticket.png"),
                          height: 2.h,
                        )
                            : currentTicket.status?.name == "resolved"
                            ? Image(
                          image: const AssetImage(
                              "assets/images/dashboard_stages/resolved.png"),
                          height: 2.h,
                        )
                            : currentTicket.status?.name == "closed"
                            ? Image(
                          image: const AssetImage(
                              "assets/images/dashboard_stages/closed.png"),
                          height: 2.h,
                        )
                            : const SizedBox(),
                        SizedBox(width: 1.w),
                        Text(
                          currentTicket.status?.name ?? '',
                          style: otherText(),
                        ),
                        SizedBox(width: 2.w),
                        Icon(
                          Icons.circle,
                          size: 12,
                          color: currentTicket.priority?.name == "Low"
                              ? kBottomSheetHeadGreen
                              : currentTicket.priority?.name == "High"
                              ? kNumberCircleRed
                              : gWhiteColor,
                          // AppConfig.fromHex(
                          //     currentTicket.priority!.color ?? ''),
                        ),
                      ],
                    ),
                    // Container(
                    //   height: 1,
                    //   margin: EdgeInsets.symmetric(vertical: 1.5.h),
                    //   color: Colors.grey.withOpacity(0.3),
                    // ),
                  ],
                ),
              )
              // child: Container(
              //   padding: const EdgeInsets.symmetric(horizontal: 12),
              //   child: Column(
              //     mainAxisAlignment: MainAxisAlignment.start,
              //     crossAxisAlignment: CrossAxisAlignment.start,
              //     children: [
              //       const SizedBox(
              //         height: 12,
              //       ),
              //       Text(
              //         currentTicket.subject ?? '',
              //         style: TextStyle(
              //           fontSize: 12.sp,
              //           fontFamily: kFontBold,
              //         ),
              //         maxLines: 2,
              //         softWrap: true,
              //         overflow: TextOverflow.ellipsis,
              //       ),
              //       const SizedBox(
              //         height: 6,
              //       ),
              //       Text((currentTicket.group != null)
              //           ? currentTicket.group!.name ?? ''
              //           : ' '),
              //       const SizedBox(
              //         height: 2,
              //       ),
              //       Row(
              //         mainAxisAlignment: MainAxisAlignment.spaceBetween,
              //         children: [
              //           Text(currentTicket.formatedCreatedAt ?? ''),
              //           Row(
              //             children: [
              //               Icon(
              //                 Icons.circle,
              //                 size: 12,
              //                 color: AppConfig.fromHex(
              //                     currentTicket.priority!.color ?? ''),
              //               ),
              //               Icon(
              //                 (currentTicket.isStarred != null || currentTicket.isStarred == 'true')
              //                     ? Icons.star_outlined
              //                     : Icons.star_border,
              //                 size: 24,
              //                 color: (currentTicket.isStarred != null || currentTicket.isStarred == 'true')
              //                     ? Colors.yellow
              //                     : Colors.grey,
              //               ),
              //               // Icon(
              //               //   Utils.getSourceIcon(currentTicket.source),
              //               //   size: 24,
              //               //   color: Colors.grey,
              //               // )
              //             ],
              //           )
              //         ],
              //       ),
              //       const SizedBox(
              //         height: 8,
              //       )
              //     ],
              //   ),
              // ),
            ),
          );
        },
        separatorBuilder: (BuildContext context, int index) {
          return Padding(
            padding: const EdgeInsets.all(8.0),
            child: const Divider(
              height: 1,
              color: Colors.grey,
            ),
          );
        },
      );
    }
  }


  final UvDeskRepo repository = UvDeskRepo(
    apiClient: ApiClient(
      httpClient: http.Client(),
    ),
  );

  _onPressTicket(Tickets tickets) {
    Navigator.push(context, MaterialPageRoute(builder: (_) => TicketChatScreen(
      userName: tickets.customer?.name ?? '',
      thumbNail: tickets.customer?.smallThumbnail ?? '',
      ticketId: tickets.id.toString() ?? "",
      subject: tickets.subject ?? '',
      email: tickets.customer?.email ?? '',
      ticketStatus: tickets.status?.id ?? -1
    )));
  }
}
