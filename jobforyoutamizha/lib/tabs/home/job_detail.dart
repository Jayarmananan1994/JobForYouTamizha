import 'package:flutter/material.dart';
import 'package:jobforyoutamizha/adManager.dart';
import 'package:jobforyoutamizha/common/constant.dart';
import 'package:jobforyoutamizha/model/JobPost.dart';
import 'package:jobforyoutamizha/service/user_info_service.dart';
import 'package:jobforyoutamizha/service_locator.dart';
import 'package:jobforyoutamizha/tabs/study_materials/open_file.dart';
import 'package:flutter_linkify/flutter_linkify.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:admob_flutter/admob_flutter.dart';
import 'package:firebase_admob/firebase_admob.dart';

class JobDetail extends StatefulWidget {
  final JobPost jobPost;
  static const String PATH = '/job-detail';
  JobDetail(this.jobPost);

  @override
  _JobDetailState createState() => _JobDetailState();
}

class _JobDetailState extends State<JobDetail> {
  // BannerAd _bannerAd;
  InterstitialAd _interstitialAd;
  BuildContext _context;
  UserInfoService _userInfoService = locator<UserInfoService>();

  @override
  void initState() {
    _initAdMob();
    super.initState();
  }

  Future<void> _initAdMob() async {
    _userInfoService.incrementDetailPageVisitCount();
    if (_userInfoService.getDetailpageVisitCount() == 10) {
      print('>>>>>>>>>>>>>>>>>Load banner ad<<<<<<<<<<<<<<<<<<<<<<');
      _interstitialAd = createInterstitialAd()
        ..load()
       ..show();
      _userInfoService.resetDetailPageVisitCount();
    }
  }

  @override
  void dispose() {
    if (_interstitialAd != null) {
      _interstitialAd.dispose();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    _context = context;
    return Scaffold(
      appBar: AppBar(title: Text(widget.jobPost.jobTitle)),
      body: Container(
        padding: EdgeInsets.all(5),
        child: Column(
          children: <Widget>[
            _jobImage(MediaQuery.of(context).size.width),
            SizedBox(height: 20),
            _jobInfo(MediaQuery.of(context).size.width)
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
              image: (widget.jobPost.imageUrl != null)
                  ? NetworkImage(widget.jobPost.imageUrl)
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
                    Text(widget.jobPost.jobTitle,
                        style: TextStyle(
                            fontSize: 30, fontWeight: FontWeight.w700)),
                    SizedBox(height: 10),
                    Text(
                      'Published on ' + widget.jobPost.createdDate,
                      style: TextStyle(color: Colors.blueGrey, fontSize: 13),
                    ),
                    (widget.jobPost.lastDate == null)
                        ? Container()
                        : Text(
                            'Last date on ' + widget.jobPost.lastDate,
                            style:
                                TextStyle(color: Colors.blueGrey, fontSize: 13),
                          ),
                    SizedBox(height: 10),
                    Text(
                      'Categories:',
                      style:
                          TextStyle(fontSize: 15, fontWeight: FontWeight.w600),
                    ),
                    (widget.jobPost.tags.length == 0)
                        ? Text('No categories')
                        : Wrap(
                            children: widget.jobPost.tags
                                .map((e) => chips(e))
                                .toList(),
                          ),
                    SizedBox(height: 20),
                    Linkify(
                      text: widget.jobPost.detail,
                      onOpen: (link) async {
                        if (await canLaunch(link.url)) {
                          await launch(link.url);
                        } else {
                          print('Could not launch $link');
                        }
                      },
                    ),
                  ],
                ),
              ),
            ),
            (widget.jobPost.attachments.length > 0)
                ? _attachmentList()
                : Container(child: Text('No attachments')),
             _adSpace(),
          ],
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

  _attachmentList() {
    return SizedBox(
        height: 75,
        child: ListView.builder(
            itemCount: widget.jobPost.attachments.length,
            itemBuilder: (context, index) {
              return ListTile(
                title: Text(widget.jobPost.attachments[index].fileName),
                trailing: FlatButton(
                    child: Text('Open', style: TextStyle(color: Colors.blue)),
                    onPressed: () =>
                        openFile(widget.jobPost.attachments[index])),
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
