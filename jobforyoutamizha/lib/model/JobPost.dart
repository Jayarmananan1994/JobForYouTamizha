import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:intl/intl.dart';

class JobPost{
  String jobTitle;
  String desc;
  String lastDate;
  String createdDate;
  String detail;
  String imageUrl;
  List<String> tags;
  List<Attachment> attachments;
  DocumentSnapshot ref;

  JobPost(this.jobTitle, this.desc, this.createdDate, this.lastDate, this.detail, this.imageUrl, this.tags, this.attachments, this.ref);

  static JobPost fromSnapshotData(DocumentSnapshot e){
    final DateFormat formatter = DateFormat('yyyy-MM-dd');
    List tagDy = e['tags'];
    List attDy = e['attachments'];
    List<String> tags = tagDy.map((e) => e.toString()).toList();
    List<Attachment> attachments =  attDy.map((e) => Attachment(e['fileName'], e['fileUrl'])).toList();
    Timestamp createdDate = e['createdDate'];
    Timestamp lastDate = e['lastDate'];
    String lastDateStr = (lastDate==null) ? null: formatter.format(lastDate.toDate());
    return JobPost(e['title'], e['description'],  formatter.format(createdDate.toDate()), lastDateStr, e['content'], e['imageUrl'],tags, attachments, e);
  }
}

class Attachment{
  String fileName;
  String fileUrl;
  Attachment(this.fileName, this.fileUrl);
}