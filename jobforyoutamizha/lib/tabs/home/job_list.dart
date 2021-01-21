import 'package:flutter/material.dart';
import 'package:jobforyoutamizha/model/JobPost.dart';


class JobList extends StatelessWidget {
  final List<JobPost> jobPostToShow;
  final ScrollController controller;

  JobList({this.jobPostToShow, this.controller});
  @override
  Widget build(BuildContext context) {
    return ListView.builder(
        controller: controller,
        itemBuilder: (context, index) {
          var job = jobPostToShow[index];
          return job.buildItemWidget();
        },
        itemCount: jobPostToShow.length);
  }

 
}