import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
//
// class TableViewUI extends StatefulWidget {
//   const TableViewUI({Key? key}) : super(key: key);
//
//   @override
//   State<TableViewUI> createState() => _TableViewUIState();
// }
//
// class _TableViewUIState extends State<TableViewUI> {
//
//   static const List dt = [
//   {
//   "id": "1",
//   "name": "Aaron Miles",
//   "email": "aaron@mailinator.com",
//   "role": "member"
// },
// {
// "id": "2",
// "name": "Aishwarya Naik",
// "email": "aishwarya@mailinator.com",
// "role": "member"
// },
// {
// "id": "3",
// "name": "Arvind Kumar",
// "email": "arvind@mailinator.com",
// "role": "admin"
// },
// {
// "id": "4",
// "name": "Caterina Binotto",
// "email": "caterina@mailinator.com",
// "role": "member"
// },
// {
// "id": "5",
// "name": "Chetan Kumar",
// "email": "chetan@mailinator.com",
// "role": "member"
// },
// {
// "id": "6",
// "name": "Jim McClain",
// "email": "jim@mailinator.com",
// "role": "member"
// },
// {
// "id": "7",
// "name": "Mahaveer Singh",
// "email": "mahaveer@mailinator.com",
// "role": "member"
// },
// {
// "id": "8",
// "name": "Rahul Jain",
// "email": "rahul@mailinator.com",
// "role": "admin"
// },
// {
// "id": "9",
// "name": "Rizan Khan",
// "email": "rizan@mailinator.com",
// "role": "member"
// },
// {
// "id": "10",
// "name": "Sarah Potter",
// "email": "sarah@mailinator.com",
// "role": "admin"
// },
// {
// "id": "11",
// "name": "Keshav Muddaiah",
// "email": "keshav@mailinator.com",
// "role": "member"
// }
//
// ];
//
//   List<TableData> lst = [];
//
//   //PaginatedList
//   List<TableData> plst = [];
//
//   @override
//   void initState() {
//     // TODO: implement initState
//     super.initState();
//     dt.forEach((element) {
//       lst.add(TableData.fromJson(element));
//     });
//     dt.forEach((element) {
//       lst.add(TableData.fromJson(element));
//     });
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       backgroundColor: Color(0xFFFAFAFA),
//       body: Container(
//         constraints: BoxConstraints(maxWidth: 600),
//         decoration: BoxDecoration(
//           color: Colors.white,
//           borderRadius: BorderRadius.circular(12)
//         ),
//         child: SingleChildScrollView(
//           scrollDirection: Axis.vertical,
//           child: SingleChildScrollView(
//             scrollDirection: Axis.horizontal,
//             child: DataTable(
//               columns: [
//                 DataColumn(label: Checkbox(
//                   value: false,
//                   onChanged: (value){},
//                 )),
//                 DataColumn(label: Text("Name")),
//                 DataColumn(label: Text("Email")),
//                 DataColumn(label: Text("Role")),
//                 DataColumn(label: Text("Action")),
//               ],
//               rows: [
//                 ...lst.map((e) {
//                   return DataRow(cells: [
//
//                     DataCell(Checkbox(
//                       value: false,
//                       onChanged: (value){},
//                     )),
//                     DataCell(Text(e.name ?? '')),
//                     DataCell(Text(e.email ?? '')),
//                     DataCell(Text(e.role ?? '')),
//                     DataCell(Row(
//                       mainAxisSize: MainAxisSize.min,
//                       children: [
//                         IconButton(
//                             onPressed: (){},
//                             icon: Icon(Icons.edit)
//                         ),
//                         IconButton(onPressed: (){},
//                             icon: Icon(Icons.delete, color: Colors.red,)
//                         )
//                       ],
//                     ))
//                   ]);
//                 })
//
//               ],
//             ),
//           ),
//         ),
//       ),
//     );
//   }
// }
//
// class TableData{
//   String? id;
//   String? name;
//   String? email;
//   String? role;
//   TableData({required this.id,
//     required this.name,
//     required this.email,
//     required this.role
//   });
//
//   TableData.fromJson(Map map){
//     id = map['id'];
//     name = map['name'];
//     email = map['email'];
//     role = map['role'];
//   }
// }


