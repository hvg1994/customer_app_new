import 'package:flutter/material.dart';

class AttachmentsViewScreen extends StatefulWidget {
  final String attachmentUrl;
  const AttachmentsViewScreen({Key? key, required this.attachmentUrl}) : super(key: key);

  @override
  State<AttachmentsViewScreen> createState() => _AttachmentsViewScreenState();
}

class _AttachmentsViewScreenState extends State<AttachmentsViewScreen> {
  @override
  Widget build(BuildContext context) {
    return buildView();
  }

  buildView() {
    return  ClipRRect(
      borderRadius: BorderRadius.circular(10.0),
      child: Image(
        image: NetworkImage(
          widget.attachmentUrl,
        ),
        fit: BoxFit.contain,
      ),
    );
  }
}
