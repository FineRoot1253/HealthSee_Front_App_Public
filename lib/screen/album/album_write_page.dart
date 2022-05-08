import 'dart:async';
import 'dart:io';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:heathee/controller/account_controller.dart';
import 'package:heathee/controller/album/album_detail_controller.dart';
import 'package:heathee/controller/album/album_main_controller.dart';
import 'package:heathee/keyword/color.dart';
import 'package:heathee/screen/album/widget/PhotoSelectWidget.dart';
import 'package:path_provider/path_provider.dart';

class AlbumWritePage extends StatefulWidget {
  @override
  _AlbumWritePageState createState() => _AlbumWritePageState();
}

class _AlbumWritePageState extends State<AlbumWritePage> {
  Directory tempDir;
  Future<Directory> exiDir;
  String path;
  String fileName;
  int scope = 1;
  AlbumDetailController _albumDetailController;
  AlbumMainController _albumMainController;

  final TextEditingController contentEditingController = TextEditingController();


  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    exiDir =  getTemporaryDirectory();
    _albumMainController = Get.arguments;
    _albumDetailController = _albumMainController.albumDetailController;
    _albumDetailController.uploadFileList = [];

  }

  @override
  void dispose() {
    // TODO: implement dispose
    contentEditingController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final Size size = MediaQuery.of(context).size;

    final bottom = MediaQuery.of(context).viewInsets.bottom;
    return buildMain(size,bottom);
  }

  buildMain(size,bottom) {
    return GetBuilder<AlbumMainController>(builder: (_) {
      return FutureBuilder(
        future: exiDir,
        builder: (context, snapshot){
          if(snapshot.connectionState == ConnectionState.done){
            return Scaffold(
              resizeToAvoidBottomInset: false,
              resizeToAvoidBottomPadding: false,
              body: SingleChildScrollView(
                reverse: true,
                scrollDirection: Axis.vertical,
                physics: ScrollPhysics(),
                child: Padding(
                  padding: EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom),
                  child: Container(
                    color: BACKGROUND_COLOR,
                    height: size.height,
                    width: size.width,
                    child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: <Widget>[
                          buttonTile(),
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Divider(
                              height: 1.0,
                              color: Colors.white60,
                            ),
                          ),
                          Expanded(
                              child: Wrap(
                                children: <Widget>[PhotoSelectWidget(exiDir: snapshot.data,)],)),
                          Container(
                            padding: EdgeInsets.only(top: 15.0),
                            height: Get.height*0.2,
                            child: TextFormField(
                              controller: contentEditingController,
                              maxLines: 10,
                              keyboardType: TextInputType.multiline,
                              decoration: InputDecoration(
                                  hintText: "내용을 입력해주세요.",
                                  hintStyle: TextStyle(color: Colors.white),
                                  fillColor: CONTENT_COLOR,
                                  filled: true,
                                  border: OutlineInputBorder(
                                    borderSide: BorderSide(
                                      color: CONTENT_COLOR,
                                    ),
                                  )),
                              style: TextStyle(color: Colors.white),
                            ),
                          ),
                        ]),
                  ),
                ),
              ),
              appBar: wpAppbar(snapshot.data),
            );
          }
          return Center(child: CircularProgressIndicator(),);
        },
      );

    });
  }

  wpAppbar(exiDir) {
    return AppBar(
      backgroundColor: BACKGROUND_COLOR,
      centerTitle: true,
      leading: IconButton(
        icon: Icon(Icons.arrow_back),
        color: Colors.white,
        onPressed: () {
          exiDir.deleteSync(recursive: true);
          //tempDir.deleteSync(recursive: true);
          PaintingBinding.instance.imageCache.clear();
          print("임시사진 삭제 완료");
          _albumDetailController.uploadFileList = [];
          Get.back();
        },
      ),
      title: Text(
        '앨 범',
        style: TextStyle(fontFamily: "JUA", fontSize: 25, color: Colors.white),
      ),
      actions: <Widget>[
        RaisedButton(
          child: Text(
            '완료',
            style:
            TextStyle(fontFamily: "JUA", fontSize: 25, color: Colors.white),
          ),
          onPressed: () async {
            AlbumMainController.to.setMode(false);
            //List<File> files = await convertAsset();
            if (_albumDetailController.uploadFileList.length == 0) {
              Get.snackbar("경고", "사진 없이 앨범을 업로드 할수 없습니다");
              return;
            }

            await _albumDetailController.postAlbum(
                Account_AC_NickName: AccountController.to.nickname,
                AL_Content: contentEditingController.text,
                AL_Scope: scope.toString(),
                AL_Picture: _albumDetailController.uploadFileList);
          },
        )
      ],
    );
  }

  buttonTile() {
    return IconButton(
      iconSize: 30,
      icon: (scope == 1) ? Icon(Icons.lock_open) : Icon(Icons.lock_outline),
      onPressed: () {
        setState(() {
          if (scope == 1) {
            scope = 0;
            Get.snackbar("경고", "현재 비공개입니다");
          } else {
            scope = 1;
            Get.snackbar("경고", "현재 공개입니다");
          }
        });
      },
    );
  }

}
