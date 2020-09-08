import 'package:flutter/material.dart';
import 'package:jobforyoutamizha/model/JobPost.dart';
import 'package:jobforyoutamizha/service/job_info_service.dart';
import 'package:jobforyoutamizha/service_locator.dart';
import 'package:jobforyoutamizha/tabs/study_materials/open_file.dart';
// import 'package:downloads_path_provider/downloads_path_provider.dart';

class StudyMaterials extends StatefulWidget {
  @override
  _StudyMaterialsState createState() => _StudyMaterialsState();
}

class _StudyMaterialsState extends State<StudyMaterials> {
  bool downloading = false;

  String progress = '0';

  bool isDownloaded = false;

  JobInfoService _jobInfoService = locator<JobInfoService>();
  @override
  Widget build(BuildContext context) {
    return Container(
      child: FutureBuilder<List<Attachment>>(
          future: _jobInfoService.getStudyMaterialsList(),
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              var smItems = snapshot.data;
              return ListView.builder(
                  itemBuilder: (context, index) {
                    return ListTile(
                      title: Text(smItems[index].fileName),
                      trailing: FlatButton(
                          child: Text('Open', style: TextStyle(color: Colors.blue)),
                          onPressed: () => openFile(smItems[index])),
                    );
                  },
                  itemCount: smItems.length);
            } else if (snapshot.hasError) {
              print(snapshot.error);
              return Center(
                  child: Container(
                      width: 250,
                      child: Text(
                          "Could not get Study material. Please check your internet or try again later")));
            } else {
              return Center(
                child: CircularProgressIndicator(),
              );
            }
          }),
    );
  }

  // _downloadFile(Attachment smItem) async {
  //   String fileSavePath = await _getFilePath(smItem.fileName);
  //   print(fileSavePath);
  //   Dio dio = Dio();
  //   dio.download(smItem.fileUrl, fileSavePath, onReceiveProgress: (rcv, total) {
  //     print(
  //         'received: ${rcv.toStringAsFixed(0)} out of total: ${total.toStringAsFixed(0)}');

  //     setState(() {
  //       progress = ((rcv / total) * 100).toStringAsFixed(0);
  //     });

  //     if (progress == '100') {
  //       setState(() {
  //         isDownloaded = true;
  //       });
  //     } else if (double.parse(progress) < 100) {}
  //   }).then((_) {
  //     setState(() {
  //       if (progress == '100') {
  //         isDownloaded = true;
  //       }

  //       downloading = false;
  //     });
  //   });
  // }

  // Future<String> _getFilePath(uniqueFileName) async {
  //   String path = '';

  //   Directory dir = await await DownloadsPathProvider.downloadsDirectory; //getExternalStorageDirectory();

  //   path = '${dir.path}/$uniqueFileName';

  //   return path;
  // }

  void openFile(Attachment smItem) async{
      Navigator.of(context).pushNamed(OpenFile.PATH, arguments: smItem);
       
  }
}
