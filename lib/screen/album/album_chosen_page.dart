import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:heathee/controller/account_controller.dart';
import 'package:heathee/controller/album/album_detail_controller.dart';
import 'package:heathee/controller/album/album_main_controller.dart';
import 'package:heathee/keyword/color.dart';
import 'package:get/get.dart';
import 'package:heathee/screen/album/widget/album_comment_widget.dart';

class AlbumChosenPage extends StatefulWidget {
  @override
  _AlbumChosenPageState createState() => _AlbumChosenPageState();
}

class _AlbumChosenPageState extends State<AlbumChosenPage> {
  final TextEditingController editingController = TextEditingController();
  AlbumDetailController _albumDetailController;
  List<Widget> action = [];
  List<Image> _imageList =List<Image>();
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _albumDetailController = Get.arguments;
    action.clear();
    (AlbumMainController.to.albumListController.currentNickname == AccountController.to.nickname) ? action.add(actionButton(_albumDetailController)) : action.clear() ;
  }
//  setImageList(){
//    _imageList=[];
//    for(int i = 0 ; i<_albumDetailController.getAlbumDetail.AL_Picture.length ; i++){
//      Uint8List uint8list = _albumDetailController.getAlbumDetail.AL_Picture[i];
//      Image _image = Image.memory(uint8list);
//      _imageList.add(_image);
//    }
//  }
  @override
  Widget build(BuildContext context) {
    final Size size = MediaQuery.of(context).size;
    return GetBuilder<AlbumDetailController>(
        init: AlbumDetailController(),
        builder: (_) {
          return Scaffold(
              appBar: AppBar(
                backgroundColor: BACKGROUND_COLOR,
                centerTitle: true,
                leading: IconButton(icon: Icon(Icons.arrow_back), onPressed: () async {
                  await AlbumMainController.to.init(_albumDetailController.detail.nickname);
                  AlbumMainController.to.update();
                  Get.back();
                }),
                title: Text(
                  '앨 범',
                  style: TextStyle(
                      fontFamily: "JUA", fontSize: 25, color: Colors.white),
                ),
                actions: action,
              ),
              body: Container(
                color: BACKGROUND_COLOR,
                height: size.height,
                width: size.width,
                child: SingleChildScrollView(
                  scrollDirection: Axis.vertical,
                  child: Container(
                    padding: EdgeInsets.all(8),
                    color: CONTENT_COLOR,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        photoPageView(_),
                        Divider(
                          height: 1.0,
                          color: Colors.white60,
                        ),
//              Expanded(child: photoTile.image),
                        Container(
                            padding: const EdgeInsets.all(6.0),
                            height: size.height * 0.2,
                            child: Text(_.getAlbumDetail.AL_Content,

                                style: TextStyle(fontSize :15 ,color: Colors.white70))),
                        Divider(
                          height: 1.0,
                          color: Colors.white60,
                        ),
                        AlbumCommentWidget(_),
                      ],
                    ),
                  ),
                ),
              ));
        });
  }

  actionButton(_){
    return  RaisedButton(
        child: Text(
          '편집',
          style: TextStyle(
              fontFamily: "JUA",
              fontSize: 20,
              color: Colors.white),
        ),
        onPressed: () {
          if(_.getAlbumDetail.AL_Picture.length != _.pictureCount)
            Get.snackbar("경고!", "사진 로딩이 다되어야 편집을 할수있습니다");
          else
            Get.toNamed('/albumEdit', arguments: _);
        });
  }

  photoPageView(controller) {
    int _index = 0;
    print("사진 배열 길이 : "+controller.getAlbumDetail.AL_Picture.length.toString());
    print("현포스트 코드 : ${controller.getAlbumDetail.code}");
    Future<dynamic> result;

    return Container(
      height: Get.height * 0.6,
      width: Get.width,
      child: SizedBox(
        height: Get.height * 0.8,
        child: PageView.builder(
          controller: PageController(viewportFraction: 0.7),
          //TODO: 페이지가 바뀔때 이미지 호출 요청 보내기 futureBuilder를 리턴하게끔, + 변동성 있는 카운트가 되는지를 봐야함
          onPageChanged: (int index) => setState(() =>_index = index),
          itemBuilder: (_, i) {
            print("총 그릴 길이:${controller.pictureCount}");
            return Transform.scale(
              scale: i == _index ? 1 : 0.9,
              child: (_albumDetailController.getAlbumPicutureList[i] != null) ?
              _albumDetailController.getAlbumPicutureList[i].AL_Picture ?? Center(child: CircularProgressIndicator(),) :
              FutureBuilder(
                future: _albumDetailController.readPicture((_albumDetailController.getAlbumPicutureList[0].AP_Code+i),i),
                builder: (context, snapshot){
                  if(snapshot.connectionState == ConnectionState.done){
                    return (_albumDetailController.getAlbumPicutureList[i] != null) ? _albumDetailController.getAlbumPicutureList[i].AL_Picture : Center(child: CircularProgressIndicator(),);
                  }else if(snapshot.hasError){
                    return Text("오류 발생 \n ${snapshot.error.toString()}");
                  }return Center(child: CircularProgressIndicator(),);
                },
              ),
            );
//            if(_albumDetailController.getAlbumPicutureList[i] != null){
//              return Transform.scale(
//                scale: i == _index ? 1 : 0.9,
//                child: (_imageList==null) ?
//                Center(child: CircularProgressIndicator(),) :
//                _imageList[i],
//              );
//            }else {
//              return FutureBuilder(
//                  future: result,
//                  builder: (context, snapshot) {
//                    return Transform.scale(
//                      scale: i == _index ? 1 : 0.9,
//                      child: (_imageList == null) ?
//                      Center(child: CircularProgressIndicator(),) :
//                      _imageList[i],
//                    );
//                  }
//              );
//            }
          },
          itemCount: controller.pictureCount,
        ),
      ),
    );
  }
}
