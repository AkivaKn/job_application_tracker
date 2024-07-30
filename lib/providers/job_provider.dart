import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:job_application_tracker/models/job_application.dart';

class JobProvider extends ChangeNotifier {
  Box<JobApplication> jobBox = Hive.box<JobApplication>('jobApplications');
  List<JobApplication> _jobs = [];

  JobProvider() {
    _jobs = jobBox.values.toList();
  }

  List<JobApplication> get jobs => _jobs;

  void addJob(JobApplication job) {
    jobBox.add(job);
    _jobs = jobBox.values.toList();
    notifyListeners();
  }

  void updateJob(int index, JobApplication job) {
    jobBox.putAt(index, job);
    _jobs = jobBox.values.toList();
    notifyListeners();
  }

  void deleteJob(int index) {
    jobBox.deleteAt(index);
    _jobs = jobBox.values.toList();
    notifyListeners();
  }
}
