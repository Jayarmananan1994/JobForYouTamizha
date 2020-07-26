import 'package:flutter/material.dart';
import 'package:flutter_plugin_pdf_viewer/flutter_plugin_pdf_viewer.dart';
import 'package:jobforyoutamizha/model/JobPost.dart';
import 'package:photo_view/photo_view.dart';
import 'package:webview_flutter/webview_flutter.dart';

class OpenFile extends StatefulWidget {
  static const String PATH = '/open-file';
  final Attachment attachment;
  OpenFile({this.attachment});

  @override
  _OpenFileState createState() => _OpenFileState();
}

class _OpenFileState extends State<OpenFile> {
  int pages;
  bool isReady;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(widget.attachment.fileName)),
      body: getViewDetail(),
      //floatingActionButton: favoriteButton(),
    );
  }

  getViewDetail() {
    print("url:"+widget.attachment.fileUrl);
    if (isImage(widget.attachment.fileUrl)) {
      print("Image");
      return displayAsImage(widget.attachment.fileUrl);
    } else if (widget.attachment.fileUrl.contains(".pdf")) {
      print("pdf");
      return displayAsPdf(widget.attachment.fileUrl);
    } else {
       print("web view");
      return displayInWebView(widget.attachment.fileUrl);
    }
  }

  isImage(String url) {
    var extns = ['.jpeg', '.png', '.jpg'];
    bool isImage = false;
    int i = 0;
    while (!isImage && i <= extns.length - 1) {
      if (url.contains(extns[i])) {
        isImage = true;
      } else {
        ++i;
      }
    }
    return isImage;
  }

  favoriteButton() {
    return FloatingActionButton(
        onPressed: () {}, child: Icon(Icons.file_download));
  }

  displayInWebView(url) {
    return WebView(
      initialUrl: 'url', //widget.attachment.fileUrl,
      javascriptMode: JavascriptMode.unrestricted,
      onPageStarted: (String url) {
        print('Page started loading: $url');
      },
      onPageFinished: (String url) {
        print('Page finished loading: $url');
      },
      gestureNavigationEnabled: true,
    );
  }

  displayAsImage(url) {
    return Container(
        child: PhotoView(
      imageProvider: NetworkImage(url),
    ));
  }

  FutureBuilder displayAsPdf(path) {
    return FutureBuilder(
      future: PDFDocument.fromURL(path),
      builder: (context, snaphot) {
        if (snaphot.hasData) {
          PDFDocument document = snaphot.data;
          return PDFViewer(
            document: document,
            showPicker: false,
          );
        } else if (snaphot.hasError) {
          print(snaphot.error);
          return Center(child: Text('Could not load the PDF'));
        } else {
          return Center(child: CircularProgressIndicator());
        }
      },
    );
    //var document = await PDFDocument.fromURL(path);
  }
}
