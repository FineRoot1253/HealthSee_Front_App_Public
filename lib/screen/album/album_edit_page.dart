import 'dart:typed_data';
import 'package:flutter/services.dart';
import 'package:heathee/model/album/picture.dart';
import 'package:flutter/material.dart';
import 'package:flutter_absolute_path/flutter_absolute_path.dart';
import 'package:get/get.dart';
import 'package:heathee/controller/album/album_detail_controller.dart';
import 'package:heathee/controller/album/album_main_controller.dart';
import 'package:heathee/keyword/color.dart';
import 'package:multi_image_picker/multi_image_picker.dart';
import 'dart:io';

import 'package:path_provider/path_provider.dart';

class AlbumEditPage extends StatefulWidget {
  @override
  _AlbumEditPageState createState() => _AlbumEditPageState();
}

class _AlbumEditPageState extends State<AlbumEditPage> {
  List<Asset> _assetList = [];
  List<dynamic> _tempFileList = List<dynamic>();
  List<Picture> _tempPictureList =List<Picture>();
  List<Image> _exImageList = List<Image>();
  List<File> _uploadImageList = List<File>();
  File uploadThumb = null;
  String leaveImage;
  Image img;
  String path;
  String fileName;
  bool isInited = false;
  int scope = 1;
  Directory tempDir;
  AlbumDetailController albumDetailController;
  final _channel = MethodChannel("/gallery");
  final TextEditingController contentEditingController = TextEditingController();

  @override
  void dispose() {
    // TODO: implement dispose
    contentEditingController.dispose();
    super.dispose();
  }
  void initState() {
    // TODO: implement initState

    super.initState();
    albumDetailController = Get.arguments;
    contentEditingController.text = albumDetailController.detail.AL_Content;
    scope=albumDetailController.detail.AL_Scope;
    _tempFileList= List.from(albumDetailController.detail.AL_Picture);
    _tempPictureList = List.from(albumDetailController.detail.A_Picture);
  }
futuring() async{
  await dirSetting();
  uploadThumb = File('${tempDir.path}/img_thumbnail.jpeg');
  uploadThumb.writeAsBytesSync(_tempFileList[0]);
}
  @override
  Widget build(BuildContext context) {
    return buildMain();
  }

  convertToImage() {
    _exImageList.clear();
      for (int i = 0; i <
          _tempFileList.length; i++) {
        var temp = _tempFileList[i];
          _exImageList.add(Image.memory(temp));

    }
  }

  gridTileButton(exiDir) {
    return GridTile(
      child: Container(
        width: Get.width,
        margin: EdgeInsets.all(10.0),
        decoration: BoxDecoration(
          border: Border.all(width: 1.0, color: Colors.white),
          borderRadius: BorderRadius.circular(10),
          color: CONTENT_COLOR,
        ),
        child: Card(
          child: InkWell(
            child: Icon(Icons.add_to_photos),
            onTap: () async {
              tempDir.deleteSync(recursive: true);
              //tempDir.deleteSync(recursive: true);
              PaintingBinding.instance.imageCache.clear();
              uploadThumb = null;
              print("임시사진 삭제 완료");
              await dirSetting();
              await loadImages();
              setState(() {
              });
            },
          ),
        ),
      ),
    );
  }

