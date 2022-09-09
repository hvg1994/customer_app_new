import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';

class Clap extends StatefulWidget {
  const Clap({Key? key}) : super(key: key);

  @override
  State<Clap> createState() => _ClapState();
}

class _ClapState extends State<Clap> {
 
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Center(
          child: SizedBox(
            height: 150,
            child: Lottie.network(
                'https://assets6.lottiefiles.com/packages/lf20_drkxsxuy.json'),
          ),
        ),
      ],
    ));
    //getClapButton()));
  }

  Widget getClapButton() {
    
    return new GestureDetector(
        child: new Container(
      height: 60.0,
      width: 60.0,
      padding: new EdgeInsets.all(10.0),
      decoration: new BoxDecoration(
          border: new Border.all(color: Colors.pink, width: 1.0),
          borderRadius: new BorderRadius.circular(50.0),
          color: Colors.white,
          boxShadow: [new BoxShadow(color: Colors.pink, blurRadius: 8.0)]),
      child: new ImageIcon(new AssetImage("assets/clap.png"),
          color: Colors.pink, size: 40.0),
    ));
  }
}