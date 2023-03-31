import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:gwc_customer/widgets/constants.dart';
import 'package:sizer/sizer.dart';

class FaqDetailedList extends StatefulWidget {
  const FaqDetailedList({Key? key}) : super(key: key);

  @override
  State<FaqDetailedList> createState() => _FaqDetailedListState();
}

class _FaqDetailedListState extends State<FaqDetailedList> {
  @override
  Widget build(BuildContext context) {
    return Container();
  }

  gridTile(String assetName){
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.5),
            blurRadius: 5,
            offset: const Offset(2, 10),
          ),
        ],
      ),
      child: Column(
        children: [
          Center(child: Image.asset(assetName)),
          Text("Transaction",
            style: TextStyle(
              fontFamily: kFontMedium,
              fontSize: 10.sp
            ),
          )
        ],
      )
    );
  }
}
