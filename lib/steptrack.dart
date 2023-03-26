import 'dart:async';

import 'package:etiqa_flutter/api_service/stepService.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/src/widgets/placeholder.dart';
import 'package:health/health.dart';

import 'healthApp.dart';

class StepCountPage extends StatefulWidget {
  const StepCountPage({super.key});

  @override
  State<StepCountPage> createState() => _StepCountPageState();
}

class _StepCountPageState extends State<StepCountPage> {
  int _nofSteps = 10;
  HealthFactory health = HealthFactory();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    fetchStepData();
    Timer.periodic(Duration(seconds: 5), (timer) => fetchStepData());
  }

  Future fetchStepData() async {
    int? steps;

    // get steps for today (i.e., since midnight)
    final now = DateTime.now();
    final midnight = DateTime(now.year, now.month, now.day);

    bool requested = await health.requestAuthorization([HealthDataType.STEPS]);

    if (requested) {
      try {
        steps = await health.getTotalStepsInInterval(midnight, now);
      } catch (error) {
        print("Caught exception in getTotalStepsInInterval: $error");
      }

      print('Total number of steps: $steps');
      stepService().update("testuser3", steps.toString());

      setState(() {
        _nofSteps = (steps == null) ? 0 : steps;
      });
    } else {
      print("Authorization not granted - error in authorization");
    }
  }

  Future revokeAccess() async {
    await health.revokePermissions();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
          appBar: AppBar(
            title: const Text('Health Example'),
            actions: <Widget>[
              IconButton(
                onPressed: () {
                  fetchStepData();
                },
                icon: Icon(Icons.nordic_walking),
              ),
              IconButton(
                onPressed: () {
                  revokeAccess();
                },
                icon: Icon(Icons.logout),
              )
            ],
          ),
          body: Center(
            child: Text("${_nofSteps}"),
          )),
    );
  }
}