class CustomPaginationTable extends StatefulWidget {
  @override
  _CustomPaginationTableState createState() => _CustomPaginationTableState();
}

class _CustomPaginationTableState extends State<CustomPaginationTable> {
  static const List dt = [
    {
      "id": "1",
      "name": "Aaron Miles",
      "email": "aaron@mailinator.com",
      "role": "member"
    },
    {
      "id": "2",
      "name": "Aishwarya Naik",
      "email": "aishwarya@mailinator.com",
      "role": "member"
    },
    {
      "id": "3",
      "name": "Arvind Kumar",
      "email": "arvind@mailinator.com",
      "role": "admin"
    },
    {
      "id": "4",
      "name": "Caterina Binotto",
      "email": "caterina@mailinator.com",
      "role": "member"
    },
    {
      "id": "5",
      "name": "Chetan Kumar",
      "email": "chetan@mailinator.com",
      "role": "member"
    },
    {
      "id": "6",
      "name": "Jim McClain",
      "email": "jim@mailinator.com",
      "role": "member"
    },
    {
      "id": "7",
      "name": "Mahaveer Singh",
      "email": "mahaveer@mailinator.com",
      "role": "member"
    },
    {
      "id": "8",
      "name": "Rahul Jain",
      "email": "rahul@mailinator.com",
      "role": "admin"
    },
    {
      "id": "9",
      "name": "Rizan Khan",
      "email": "rizan@mailinator.com",
      "role": "member"
    },
    {
      "id": "10",
      "name": "Sarah Potter",
      "email": "sarah@mailinator.com",
      "role": "admin"
    },
    {
      "id": "11",
      "name": "Keshav Muddaiah",
      "email": "keshav@mailinator.com",
      "role": "member"
    }

  ];

  final List<Entry> allEntries = [
    // Populate this list with your data entries
  ];

  List<Entry> displayedEntries = [];
  String searchQuery = '';
  bool selectAll = false;
  List<Entry> selectedEntries = [];

  int currentPage = 1;
  final int entriesPerPage = 10;

  @override
  void initState() {
    super.initState();
    dt.forEach((element) {
      allEntries.add(Entry.fromJson(element));
    });
    dt.forEach((element) {
      allEntries.add(Entry.fromJson(element));
    });
    dt.forEach((element) {
      allEntries.add(Entry.fromJson(element));
    });
    dt.forEach((element) {
      allEntries.add(Entry.fromJson(element));
    });
    dt.forEach((element) {
      allEntries.add(Entry.fromJson(element));
    });
    dt.forEach((element) {
      allEntries.add(Entry.fromJson(element));
    });
    dt.forEach((element) {
      allEntries.add(Entry.fromJson(element));
    });
    dt.forEach((element) {
      allEntries.add(Entry.fromJson(element));
    });
    dt.forEach((element) {
      allEntries.add(Entry.fromJson(element));
    });
    dt.forEach((element) {
      allEntries.add(Entry.fromJson(element));
    });
    dt.forEach((element) {
      allEntries.add(Entry.fromJson(element));
    });
    dt.forEach((element) {
      allEntries.add(Entry.fromJson(element));
    });
    dt.forEach((element) {
      allEntries.add(Entry.fromJson(element));
    });
    dt.forEach((element) {
      allEntries.add(Entry.fromJson(element));
    });
    dt.forEach((element) {
      allEntries.add(Entry.fromJson(element));
    });
    updateDisplayedEntries();
  }

