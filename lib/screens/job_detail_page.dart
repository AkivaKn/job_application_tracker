import 'package:flutter/material.dart';
import 'package:job_application_tracker/models/job_application.dart';
import 'package:job_application_tracker/providers/job_provider.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';

class JobDetailPage extends StatefulWidget {
  final JobApplication? job;
  final int? index;

  JobDetailPage({this.job, this.index});

  @override
  _JobDetailPageState createState() => _JobDetailPageState();
}

class _JobDetailPageState extends State<JobDetailPage> {
  final _formKey = GlobalKey<FormState>();
  late String _jobTitle;
  late String _company;
  String? _jobSite;
  String? _location;
  int? _salary;
  String _status = 'Applied';
  DateTime? _appliedDate;
  TextEditingController _appliedDatePickerController = TextEditingController();
  DateTime? _interviewDate;
  TextEditingController _interviewDatePickerController =
      TextEditingController();
  String? _jobUrl;

  @override
  void initState() {
    super.initState();
    if (widget.job != null) {
      _jobTitle = widget.job!.jobTitle;
      _company = widget.job!.company;
      _jobSite = widget.job!.jobSite;
      _location = widget.job!.location;
      _salary = widget.job!.salary;
      _status = widget.job!.status;
      _appliedDate = widget.job!.appliedDate;
      _appliedDatePickerController.text = _appliedDate != null
          ? DateFormat.yMd().format(_appliedDate ?? DateTime.now())
          : '';
      _interviewDate = widget.job!.interviewDate;
      _interviewDatePickerController.text = _interviewDate != null
          ? DateFormat.yMd().format(_interviewDate ?? DateTime.now())
          : '';
      _jobUrl = widget.job!.jobUrl;
    }
  }

  @override
  void dispose() {
    _appliedDatePickerController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final jobProvider = Provider.of<JobProvider>(context);

    return Scaffold(
      appBar: AppBar(
        title: Text(widget.job == null ? 'Add Job' : 'Edit Job'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              TextFormField(
                initialValue: widget.job?.jobTitle ?? '',
                decoration: InputDecoration(labelText: 'Job Title'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter job title';
                  }
                  return null;
                },
                onSaved: (value) {
                  _jobTitle = value!;
                },
              ),
              TextFormField(
                initialValue: widget.job?.company ?? '',
                decoration: InputDecoration(labelText: 'Company'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter company name';
                  }
                  return null;
                },
                onSaved: (value) {
                  _company = value!;
                },
              ),
              TextFormField(
                initialValue: widget.job?.jobSite ?? '',
                decoration: InputDecoration(labelText: 'Job Site'),
                onSaved: (value) {
                  _jobSite = value ?? '';
                },
              ),
              TextFormField(
                initialValue: widget.job?.location ?? '',
                decoration: InputDecoration(labelText: 'Location'),
                onSaved: (value) {
                  _location = value ?? '';
                },
              ),
              TextFormField(
                initialValue: widget.job?.salary != null
                    ? widget.job?.salary.toString()
                    : '',
                decoration: InputDecoration(labelText: 'Salary'),
                keyboardType: TextInputType.number,
                onSaved: (value) {
                  if (value == null || value.isEmpty) {
                    _salary = null;
                  } else {
                    _salary = int.tryParse(value);
                  }
                },
              ),
               TextFormField(
                initialValue: widget.job?.jobUrl ?? '',
                decoration: InputDecoration(labelText: 'Job Link'),
                onSaved: (value) {
                  _jobUrl = value ?? '';
                },
              ),
              TextFormField(
                controller: _appliedDatePickerController,
                readOnly: true,
                decoration: InputDecoration(
                  labelText: 'Applied Date',
                  hintText: "Click here to select date",
                ),
                onTap: () async {
                  DateTime? pickedDate = await showDatePicker(
                    context: context,
                    initialDate: _appliedDate ?? DateTime.now(),
                    firstDate: DateTime(2020),
                    lastDate: DateTime(2030),
                  );
                  if (pickedDate != null) {
                    setState(() {
                      _appliedDate = pickedDate;
                      _appliedDatePickerController.text = DateFormat.yMd()
                          .format(_appliedDate ?? DateTime.now());
                    });
                  }
                },
              ),
              TextFormField(
                controller: _interviewDatePickerController,
                readOnly: true,
                decoration: InputDecoration(
                  labelText: 'Interview Date',
                  hintText: "Click here to select date",
                ),
                onTap: () async {
                  DateTime? pickedDate = await showDatePicker(
                    context: context,
                    initialDate: _interviewDate ?? DateTime.now(),
                    firstDate: DateTime(2020),
                    lastDate: DateTime(2030),
                  );
                  if (pickedDate != null) {
                    setState(() {
                      _interviewDate = pickedDate;
                      _interviewDatePickerController.text = DateFormat.yMd()
                          .format(_interviewDate ?? DateTime.now());
                    });
                  }
                },
              ),
              DropdownButtonFormField<String>(
                value: _status,
                items: [
                  'Interested',
                  'Applied',
                  'Rejected',
                  'Interview',
                  'Offer'
                ].map((String status) {
                  return DropdownMenuItem<String>(
                    value: status,
                    child: Text(status),
                  );
                }).toList(),
                onChanged: (value) {
                  setState(() {
                    _status = value!;
                  });
                },
                onSaved: (value) {
                  _status = value!;
                },
                decoration: InputDecoration(labelText: 'Status'),
              ),
              SizedBox(height: 20),
              ElevatedButton(
                onPressed: () {
                  if (_formKey.currentState!.validate()) {
                    _formKey.currentState!.save();

                    final job = JobApplication(
                      jobTitle: _jobTitle,
                      company: _company,
                      jobSite: _jobSite,
                      location: _location,
                      salary: _salary,
                      status: _status,
                      appliedDate: _appliedDate,
                      interviewDate: _interviewDate,
                      jobUrl: _jobUrl,
                    );

                    if (widget.index == null) {
                      jobProvider.addJob(job);
                    } else {
                      jobProvider.updateJob(widget.index!, job);
                    }

                    Navigator.pop(context);
                  }
                },
                child: Text(widget.job == null ? 'Add Job' : 'Update Job'),
              ),
              SizedBox(height: 20),
              if (widget.index != null)
                ElevatedButton(
                  onPressed: () async {
                    final confirmed = await showDialog(
                      context: context,
                      builder: (BuildContext context) {
                        return AlertDialog(
                          title: Text('Confirm Delete'),
                          content:
                              Text('Are you sure you want to delete this job?'),
                          actions: [
                            TextButton(
                              onPressed: () => Navigator.of(context).pop(false),
                              child: Text('Cancel'),
                            ),
                            TextButton(
                              onPressed: () => Navigator.of(context).pop(true),
                              child: Text('Delete'),
                            ),
                          ],
                        );
                      },
                    );

                    if (confirmed == true) {
                      jobProvider.deleteJob(widget.index!);
                      Navigator.pop(context);
                    }
                  },
                  style: ButtonStyle(
                    backgroundColor: WidgetStateProperty.all<Color>(Colors.red),
                  ),
                  child: Text(
                    'Delete Job',
                    style: TextStyle(color: Colors.black),
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }
}
