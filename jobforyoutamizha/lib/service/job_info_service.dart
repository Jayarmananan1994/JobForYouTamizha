import 'package:jobforyoutamizha/model/JobPost.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:jobforyoutamizha/model/category.dart';


class JobInfoService {
  FirebaseFirestore _firestore;
  List<JobPost> _jobposts;
  List<JobPost> _closingJobs;
  List<Category> _categoryList;
  Map<String, List<JobPost>> _categoryJobs = {};
  List<Attachment> _studyMaterialList;

  // Future<List<JobPost>> getJobPosts() async {
  //   if (_jobposts != null) {
  //     return _jobposts;
  //   }
  //   var snapShot = await getFirestore().collection('jobposts').getDocuments();
  //   List documents = snapShot.documents;
    
  //   _jobposts = documents.map((e) => JobPost.fromSnapshotData(e)).toList();
  //   return _jobposts;
  // }

  Future<List<JobPost>> getSoonClosingJobPosts() async {
    if (_closingJobs != null) {
      return _closingJobs;
    }

    var snapShot = await getFirestore()
        .collection('jobposts')
        .where('lastDate',
            isGreaterThanOrEqualTo: Timestamp.fromDate(DateTime.now()) )
        .orderBy('lastDate', descending: false)
        .get();
    List documents = snapShot.docs;
    _closingJobs = documents.map((e) => JobPost.fromSnapshotData(e)).toList();
    return _closingJobs;
  }

  Future<List<JobPost>> getJobsByCategories(String categoryTag) async {
    if (_categoryJobs[categoryTag] != null) {
      return _categoryJobs[categoryTag];
    }
    var snapShot = await getFirestore()
        .collection('jobposts')
        .where("tags", arrayContains: categoryTag)
        .orderBy('createdDate', descending: true)
        .limit(10)
        .get();
    List documents = snapShot.docs;
    print(documents);
    _categoryJobs[categoryTag] =
        documents.map((e) => JobPost.fromSnapshotData(e)).toList();
    return _categoryJobs[categoryTag];
  }

  Future<List<JobPost>> getNextJobPostByCategory(String categoryTag, DocumentSnapshot lastEle) async{
       var snapShot = await getFirestore()
        .collection('jobposts')
        .where("tags", arrayContains: categoryTag)
        .orderBy('createdDate',  descending: true)
        .startAfterDocument(lastEle)
        .limit(10)
        .get();
     List documents = snapShot.docs;
      return documents.map((e) => JobPost.fromSnapshotData(e)).toList();
  }

  Future<List<Category>> getCategories() async {
    if (_categoryList != null) {
      return _categoryList;
    }
    var snapShot = await getFirestore().collection('categories').get();
    List<DocumentSnapshot> documents = snapShot.docs;

    _categoryList =
        documents.map((e) => Category.fromSnapshot(e.data())).toList();
    return _categoryList;
  }

  Future<List<Attachment>> getStudyMaterialsList() async {
    if (_studyMaterialList == null) {
      var snapshot =
          await getFirestore().collection('studymaterial').get();
      List<DocumentSnapshot> documents = snapshot.docs;
      print('At service>>>>>>>>>.' + documents.length.toString());
      _studyMaterialList = documents
          .map((e) => Attachment.fromMap(e.data()))
          .toList();
    }
    return _studyMaterialList;
  }

  Future<List<JobPost>> searchJobPost(List<String> searchText) async{
     print(searchText.toString());
       var snapShot = await getFirestore()
        .collection('jobposts')
        .where("searchTexts", arrayContainsAny: searchText)
        
        //.orderBy('createdDate',  descending: true)
        .get();
     List documents = snapShot.docs;
     print(documents.toString());
      return documents.map((e) => JobPost.fromSnapshotData(e)).toList();
  }


  FirebaseFirestore getFirestore() {
    if (_firestore == null) _firestore = FirebaseFirestore.instance;
    return _firestore;
  }
}
