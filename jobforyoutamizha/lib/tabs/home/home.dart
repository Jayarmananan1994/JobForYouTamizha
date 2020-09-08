import 'package:flutter/material.dart';
import 'package:jobforyoutamizha/model/JobPost.dart';
import 'package:jobforyoutamizha/model/category.dart';
import 'package:jobforyoutamizha/service/job_info_service.dart';
import 'package:jobforyoutamizha/service_locator.dart';
import 'package:jobforyoutamizha/tabs/categories/category_result.dart';
import 'package:jobforyoutamizha/tabs/home/job_list.dart';
import 'package:jobforyoutamizha/tabs/search_result/search_result.dart';

class Home extends StatefulWidget {
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  static const String PVT_JOB = 'Private Jobs';
  static const String GOVT_JOB = 'Government Jobs';
  TextEditingController _controller;
  String _tabSelected = GOVT_JOB;
  List<JobPost> _jobPostToShow = [];
  ScrollController _scrollController = new ScrollController();
  JobInfoService _jobInfoService = locator<JobInfoService>();
  bool _nomoreItems = false;

  @override
  void initState() {
    super.initState();
    _controller = TextEditingController();
    _scrollController.addListener(() {
      if (_scrollController.position.pixels ==
              _scrollController.position.maxScrollExtent &&
          !_nomoreItems) {
        print('Reached the bottom');
        _loadMorePost();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: MediaQuery.of(context).size.height,
      padding: EdgeInsets.symmetric(vertical: 10, horizontal: 10),
      child: Column(
        children: <Widget>[
          _searchBar(),
          _tnebUpdate(),
          _filterButtons(),
          SizedBox(height: 10),
          _jobList()
        ],
      ),
    );
  }

  _searchBar() {
    return Card(
        child: Container(
      padding: EdgeInsets.only(left: 10),
      child: Row(
        mainAxisSize: MainAxisSize.max,
        children: <Widget>[
          Expanded(
              child: TextField(
            controller: _controller,
            //onSaved: (val) => searchText = val,
            decoration: InputDecoration(
                border: InputBorder.none,
                focusedBorder: InputBorder.none,
                enabledBorder: InputBorder.none,
                errorBorder: InputBorder.none,
                disabledBorder: InputBorder.none,
                hintText: 'Search'),
          )),
          GestureDetector(
            child: SizedBox(width: 50, child: Icon(Icons.search)),
            onTap: () {
              FocusScope.of(context).unfocus();
              Navigator.of(context)
                  .pushNamed(SearchResult.PATH, arguments: _controller.text);
            },
          )
        ],
      ),
    ));
  }

  _filterButtons() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: <Widget>[
        SizedBox(
          width: 150,
          child: RaisedButton(
              color: (_tabSelected == GOVT_JOB) ? Colors.blue : Colors.white,
              shape: StadiumBorder(),
              onPressed: () => _switchTab(GOVT_JOB),
              child: Text('Govt Jobs',
                  style: TextStyle(
                      color: (_tabSelected == GOVT_JOB)
                          ? Colors.white
                          : Colors.blue))),
        ),
        SizedBox(
          width: 150,
          child: RaisedButton(
            color: (_tabSelected == PVT_JOB) ? Colors.blue : Colors.white,
            shape: StadiumBorder(),
            onPressed: () => _switchTab(PVT_JOB),
            child: Text('Private Jobs',
                style: TextStyle(
                    color: (_tabSelected == PVT_JOB)
                        ? Colors.white
                        : Colors.blue)),
          ),
        )
      ],
    );
  }

  _switchTab(String tabName) {
    setState(() {
      _tabSelected = tabName;
      _nomoreItems = false;
    });
  }

  _jobList() {
    return FutureBuilder<List<JobPost>>(
        future: _jobInfoService.getJobsByCategories(_tabSelected),
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            _jobPostToShow = snapshot.data;
            return Expanded(
                child: JobList(
                    jobPostToShow: _jobPostToShow,
                    controller: _scrollController));
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
        _tabSelected, lastDoc.ref);
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
    _controller.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  _tnebUpdate() {
    return SizedBox(
      width: 300,
      child: RaisedButton(
          color: Colors.white,
          shape: StadiumBorder(),
          onPressed: _gotoTnebUpdate,
          child: Text('TNEB Updates', style: TextStyle(color: Colors.blue))),
    );
  }

  void _gotoTnebUpdate() {
      var category = Category("TNEB Updates", "TNEB Updates");
      Navigator.of(context).pushNamed(CategoryResult.PATH, arguments: category);
  }
}