  void updateDisplayedEntries() {
    setState(() {
      final filteredEntries = searchQuery.isEmpty
          ? allEntries
          : allEntries
          .where((entry) =>
          entry.name!.toLowerCase().contains(searchQuery.toLowerCase()))
          .toList();

      final totalPages = (filteredEntries.length / entriesPerPage).ceil();
      currentPage = currentPage.clamp(1, totalPages);

      final startIndex = (currentPage - 1) * entriesPerPage;
      final endIndex = startIndex + entriesPerPage;

      // final currentPageIndex = currentPage - 1;
      //
      // // Calculate the start and end page numbers to display
      // startPage = currentPageIndex - 2;
      // endPage = currentPageIndex + 2;
      //
      // // Adjust startPage and endPage if they go beyond the valid range
      // if (startPage < 0) {
      //   endPage += (startPage.abs()); // Increase endPage by the absolute value of startPage
      //   startPage = 0;
      // }
      // else if (endPage >= totalPages) {
      //   print("start page: $startPage end=> $endPage totla: $totalPages");
      //
      //   startPage -= (endPage - (totalPages - 1)); // Adjust startPage to fit within totalPages
      //   print("str=> $startPage");
      //   endPage = totalPages - 1;
      // }

      displayedEntries = filteredEntries.sublist(
          startIndex.clamp(0, filteredEntries.length),
          endIndex.clamp(0, filteredEntries.length));


      if (currentPage > 1 && displayedEntries.isEmpty) {
        currentPage--;
        updateDisplayedEntries();
      }

      print("start=> $startPage && endPage=> $endPage");


    });
  }

  void goToPage(int page) {
    if (page == currentPage) return;

    setState(() {
      currentPage = page;
      updateDisplayedEntries();
    });
  }

  void goToFirstPage() {
    goToPage(1);
  }

  void goToPreviousPage() {
    if (currentPage > 1) {
      goToPage(currentPage - 1);
    }
  }

  void goToNextPage() {
    final totalPages = (allEntries.length / entriesPerPage).ceil();
    if (currentPage < totalPages) {
      goToPage(currentPage + 1);
    }
  }

  void goToLastPage() {
    final totalPages = (allEntries.length / entriesPerPage).ceil();
    goToPage(totalPages);
  }

  void onSearch(String query) {
    setState(() {
      searchQuery = query;
      currentPage = 1;
      updateDisplayedEntries();
    });
  }

  void toggleSelectAll(bool value) {
    setState(() {
      selectAll = value;
      selectedEntries = selectAll ? List.from(displayedEntries) : [];
    });
  }

  void toggleEntrySelection(Entry entry) {
    setState(() {
      if (selectedEntries.contains(entry)) {
        selectedEntries.remove(entry);
      } else {
        selectedEntries.add(entry);
      }
    });
  }

  void deleteSelectedEntries() {
    setState(() {
      allEntries.removeWhere((entry) => selectedEntries.contains(entry));
      selectedEntries.clear();
      updateDisplayedEntries();
    });
  }

int startPage = 0;
  int endPage = 0;

