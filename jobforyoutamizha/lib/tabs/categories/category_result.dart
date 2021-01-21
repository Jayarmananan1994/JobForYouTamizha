import 'package:flutter/material.dart';
import 'package:jobforyoutamizha/adManager.dart';
import 'package:jobforyoutamizha/model/JobPost.dart';
import 'package:jobforyoutamizha/model/category.dart';
import 'package:jobforyoutamizha/service/job_info_service.dart';
import 'package:jobforyoutamizha/service_locator.dart';
import 'package:jobforyoutamizha/tabs/home/job_list.dart';
import 'package:admob_flutter/admob_flutter.dart';

class CategoryResult extends StatefulWidget {
  final Category category;
  static const String PATH = '/category-result';

  CategoryResult({this.category});

  @override
  _CategoryResultState createState() => _CategoryResultState();
}

class _CategoryResultState extends State<CategoryResult> {
  final JobInfoService _jobInfoService = locator<JobInfoService>();
  ScrollController _scrollController = new ScrollController();
  List<JobPost> _jobPostToShow = [];
  bool _nomoreItems = false;
  // BannerAd _bannerAd;

  @override
  void initState() {
    super.initState();
   // _initAdMob();
    _scrollController.addListener(() {
      var pos = _scrollController.position;
      if (pos.pixels == pos.maxScrollExtent && !_nomoreItems) {
        print('Reached the bottom');
        _loadMorePost();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.category.displayName),
      ),
      body: Container(
        height: MediaQuery.of(context).size.height,
        padding: EdgeInsets.symmetric(vertical: 10, horizontal: 10),
        child: Column(
          children: <Widget>[
            _adSpace(),
            _jobList(widget.category.displayName)],
        ),
      ),
    );
  }

   _adSpace() {
    return Container(
      margin: EdgeInsets.only(bottom: 20.0),
      child: createBannerAd(AdmobBannerSize.BANNER),
    );
  }

  _jobList(category) {
    return FutureBuilder<List<JobPost>>(
        future: _jobInfoService.getJobsByCategories(category),
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            var jobPosts = snapshot.data;
            return Expanded(
                child: JobList(
                    jobPostToShow: jobPosts, controller: _scrollController));
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

  void _loadMorePost() async {
    var lastDoc = _jobPostToShow.last;
    print(lastDoc.jobTitle);
    print(">>> start fetching");
    List<JobPost> post = await _jobInfoService.getNextJobPostByCategory(
        widget.category.displayName, lastDoc.ref);
    print(">>>> got some post");
    print(post);
    if (post.length == 0) {
      setState(() => _nomoreItems = true);
    } else {
      setState(() => _jobPostToShow.addAll(post));
    }
  }

  @override
  void dispose() {
    //_bannerAd.dispose();
    super.dispose();
  }
}
