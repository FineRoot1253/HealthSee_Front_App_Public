import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:heathee/api/timeset.dart';
import 'package:heathee/controller/album/album_detail_controller.dart';
import 'package:heathee/controller/album/album_main_controller.dart';
import 'package:heathee/controller/http_controller.dart';
import 'package:heathee/keyword/ip.dart';
import 'package:heathee/keyword/url.dart';
import 'package:heathee/model/album/album_list.dart';
import 'package:heathee/widget/dialog.dart';

class AlbumPost extends StatelessWidget {
  final AlbumList separatedAlbumList;
  final AlbumMainController albumMainController;

  AlbumPost(this.albumMainController, this.separatedAlbumList);

  @override
  Widget build(BuildContext context) {
    print(albumMainController.isCancel);
    return Stack(children: <Widget>[
      Container(
        width: Get.width * 0.2,
        height: Get.height * 0.2,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(5),
        ),
        child: Card(
          elevation: 0,
          shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(5)),
          child: InkWell(
              onTap: () async {
//                    await isolateRead(separatedAlbumList.AL_Code);
//                    await albumMainController.albumDetailController
//                        .isolateRead(separatedAlbumList.AL_Code);
               await albumMainController.albumDetailController
                    .readAlbum(separatedAlbumList.AL_Code);
                Get.toNamed('/albumChosen',
                    arguments: albumMainController.albumDetailController);
              },
              child: Column(children: <Widget>[Expanded(child: separatedAlbumList.AL_Thumbnail,),Text(getDate(separatedAlbumList.AL_Creation_Date, "DATE"))],)),
        ),
      ),
      (albumMainController.isCancel) ? printCancel() : printNothing()
    ]);
  }

  printCancel() {
    return Positioned(
        left: Get.width*0.11,
        bottom: Get.height*0.055,
        child: IconButton(
            icon: Icon(Icons.cancel),
            onPressed: () async {
              int index = separatedAlbumList.AL_Code;
              bool result = await yesOrNoDialog("사진 포스트 삭제", "이 사진 포스트를 삭제하시겠습니까?");
              if(result) {
                albumMainController.albumDetailController.deleteAlbum(index,separatedAlbumList.Account_AC_NickName);
                albumMainController.init(separatedAlbumList.Account_AC_NickName);
              }
            }));
  }

  printNothing() {
    return Container(
      width: 0.0,
      height: 0.0,
    );
  }
}