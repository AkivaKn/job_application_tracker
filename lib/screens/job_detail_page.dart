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
  DateTime? _createdAt;
  TextEditingController _datePickerController = TextEditingController();

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
      _createdAt = widget.job!.createdAt;
      _datePickerController.text = _createdAt != null
          ? DateFormat.yMd().format(_createdAt ?? DateTime.now())
          : '';
    }
  }

  @override
  void dispose() {
    _datePickerController.dispose();
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
                controller: _datePickerController,
                readOnly: true,
                decoration: InputDecoration(
                  labelText: 'Date Created',
                  hintText: "Click here to select date",
                ),
                onTap: () async {
                  DateTime? pickedDate = await showDatePicker(
                    context: context,
                    initialDate: _createdAt ?? DateTime.now(),
                    firstDate: DateTime(2020),
                    lastDate: DateTime(2030),
                  );
                  if (pickedDate != null) {
                    setState(() {
                      _createdAt = pickedDate;
                      _datePickerController.text =
                          _createdAt!.toLocal().toString().split(' ')[0];
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
                      createdAt: _createdAt ?? DateTime.now(),
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
