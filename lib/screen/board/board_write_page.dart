import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:get/get.dart';
import 'package:heathee/controller/account_controller.dart';
import 'package:heathee/controller/board/board_detail_controller.dart';
import 'package:heathee/keyword/color.dart';
import 'package:heathee/keyword/font.dart';
import 'package:file_picker/file_picker.dart';
import 'package:heathee/model/auth/member.dart';
import 'package:heathee/widget/bar/category_bar.dart';

class BoardWritePage extends StatefulWidget {
  @override
  _BoardWritePageState createState() => _BoardWritePageState();
}

class _BoardWritePageState extends State<BoardWritePage> {
  Member myMember;
  List<File> files;
  List<String> strings = ["자유게시판", "운동게시판"];
  bool isFilePicked = false;
  TextEditingController title = TextEditingController();
  TextEditingController content = TextEditingController();
  String dropdownValue;
  String category = Get.parameters['category'];
  PostDetailController postDetailController = Get.put(PostDetailController());

  @override
  void dispose() {
    // TODO: implement dispose
    title?.dispose();
    content?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    myMember = AccountController.to.myMember;
    print("리빌드");
    return GestureDetector(
      onTap: () {
        FocusScopeNode currentFocus = FocusScope.of(context);
        if (!currentFocus.hasPrimaryFocus) {
          currentFocus.unfocus();
        }
      },
      child: Scaffold(
        appBar: AppBar(
          title: Text("게시글 작성"),
          centerTitle: true,
          actions: <Widget>[
            FlatButton(
                onPressed: () async {
                  doWriteBoard();
                },
                child: Text(
                  "작성",
                  style: LITTLE_TEXT_STYLE,
                ))
          ],
        ),
        body: ListView(
          children: <Widget>[
            buildTitle(),
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
    var BO_Title = title.text;
    var BO_Content = content.text;
    if (BO_Title != "" && BO_Content != "") {
      await PostDetailController.to
          .writePostDetail(BO_Title, files, myMember.nickname, BO_Content);
    } else {
      Get.snackbar("작성 에러", "제목과 내용을 작성해주세요.");
    }
  }

  filePickerOn() async {
    return await FilePicker.getMultiFile();
  }
}
