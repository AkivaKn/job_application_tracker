import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:provider/provider.dart';
import 'models/job_application.dart';
import 'screens/home_page.dart';
import 'providers/job_provider.dart';

void main() async {
  await Hive.initFlutter();
  Hive.registerAdapter(JobApplicationAdapter());
  await Hive.openBox<JobApplication>('jobApplications');

  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => JobProvider(),
      child: MaterialApp(
        title: 'Job Tracker',
        theme: ThemeData(
          primarySwatch: Colors.blue,
        ),
        home: HomePage(),
      ),
    );
  }
}
