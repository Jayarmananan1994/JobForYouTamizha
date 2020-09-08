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
    var data = e.data();
    final DateFormat formatter = DateFormat('yyyy-MM-dd');
    List tagDy = data['tags'];
    List attDy = data['attachments'];
    List<String> tags = tagDy.map((e) => e.toString()).toList();
    List<Attachment> attachments =  attDy.map((e) => Attachment(e['fileName'], e['fileUrl'])).toList();
    Timestamp createdDate = data['createdDate'];
    Timestamp lastDate = data['lastDate'];
    String lastDateStr = (lastDate==null) ? null: formatter.format(lastDate.toDate());
    return JobPost(data['title'], data['description'],  formatter.format(createdDate.toDate()), lastDateStr, data['content'], data['imageUrl'],tags, attachments, e);
  }
}

class Attachment{
  String fileName;
  String fileUrl;
  Attachment(this.fileName, this.fileUrl);

  static Attachment fromMap(Map<String, dynamic> data){
    return Attachment(data['fileName'], data['fileUrl']);
  }
}