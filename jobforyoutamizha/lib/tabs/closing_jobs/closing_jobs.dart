import 'package:flutter/material.dart';
import 'package:jobforyoutamizha/common/constant.dart';
import 'package:jobforyoutamizha/model/JobPost.dart';
import 'package:jobforyoutamizha/service/job_info_service.dart';
import 'package:jobforyoutamizha/service_locator.dart';
import 'package:jobforyoutamizha/tabs/home/job_detail.dart';

class ClosingJobs extends StatelessWidget {
  final JobInfoService _jobInfoService = locator<JobInfoService>();
  
  @override
  Widget build(BuildContext context) {
    return Container(
      child: _jobList(),
    );
  }


  _jobList() {
    return FutureBuilder<List<JobPost>>(
        future: _jobInfoService.getSoonClosingJobPosts(),
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            var jobPosts = snapshot.data;
            return ListView.builder(
                itemBuilder: (context, index) {
                  var job = jobPosts[index];
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
                                    image: (job.imageUrl!=null) ? NetworkImage(job.imageUrl) : AssetImage(PLACEHOLDER_IMAGE) ,
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
                itemCount: jobPosts.length);
          } else if (snapshot.hasError) {
            print(">>> Error in getting data");
            print(snapshot.error);
            return Center(
              child: Text('Error fetching the jobs.\nPlease try again later.'),
            );
          } else {
            return Center(child: CircularProgressIndicator());
          }
        });
  }

  _showJobDetail(JobPost jobPost, context) {
    print(jobPost.jobTitle);
    Navigator.of(context)
        .push(MaterialPageRoute(builder: (context) => JobDetail(jobPost)));
  }
}