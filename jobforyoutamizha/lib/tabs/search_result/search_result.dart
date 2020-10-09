import 'package:flutter/material.dart';
import 'package:jobforyoutamizha/adManager.dart';
import 'package:jobforyoutamizha/model/JobPost.dart';
import 'package:jobforyoutamizha/service/job_info_service.dart';
import 'package:jobforyoutamizha/service_locator.dart';
import 'package:jobforyoutamizha/tabs/home/job_list.dart';
// import 'package:firebase_admob/firebase_admob.dart';

class SearchResult extends StatefulWidget {
  static const String PATH = '/search-result';
  final String searchString;
  SearchResult({this.searchString});

  @override
  _SearchResultState createState() => _SearchResultState();
}

class _SearchResultState extends State<SearchResult> {
  JobInfoService _jobInfoService = locator<JobInfoService>();

  @override
  void initState() {
    // _initAdMob();
    super.initState();
  }

  // Future<void> _initAdMob() async {
  //   await FirebaseAdMob.instance.initialize(appId: adMobAppId);
  //   _bannerAd = createBannerAd(AdSize.banner)..load()..show();
  // }

  // @override
  // void dispose() {
  //   _bannerAd.dispose();
  //   super.dispose();
  // }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Search result')),
      body: Container(
        child: FutureBuilder<List<JobPost>>(
          future: _jobInfoService.searchJobPost(widget.searchString.toLowerCase().split(" ")),
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

  _jobPost(List<JobPost> list){
    // ScrollController scrollController = new ScrollController();
      return JobList(jobPostToShow: list);
  //  return ListView(children:
  //     list.map((e) =>  Text(e.jobTitle)).toList()
  //   );
  

  }
}
