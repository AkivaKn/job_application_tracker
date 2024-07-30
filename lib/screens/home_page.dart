import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:job_application_tracker/models/job_application.dart';
import 'package:job_application_tracker/providers/job_provider.dart';
import 'job_detail_page.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  String _searchQuery = '';

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 6, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Job Application Tracker'),
        bottom: TabBar(
          tabAlignment: TabAlignment.start,
          isScrollable: true,
          controller: _tabController,
          tabs: [
            Tab(text: 'All'),
            Tab(text: 'Interested'),
            Tab(text: 'Applied'),
            Tab(text: 'Interview'),
            Tab(text: 'Offer'),
            Tab(text: 'Rejected'),
          ],
        ),
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextField(
              decoration: const InputDecoration(
                labelText: 'Search by company or job title',
                border: OutlineInputBorder(),
                prefixIcon: Icon(Icons.search),
              ),
              onChanged: (query) {
                setState(() {
                  _searchQuery = query;
                });
              },
            ),
          ),
          Expanded(
            child: TabBarView(
              controller: _tabController,
              children: [
                _buildJobList(context, 'All'),
                _buildJobList(context, 'Interested'),
                _buildJobList(context, 'Applied'),
                _buildJobList(context, 'Interview'),
                _buildJobList(context, 'Offer'),
                _buildJobList(context, 'Rejected'),
              ],
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => JobDetailPage(),
            ),
          );
        },
        child: Icon(Icons.add),
      ),
    );
  }

  Widget _buildJobList(BuildContext context, String status) {
    return Consumer<JobProvider>(
      builder: (context, jobProvider, child) {
        List<JobApplication> filteredJobs = jobProvider.jobs.where((job) {
          bool matchesSearchQuery = job.jobTitle
                  .toLowerCase()
                  .contains(_searchQuery.toLowerCase()) ||
              job.company.toLowerCase().contains(_searchQuery.toLowerCase());
          bool matchesStatus = job.status == status;
          bool matches;
          status == 'All'
              ? matches = matchesSearchQuery
              : matches = matchesSearchQuery && matchesStatus;
          return matches;
        }).toList();

        if (filteredJobs.isEmpty) {
          return const Center(child: Text('No jobs found.'));
        }

        return ListView.builder(
          itemCount: filteredJobs.length,
          itemBuilder: (context, index) {
            JobApplication job = filteredJobs[index];
            return ListTile(
              shape: const Border(
                bottom: BorderSide(),
              ),
              title: Text(job.jobTitle),
              subtitle: Text(job.company),
              trailing: job.salary != null
                  ? Text(
                      NumberFormat.simpleCurrency(name: 'GBP', decimalDigits: 0)
                          .format(job.salary))
                  : null,
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => JobDetailPage(job: job, index: index),
                  ),
                );
              },
            );
          },
        );
      },
    );
  }
}
