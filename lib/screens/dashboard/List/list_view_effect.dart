import 'package:flutter/material.dart';

import 'item_effect.dart';
import 'list_bloc.dart';


class ListViewEffect extends StatefulWidget {
  final Duration? duration;
  final List<Widget> children;

  const ListViewEffect({Key? key, this.duration, required this.children})
      : super(key: key);
  @override
  _ListViewEffect createState() => _ListViewEffect();
}

class _ListViewEffect extends State<ListViewEffect> {
  late ListBloc _listBloc;

  @override
  void initState() {
    _listBloc = ListBloc();
    super.initState();
  }

  @override
  void dispose() {
    _listBloc.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    _listBloc.startAnimation(widget.children.length, widget.duration!);

    return ListView.builder(
          scrollDirection: Axis.vertical,
          itemCount: widget.children.length,
          itemBuilder: (context, position) {
            return ItemEffect(
                child: widget.children[position],
                duration: widget.duration,
                position: position);
          });

  }
}
