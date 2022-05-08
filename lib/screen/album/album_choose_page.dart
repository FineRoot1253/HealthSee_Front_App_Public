import 'dart:io';
import 'package:flutter/material.dart';
import 'package:heathee/controller/album/album_detail_controller.dart';
import 'package:heathee/keyword/color.dart';
import 'package:get/get.dart';
import 'package:heathee/model/album/album_detail.dart';

class AlbumChoosePage extends StatefulWidget {
  @override
  _AlbumChoosePageState createState() => _AlbumChoosePageState();
}

class _AlbumChoosePageState extends State<AlbumChoosePage> {
  final TextEditingController editingController = TextEditingController();
  String appStr = "편집" ;
  bool isReadMode=true;
  AlbumDetailController _albumDetailController;
  Album album;
  List<Image> _imageList = List<Image>();
  List<File> _assetList = List<File>();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
//    List<dynamic> list = _albumDetailController.getAlbumDetail.AL_Picture;
//    list.forEach((e) {
//      Image _image = Image.memory(Uint8List.fromList(e.cast<int>()));
//      _imageList.add(_image);
//    });
  }
  @override
  Widget build(BuildContext context) {
//    dynamic photoTile = Get.arguments;
    _assetList = Get.arguments;
    final Size size = MediaQuery.of(context).size;
    return Scaffold(
      appBar: AppBar(
        backgroundColor: BACKGROUND_COLOR,
        centerTitle: true,
        leading: IconButton(icon: Icon(Icons.arrow_back),onPressed: () => Get.back(),),
        title: Text(
          '상세보기',
          style: TextStyle(fontFamily: "JUA", fontSize: 25, color: Colors.white),
        ),
      ),
      body: Container(
            color: BACKGROUND_COLOR,
            height: size.height,
            width: size.width,
            child:photoPageView(),
          ),
    );
  }
  photoPageView(){
    int _index = 0;
    return Center(
      child: SizedBox(
        height: Get.height*0.8,
        child: PageView.builder(
          controller: PageController(viewportFraction: 0.7),
          onPageChanged: (int index) => setState(() => _index = index),
          itemBuilder: (_,i){
            return Transform.scale(
              scale: i == _index ? 1 : 0.9,
              child: InkWell(
                  onTap: (){
                    Get.back();
                  },
                  child: (_assetList==null) ?
              Center(child: CircularProgressIndicator(),) :
                      Image.file(_assetList[i])
//                  AssetThumb(asset: _assetList[i],width: (Get.width*0.8).floor(),height: (Get.height*0.8).floor(),),
            ),
            );
          },
          itemCount: _assetList.length,
        ),
      ),
    );
  }
}

