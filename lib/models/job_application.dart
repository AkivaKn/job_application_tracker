import 'package:hive/hive.dart';

part 'job_application.g.dart';

@HiveType(typeId: 0)
class JobApplication {
  @HiveField(0)
  String jobTitle;
  @HiveField(1)
  String company;
  @HiveField(2)
  String? jobSite;
  @HiveField(3)
  String? location;
  @HiveField(4)
  int? salary;
  @HiveField(5)
  String status;
  @HiveField(6)
  DateTime? appliedDate;
  @HiveField(7)
  DateTime? interviewDate;

  JobApplication({
    required this.jobTitle,
    required this.company,
    required this.status,
    this.jobSite,
    this.location,
    this.salary,
    this.appliedDate,
    this.interviewDate,
  });
}
