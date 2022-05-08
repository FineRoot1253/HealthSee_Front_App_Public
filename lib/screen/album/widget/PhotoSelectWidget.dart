import 'dart:io';
import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_absolute_path/flutter_absolute_path.dart';
import 'package:get/get.dart';
import 'package:heathee/controller/album/album_main_controller.dart';
import 'package:heathee/keyword/color.dart';
import 'package:multi_image_picker/multi_image_picker.dart';
import 'package:path_provider/path_provider.dart';

class PhotoSelectWidget extends StatefulWidget {
  final Directory exiDir;

  PhotoSelectWidget({this.exiDir});

  @override
  _PhotoSelectWidgetState createState() => _PhotoSelectWidgetState();
}

class _PhotoSelectWidgetState extends State<PhotoSelectWidget> {
  List<Asset> _images = [];
  File uploadThumb;

  Directory tempDir;
  final _channel = MethodChannel("/gallery");

  @override
  Widget build(BuildContext context) {
    return buildGridView(widget.exiDir);
  }

  buildGridView(exiDir) {
    int len = 0;
    if(AlbumMainController.to.albumDetailController.uploadFileList.length==0)
      len += 1;
    else
      len += AlbumMainController.to.albumDetailController.uploadFileList.length;
    return Center(
      child: GridView.count(
        physics: NeverScrollableScrollPhysics(),
        shrinkWrap: true,
        crossAxisCount: 3,
        children: List.generate(len, (index) {
          if (len == index + 1) {
            return gridTileButton(exiDir);
          } else {
            return InkWell(
                onTap: () {
                  Get.toNamed("/albumChoose",
                      arguments: AlbumMainController
                          .to.albumDetailController.uploadFileList);
                },
                child: Image.file(
                  AlbumMainController
                      .to.albumDetailController.uploadFileList[index],
                  width: 300,
                  height: 300,
                ));
          }
        }),
      ),
    );
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
              exiDir.deleteSync(recursive: true);
              //tempDir.deleteSync(recursive: true);
              PaintingBinding.instance.imageCache.clear();
              uploadThumb = null;
              print("임시사진 삭제 완료");
              await dirSetting(exiDir);

              loadImages();
            },
          ),
        ),
      ),
    );
  }

  dirSetting(exiDir) async {
    String dirPath = "${exiDir.path}/123";
    tempDir = await Directory(dirPath).create(recursive: true);
    print("조정된 경로 :" + tempDir.path);
  }

  Future loadImages() async {
    List<Asset> resultList = List<Asset>();
    try {
      //TODO: isolate 시켜야함
      resultList = await MultiImagePicker.pickImages(
          maxImages: 10,
          enableCamera: true,
          selectedAssets: _images,
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
    _images = resultList;
    compressDialog();
    AlbumMainController.to.albumDetailController.uploadFileList =
    await convertAsset();
    Get.back();
    setState(() {});
  }

  Future<List<File>> convertAsset() async {
    List<File> file = [];
    print("보내기 직전 : " + _images.length.toString());
    for (int i = 0; i < _images.length; i++) {
      String path =
      await FlutterAbsolutePath.getAbsolutePath(_images[i].identifier);
      File tempFile = File(path);
      if (_images[i].originalWidth > 960 ||
          _images[i].originalHeight > 960 ||
          i == 0) {
        tempFile = await fileToImage(File(path), i);
      }
      file.add(tempFile);
    }

    file.add(uploadThumb);

    return file;
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
            _images.length)
            ? Text("파일 로드 완료")
            : Center(
          child: CircularProgressIndicator(),
        ));
  }

}
