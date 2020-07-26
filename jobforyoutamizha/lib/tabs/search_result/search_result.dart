import 'package:flutter/material.dart';
import 'package:jobforyoutamizha/model/JobPost.dart';
import 'package:jobforyoutamizha/service/job_info_service.dart';
import 'package:jobforyoutamizha/service_locator.dart';
import 'package:jobforyoutamizha/tabs/home/job_list.dart';

class SearchResult extends StatelessWidget {
  static const String PATH = '/search-result';
  final String searchString;
  SearchResult({this.searchString});
  JobInfoService _jobInfoService = locator<JobInfoService>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Search result')),
      body: Container(
        child: FutureBuilder<List<JobPost>>(
          future: _jobInfoService.searchJobPost(searchString),
          builder: (context, snapshot){
            if(snapshot.hasData){
              var list = snapshot.data;
              if(list.length==0){
                 return Center(child: Text('No Job post found for the search text'));
              }else{
                 return _jobPost(list);
              }
            }else if(snapshot.hasError){
              return Center(child: Text('Error Fetching the data'));
            }else {
              return Center(child: CircularProgressIndicator());
            }

        }),
      ),
    );
  }

  _jobPost(list){
      return JobList(jobPostToShow: list);
  }
}
