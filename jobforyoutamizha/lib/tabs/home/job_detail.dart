import 'package:flutter/material.dart';
import 'package:jobforyoutamizha/common/constant.dart';
import 'package:jobforyoutamizha/model/JobPost.dart';
import 'package:jobforyoutamizha/tabs/study_materials/open_file.dart';

class JobDetail extends StatelessWidget {
  final JobPost jobPost;
  BuildContext _context;
  static const String PATH = '/job-detail';
  JobDetail(this.jobPost);
  @override
  Widget build(BuildContext context) {
    _context = context;
    return Scaffold(
      appBar: AppBar(title: Text(jobPost.jobTitle)),
      body: Container(
        padding: EdgeInsets.all(5),
        child: Column(
          children: <Widget>[
            _jobImage(MediaQuery.of(context).size.width),
            SizedBox(height: 20),
            _jobInfo(MediaQuery.of(context).size.width),
            // (jobPost.attachments.length>0) ?_attachmentList() : Container(child: Text('No attachments'))
          ],
        ),
      ),
    );
  }

  _jobImage(width) {
    return Container(
      height: 200,
      decoration: BoxDecoration(
          image: DecorationImage(
              image: (jobPost.imageUrl != null)
                  ? NetworkImage(jobPost.imageUrl)
                  : AssetImage(PLACEHOLDER_IMAGE),
              fit: BoxFit.cover)),
    );
  }

  _jobInfo(width) {
    return Expanded(
      child: SingleChildScrollView(
        child: Column(
          children: <Widget>[
            Card(
              child: Container(
                padding: EdgeInsets.symmetric(vertical: 25, horizontal: 10),
                width: width,
                child: Column(
                  mainAxisSize: MainAxisSize.max,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Text(jobPost.jobTitle,
                        style: TextStyle(
                            fontSize: 30, fontWeight: FontWeight.w700)),
                    SizedBox(height: 10),
                    Text(
                      'Published on ' + jobPost.createdDate,
                      style: TextStyle(color: Colors.blueGrey, fontSize: 13),
                    ),
                    (jobPost.lastDate == null)
                        ? Container()
                        : Text(
                            'Last date on ' + jobPost.lastDate,
                            style:
                                TextStyle(color: Colors.blueGrey, fontSize: 13),
                          ),
                    SizedBox(height: 10),
                    Text(
                      'Categories:',
                      style:
                          TextStyle(fontSize: 15, fontWeight: FontWeight.w600),
                    ),
                    (jobPost.tags.length == 0)
                        ? Text('No categories')
                        : Wrap(
                            children:
                                jobPost.tags.map((e) => chips(e)).toList(),
                          ),
                    SizedBox(height: 20),
                    Text(jobPost.detail),
                  ],
                ),
              ),
            ),
            (jobPost.attachments.length > 0)
                ? _attachmentList()
                : Container(child: Text('No attachments'))
          ],
        ),
      ),
    );
  }

  _attachmentList() {
    return SizedBox(
        height: 75,
        child: ListView.builder(
            itemCount: jobPost.attachments.length,
            itemBuilder: (context, index) {
              return ListTile(
                title: Text(jobPost.attachments[index].fileName),
                trailing: FlatButton(
                    child: Text('Open', style: TextStyle(color: Colors.blue)),
                    onPressed: () => openFile(jobPost.attachments[index])),
              );
            }));
  }

  Widget chips(text) {
    return FilterChip(
      label: Text(text),
      onSelected: (bool value) {},
    );
  }

  openFile(Attachment attachment) {
    Navigator.of(_context).pushNamed(OpenFile.PATH, arguments: attachment);
  }
}