  @override
  Widget build(BuildContext context) {
    // final totalPages = (allEntries.length / entriesPerPage).ceil();
    // final currentPageIndex = currentPage - 1;
    //
    // // Calculate the start and end page numbers to display
    // int startPage = currentPageIndex - 2;
    // int endPage = currentPageIndex + 2;
    //
    // // Adjust startPage and endPage if they go beyond the valid range
    // if (startPage < 0) {
    //   endPage += (startPage.abs()); // Increase endPage by the absolute value of startPage
    //   startPage = 0;
    // }
    // if (endPage >= totalPages) {
    //   startPage -= (endPage - (totalPages - 1)); // Adjust startPage to fit within totalPages
    //   endPage = totalPages - 1;
    // }

    final filteredEntries = searchQuery.isEmpty
        ? allEntries
        : allEntries
        .where((entry) => entry.name!.toLowerCase().contains(searchQuery.toLowerCase()))
        .toList();

    final filteredTotalPages = (filteredEntries.length / entriesPerPage).ceil();
    final currentPageIndex = currentPage - 1;

    // // Calculate the start and end page numbers to display
    // int startPage = currentPageIndex - 2;
    // int endPage = currentPageIndex + 2;
    //
    // // Adjust startPage and endPage if they go beyond the valid range
    // if (startPage < 0) {
    //   endPage += (startPage.abs()); // Increase endPage by the absolute value of startPage
    //   startPage = 0;
    // }
    // if (endPage >= filteredTotalPages) {
    //   startPage -= (endPage - (filteredTotalPages - 1)); // Adjust startPage to fit within filteredTotalPages
    //   endPage = filteredTotalPages - 1;
    // }

    int startPage = (currentPageIndex - 2).clamp(0, filteredTotalPages - 1);
    int endPage = (currentPageIndex + 2).clamp(0, filteredTotalPages - 1);

    // Adjust startPage and endPage if there are fewer pages than needed
    if (filteredTotalPages >= 5 && endPage - startPage < 4) {
      if (startPage == 0) {
        endPage = 4;
      } else if (endPage == filteredTotalPages - 1) {
        startPage = filteredTotalPages - 5;
      }
    }
    return ListView(
      children: [
        // Column titles widget
        Row(
          children: [
            SizedBox(width: 40), // Empty space for checkbox column
            SizedBox(width: 150, child: Text('Title', style: TextStyle(fontWeight: FontWeight.bold))),
            // Add other column titles here
          ],
        ),

        // Search bar widget
        Padding(
          padding: EdgeInsets.all(10),
          child: TextFormField(
            onChanged: onSearch,
            decoration: InputDecoration(
              labelText: 'Search',
              prefixIcon: Icon(Icons.search),
            ),
          ),
        ),

        // Table entries widget with checkboxes and edit/delete options
        SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: DataTable(
            columns: [
              // DataColumn(label: SizedBox(width: 40)), // Checkbox column
              DataColumn(label: Text("Name")),
              DataColumn(label: Text("Email")),
              DataColumn(label: Text("Role")),
              DataColumn(label: Align(
                alignment: Alignment.center,
                  child: Text("Action"))),
              // Add other columns here
            ],
            rows: displayedEntries.map((entry) {
              final isSelected = selectedEntries.contains(entry);
              return DataRow(
                selected: isSelected,
                onSelectChanged: (_) => toggleEntrySelection(entry),
                cells: [
                  // DataCell(Checkbox(
                  //   value: isSelected,
                  //   onChanged: (_) => toggleEntrySelection(entry),
                  // )),
                  DataCell(Text(entry.name ?? '')),
                  DataCell(Text(entry.email ?? '')),
                  DataCell(Text(entry.role ?? '')),
                  DataCell(Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      IconButton(
                          onPressed: (){},
                          icon: Icon(Icons.edit)
                      ),
                      IconButton(onPressed: (){},
                          icon: Icon(Icons.delete, color: Colors.red,)
                      )
                    ],
                  ))
                  // Add other cells here
                ],
              );
            }).toList(),
          ),
        ),

        // Pagination buttons widget
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            IconButton(
              icon: Icon(Icons.first_page),
              onPressed: goToFirstPage,
            ),
            IconButton(
              icon: Icon(Icons.chevron_left),
              onPressed: goToPreviousPage,
            ),
            // Text('$currentPage'),
            if(!kIsWeb)
              for (int i = startPage; i <= endPage; i++)
                GestureDetector(
                  onTap: () => goToPage(i + 1),
                  child: Container(
                    padding: EdgeInsets.all(5),
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: i + 1 == currentPage ? Colors.blue : Colors.transparent
                    ),
                    child: Text(
                      (i + 1).toString(),
                      style: TextStyle(
                        color: i + 1 == currentPage ? Colors.white : Colors.black,
                        fontWeight: i + 1 == currentPage ? FontWeight.bold : FontWeight.normal,
                      ),
                    ),
                  ),
                ),
            if(kIsWeb) for (int i = startPage; i <= endPage; i++)
              TextButton(
                onPressed: () => goToPage(i + 1),
                child: Text(
                  (i + 1).toString(),
                  style: TextStyle(
                    fontWeight: i + 1 == currentPage ? FontWeight.bold : FontWeight.normal,
                  ),
                ),
              ),
            IconButton(
              icon: Icon(Icons.chevron_right),
              onPressed: goToNextPage,
            ),
            IconButton(
              icon: Icon(Icons.last_page),
              onPressed: goToLastPage,
            ),
          ],
        ),

        // 'Delete Selected' button
        Padding(
          padding: EdgeInsets.all(10),
          child: ElevatedButton(
            onPressed: deleteSelectedEntries,
            child: Text('Delete Selected'),
          ),
        ),
      ],
    );
  }

}

class Entry {
  String? id;
  String? name;
  String? email;
  String? role;
  // Other properties representing the columns

  Entry({required this.id,
    required this.name,
    required this.email,
    required this.role
  });

  Entry.fromJson(Map map){
    id = map['id'];
    name = map['name'];
    email = map['email'];
    role = map['role'];
  }
}
