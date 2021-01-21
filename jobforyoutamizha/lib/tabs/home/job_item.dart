import 'package:flutter/material.dart';
import 'package:jobforyoutamizha/common/constant.dart';
import 'package:jobforyoutamizha/model/JobPost.dart';
import 'package:jobforyoutamizha/tabs/home/job_detail.dart';

class JobItem extends StatelessWidget {
  final JobPost jobPost;

  const JobItem({Key key, this.jobPost}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => _showJobDetail(jobPost, context),
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
                      image: (jobPost.imageUrl != null)
                          ? NetworkImage(jobPost.imageUrl)
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
                      jobPost.jobTitle,
                      style:
                          TextStyle(fontWeight: FontWeight.w600, fontSize: 16),
                    ),
                    Text(
                      jobPost.desc,
                      overflow: TextOverflow.ellipsis,
                      maxLines: 2,
                    ),
                    Text('Read more', style: TextStyle(color: Colors.blue))
                  ],
                ),
              ),
            )
          ],
        ),
      ),
    );
  }

  _showJobDetail(JobPost jobPost, context) {
    print(jobPost.jobTitle);
    Navigator.of(context)
        .push(MaterialPageRoute(builder: (context) => JobDetail(jobPost)));
  }
}
