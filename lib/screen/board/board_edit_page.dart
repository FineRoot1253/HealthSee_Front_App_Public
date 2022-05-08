import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:get/get.dart';
import 'package:heathee/controller/board/board_detail_controller.dart';
import 'package:heathee/keyword/color.dart';
import 'package:heathee/keyword/font.dart';
import 'package:heathee/model/board/post_detail.dart';
import 'package:file_picker/file_picker.dart';
import 'package:heathee/model/util/error.dart';
import 'package:heathee/widget/bar/category_bar.dart';

class BoardEditPage extends StatefulWidget {
  @override
  _BoardWritePageState createState() => _BoardWritePageState();
}

class _BoardWritePageState extends State<BoardEditPage> {
  PostDetailController postDetailController;
  PostDetail postDetail;
  List<dynamic> oldFile;
  List<File> files;
  bool isFilePicked;
  bool noChangedOrDeleted = false;
  TextEditingController title = TextEditingController();
  TextEditingController content = TextEditingController();
  String dropdownValue;
  String category;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    postDetailController = Get.arguments;
    postDetail = postDetailController.detail;
    title.text = postDetail.title;
    content.text = postDetail.content;
    if (postDetail.file != null) {
      oldFile = postDetail.file;
      isFilePicked = true;
    }
  }

  @override
  void dispose() {
    // TODO: implement dispose
    title?.dispose();
    content?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        FocusScopeNode currentFocus = FocusScope.of(context);
        if (!currentFocus.hasPrimaryFocus) {
          currentFocus.unfocus();
        }
      },
      child: Scaffold(
        appBar: AppBar(
          title: Text("게시글 수정"),
          centerTitle: true,
          actions: <Widget>[
            FlatButton(
                onPressed: () async {
                  doWriteBoard();
                },
                child: Text(
                  "수정",
                  style: LITTLE_TEXT_STYLE,
                ))
          ],
        ),
        body: ListView(
          children: <Widget>[
            buildTitle(),
            buildUplodedFile(),
            buildFile(),
            buildContent(),
          ],
        ),
      ),
    );
  }

  Column buildContent() {
    return Column(
      children: <Widget>[
        CategoryBar("내용"),
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: TextFormField(
            controller: content,
            maxLines: 10,
            keyboardType: TextInputType.multiline,
            //textInputAction: TextInputAction.newline,
            style: LITTLE_TEXT_STYLE,
            decoration: InputDecoration(
              fillColor: CONTENT_COLOR,
              filled: true,
              border: OutlineInputBorder(
                borderSide: BorderSide(
                  color: CONTENT_COLOR,
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget buildUplodedFile() {
    return Container(
      height: 160,
      child: Column(
        children: <Widget>[
          CategoryBar("이미 업로드된 첨부파일"),
          (postDetail.file != null)
              ? ListView.builder(
                  physics: NeverScrollableScrollPhysics(),
                  shrinkWrap: true,
                  itemCount: postDetail.file.length,
                  itemBuilder: (context, i) {
                    return Row(
                      children: <Widget>[
                        Icon(Icons.attachment),
                        Text(
                          postDetail.file[i],
                          style: TextStyle(fontSize: 8),
                        ),
                        GestureDetector(
                          onTap: () {
                            setState(() {
                              postDetail.file.remove(postDetail.file[i]);
                            });
                          },
                          child: Icon(Icons.clear),
                        )
                      ],
                    );
                  })
              : Container(
                  child: Text("첨부된 파일이 없습니다."),
                )
        ],
      ),
    );
  }

  Widget buildFile() {
    return Container(
      height: 160,
      child: Column(
        children: <Widget>[
          CategoryBar("첨부파일"),
          FlatButton(
              onPressed: () async {
                files = await filePickerOn();
                setState(() {
                  isFilePicked = !isFilePicked;
                });
              },
              child: Text('첨부')),
          (files != null)
              ? ListView.builder(
                  physics: NeverScrollableScrollPhysics(),
                  shrinkWrap: true,
                  itemCount: files.length,
                  itemBuilder: (context, i) {
                    return Row(
                      children: <Widget>[
                        Icon(Icons.attachment),
                        Text(
                          files[i].path,
                          style: TextStyle(fontSize: 8),
                        ),
                        GestureDetector(
                          onTap: () {
                            setState(() {
                              files.removeAt(i);
                            });
                          },
                          child: Icon(Icons.clear),
                        )
                      ],
                    );
                  })
              : Container(
                  child: Text("첨부한 파일이 없습니다."),
                )
        ],
      ),
    );
  }

  Column buildTitle() {
    return Column(
      children: <Widget>[
        CategoryBar("제목"),
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: TextFormField(
            controller: title,
            style: LITTLE_TEXT_STYLE,
            decoration: InputDecoration(
                fillColor: CONTENT_COLOR,
                filled: true,
                border: OutlineInputBorder(
                    borderSide: BorderSide(
                  color: CONTENT_COLOR,
                ))),
          ),
        ),
      ],
    );
  }

  void doWriteBoard() async {
    String leaveFile;
    for (var file in postDetail.file) {
      if (leaveFile == null)
        leaveFile = file;
      else
        leaveFile = leaveFile + "," + file;
    }
    var BO_Title = title.text;
    var BO_Content = content.text;

    if (BO_Title != "" && BO_Content != "") {
      try {
        await postDetailController.updatePost(
            title: BO_Title,
            content: BO_Content,
            uploadFiles: files,
            leaveFile: leaveFile);
      } on BlindPostException {
        Get.snackbar("블라인드 게시글", "블라인드 처리된 게시글을 열람하실 수 없습니다.");
      }
    } else {
      Get.snackbar("작성 에러", "제목과 내용을 작성해주세요.");
    }
  }

  filePickerOn() async {
    return await FilePicker.getMultiFile();
  }
}