  buildGridView(exiDir) {
    convertToImage();
    int len = 0;
    len += (_exImageList.length + _uploadImageList.length) + 1;
    return Center(
      child: GridView.count(
        shrinkWrap: true,
        physics: NeverScrollableScrollPhysics(),
        crossAxisCount: 3,
        children: List.generate(len, (index) {
          if (len == index + 1 ) {
            return gridTileButton(exiDir);
          } else {
            return   Stack(children: <Widget>[
              Container(
                width: Get.width,
                height: Get.height*0.2,
                margin: EdgeInsets.all(10.0),
                decoration: BoxDecoration(
                  border: Border.all(width: 1.0, color: Colors.white),
                  borderRadius: BorderRadius.circular(10),
                  color: CONTENT_COLOR,
                ),
                child: Card(
                  elevation: 0,
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(5)),
                  child: InkWell(
                      onTap: () async {
                        Get.toNamed("/albumChoose", arguments: albumDetailController);
                      },
                    child: (index < _exImageList.length) ?_exImageList[index] : Image.file(_uploadImageList[index-_exImageList.length],width: 300,
                      height: 300,)),
                ),
              ),
              (index < _exImageList.length) ? printCancel(index) : Container(width: 0.0, height: 0.0)
            ]);
          }
        }),
      ),
    );
  }
  printCancel(index) {
    return Positioned(
        left: Get.width*0.22,
        bottom: Get.height*0.12,
        child: IconButton(
            icon: Icon(Icons.remove_circle),
            iconSize: 30,
            color: Colors.red.withOpacity(1.0),
            onPressed: () async {
              setState(() {
                if(leaveImage==null) {
                  leaveImage =
                      albumDetailController.detail.A_Picture[index].AP_Code
                          .toString();
                } else {
                  leaveImage = leaveImage + "," +
                      albumDetailController.detail.A_Picture[index].AP_Code
                          .toString();
                }
                _tempPictureList.removeAt(index);
                _tempFileList.removeAt(index);
                _exImageList.removeAt(index);
                if(index==0)
                  uploadThumb = null;
              });
            }));
  }


  Future loadImages() async {
    List<Asset> resultList = List<Asset>();

    try {
      resultList = await MultiImagePicker.pickImages(
          maxImages: (10 - _exImageList.length),
          enableCamera: true,
          selectedAssets: _assetList,
          cupertinoOptions: CupertinoOptions(takePhotoIcon: "chat"),
          materialOptions: MaterialOptions(
            actionBarColor: "#474b55",
            actionBarTitle: "Image Select",
            allViewTitle: "Photos",
            useDetailsView: false,
            selectCircleStrokeColor: "#000000",
          ));
    } catch (e) {
      print(e.toString());
    }
    if (!mounted) return;
    if(resultList.length==0) return;
    _assetList = resultList;
    compressDialog();
    AlbumMainController.to.albumDetailController.uploadFileList =
    await convertAsset();
    Get.back();
  }

  buttonTile() {
    return IconButton(
      iconSize: 30,
      icon: (scope == 1) ? Icon(Icons.lock_outline) : Icon(Icons.lock_open),
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

   buildMain() {
    return Scaffold(
      body: FutureBuilder(
        future: futuring(),
        builder:(context, snapshot){
          if(snapshot.connectionState==ConnectionState.done)
            return SingleChildScrollView(
              scrollDirection: Axis.vertical,
              physics: ScrollPhysics(),
              child: Container(
                color: BACKGROUND_COLOR,
                height: Get.height,
                width: Get.width,
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
                    Expanded(child:Wrap(children: <Widget>[buildGridView(snapshot.data)],) ,),
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
                  ],
                ),
              ),
            );
          else if(snapshot.hasError)
            return Center(child: Text("에러발생 \n ${snapshot.error.toString()}"),);
          else
            return Center(child: CircularProgressIndicator(),);
        } ,
      ),
      appBar: editPageAppBar()
    );
  }
  editPageAppBar(){
    return AppBar(
      backgroundColor: BACKGROUND_COLOR,
      centerTitle: true,
      title: Text(
        '앨 범',
        style:
        TextStyle(fontFamily: "JUA", fontSize: 25, color: Colors.white),
      ),
      actions: <Widget>[
        RaisedButton(
          child: Text(
            '완료',
            style: TextStyle(
                fontFamily: "JUA", fontSize: 25, color: Colors.white),
          ),
          onPressed: () async {
            AlbumMainController.to.setMode(false);
            await convertAsset();
            if((_exImageList.length + _uploadImageList.length)==0){
              Get.snackbar("경고", "반드시 사진을 넣어야 합니다");
              return;
            }
            albumDetailController.detail.AL_Picture= List.from(_tempFileList);
            albumDetailController.detail.A_Picture = List.from(_tempPictureList);
            _uploadImageList.add(uploadThumb);
            await albumDetailController.updateAlbum(AL_Content: contentEditingController.text, AL_Scope: scope, leavePicture: leaveImage, pictures: _uploadImageList);
          },
        )
      ],
    );
  }

  Future<List<File>> convertAsset() async {
    _uploadImageList =[];
    print("보내기 직전 : " + _assetList.length.toString());
    for (int i = 0; i < _assetList.length; i++) {
      String path =
      await FlutterAbsolutePath.getAbsolutePath(_assetList[i].identifier);
      File tempFile = File(path);
      if (_assetList[i].originalWidth > 960 ||
          _assetList[i].originalHeight > 960 ||
          i == 0) {
        tempFile = await fileToImage(File(path), i);
      }
      _uploadImageList.add(tempFile);
    }


    return _uploadImageList;
  }
  dirSetting() async {
    Directory exDir = await getTemporaryDirectory();
    String dirPath = "${exDir.path}/123";
    tempDir = await Directory(dirPath).create(recursive: true);
    print("조정된 경로 :" + tempDir.path);
  }



  fileToImage(File file, int index) async {
    if (index == 0 && uploadThumb == null) {
      uploadThumb = await convertImgToFile(file, -1, 150);
    }
    File tmepFile = await convertImgToFile(file, index, 960);
    return tmepFile;
  }

  convertImgToFile(File file, int index, int maxDimensions) async {
    String path = tempDir.path;
    String filename = "";
    Uint8List fileList = file.readAsBytesSync();

    print("조정됬는지 검사" + path);

    if (index == -1)
      filename = '$path/img_thumbnail.jpeg';
    else
      filename = '$path/img_$index.jpeg';

    var resizedImg = await _channel.invokeMethod("imgCompress", {
      "imageBytes": fileList,
      "quality": 95,
      "name": filename,
      "maxDimensions": maxDimensions,
      "maxSize": 300
    });
    File tempfile = File(filename);

    print("리사이즈할 사진 경로 : " + tempfile.path);
    print("리사이즈될 사이즈 : " + maxDimensions.toString());
    tempfile.writeAsBytesSync(resizedImg.toList());

    return tempfile;
  }

  compressDialog() {
    return Get.defaultDialog(
        title: "업로드",
        content: (AlbumMainController
            .to.albumDetailController.uploadFileList.length ==
            _assetList.length)
            ? Text("파일 로드 완료")
            : Center(
          child: CircularProgressIndicator(),
        ));
  }
}