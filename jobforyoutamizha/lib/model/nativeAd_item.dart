
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:jobforyoutamizha/adManager.dart';
import 'package:jobforyoutamizha/model/JobPost.dart';

class NativeAdItem extends JobPost{

  NativeAdItem(String jobTitle, String desc, String createdDate, String lastDate, String detail, String imageUrl, List<String> tags, List<Attachment> attachments, DocumentSnapshot ref) : super(jobTitle, desc, createdDate, lastDate, detail, imageUrl, tags, attachments, ref);

  @override
  Widget buildItemWidget() {
    return createNativeAd();
  }

  bool isNativeAd() {
      return true;
  }


}