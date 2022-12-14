import 'package:flutter/material.dart';

import 'day_breakfast.dart';

class PPDashboardScreen extends StatefulWidget {
  const PPDashboardScreen({Key? key}) : super(key: key);

  @override
  State<PPDashboardScreen> createState() => _PPDashboardScreenState();
}

class _PPDashboardScreenState extends State<PPDashboardScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: TextButton(
          child: Text('Next'),
          onPressed: (){
            Navigator.push(context, MaterialPageRoute(builder: (_) => PPDailyTasksUI(day: "1",)));
          },
        ),
      ),
    );
  }
}
