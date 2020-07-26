import 'package:flutter/material.dart';
import 'package:jobforyoutamizha/common/constant.dart';
import 'package:jobforyoutamizha/model/JobPost.dart';
import 'package:jobforyoutamizha/tabs/home/job_detail.dart';


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
          return GestureDetector(
            onTap: () => _showJobDetail(job, context),
            child: Card(
              child: Row(
              mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Container(
                    margin: EdgeInsets.all(5),
                    height: 75,
                    width: 100,
                    decoration: BoxDecoration(
                        image: DecorationImage(
                            image: (job.imageUrl != null)
                                ? NetworkImage(job.imageUrl)
                                : AssetImage(PLACEHOLDER_IMAGE),
                            fit: BoxFit.cover)),
                  ),
                  Expanded(
                    child: Container(
                      margin: EdgeInsets.all(5),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: <Widget>[
                          Text(
                            job.jobTitle,
                            style: TextStyle(
                                fontWeight: FontWeight.w600,
                                fontSize: 16),
                          ),
                          Text(
                            job.desc,
                            overflow: TextOverflow.ellipsis,
                            maxLines: 2,
                          ),
                          Text('Read more',
                              style: TextStyle(color: Colors.blue))
                        ],
                      ),
                    ),
                  )
                ],
              ),
            ),
          );
        },
        itemCount: jobPostToShow.length);
  }

  _showJobDetail(JobPost jobPost, context) {
    print(jobPost.jobTitle);
    Navigator.of(context)
        .push(MaterialPageRoute(builder: (context) => JobDetail(jobPost)));
  }
}