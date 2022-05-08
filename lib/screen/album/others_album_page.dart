import 'package:flutter/material.dart';
import 'package:heathee/controller/album/album_main_controller.dart';
import 'package:heathee/keyword/color.dart';
import 'package:get/get.dart';
import 'package:heathee/keyword/key.dart';
import 'package:heathee/model/album/album_list.dart';
import 'package:heathee/model/util/error.dart';
import 'package:heathee/screen/album/album_sliver_list_widget.dart';
import 'package:heathee/screen/album/widget/album_button_bar.dart';

class OthersAlbumPage extends StatefulWidget {
  @override
  _OthersAlbumPageState createState() => _OthersAlbumPageState();
}

class _OthersAlbumPageState extends State<OthersAlbumPage> {
  String appBarStr = '편집';
  String userNickName;
  List<String> month;
  Future<dynamic> result;
  Future<List<AlbumList>> resultList;
  final GlobalKey<RefreshIndicatorState> _refreshIndicatorKey =
  new GlobalKey<RefreshIndicatorState>();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    AlbumMainController.to.albumListController.year = NOWYEAR;
    userNickName = Get.arguments;
    AlbumMainController.to.albumListController.currentNickname = userNickName;
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    print("다른사람 페이지지 : $userNickName");
    return Container(
        height: Get.height * 0.8,
        width: Get.width,
        child: GetBuilder<AlbumMainController>(
            init: AlbumMainController(),
            initState: (_) async {
              print("다른 사람 페이지 init");
              try {
                result = AlbumMainController.to.init(userNickName);
              }on InBlackListException{
                Get.back();
                Get.snackbar("경고", "넌 불낙이야");
              }
//              AlbumMainController.to.albumListController.listResult = AlbumMainController.to.albumListController.init(userNickName);
            },
            builder: (_) {
              return Scaffold(
                backgroundColor: BACKGROUND_COLOR,
                appBar: commonAppBar(),
                body: FutureBuilder(
                    future: result,
                    builder: (context, snapshot) {
                      if (snapshot.connectionState == ConnectionState.done) {
                        return Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            AlbumMenuBar(
                                AlbumMainController.to,
                                _.albumListController.year.toString() + "년",
                                "선택"),
                            Expanded(
                                child: monthBarColumn(AlbumMainController
                                    .to.albumListController)),
                          ],
                        );
                      } else if (snapshot.hasError) {
                        return Center(
                          child: Column(
                            children: <Widget>[
                              Text("오류 발생"),
                              FlatButton(
                                child: Text("확인"),
                                onPressed: () => Get.back(),
                              )
                            ],
                          ),
                        );
                      } else {
                        return Center(
                          child: CircularProgressIndicator(),
                        );
                      }
                    }),
              );
            }));
  }

  commonAppBar() {
    return AppBar(
      backgroundColor: CONTENT_COLOR,
      leading: IconButton(
        color: Colors.black,
        icon: Icon(Icons.arrow_back),
        onPressed: () => Get.back(),
      ),
      title: Text(
        '$userNickName님의 앨 범',
        style: TextStyle(
            fontSize: 25,
            color: Colors.white,
            fontFamily: 'JUA',
            fontStyle: FontStyle.normal),
      ),
      centerTitle: true,
    );
  }

  monthBarColumn(albumListController) {
    return RefreshIndicator(
        key: _refreshIndicatorKey,
        onRefresh: () async {
          AlbumMainController.to.albumListController
              .refreshAlbumLists(userNickName);
        },
        child: AlbumSliverWidget(
                    albumMainController: AlbumMainController.to,
                    albumList: albumListController.albumLists)
              );
  }
}

//
//GetBuilder<AlbumMainController>(
//init:AlbumMainController(),
//builder:(_) {
//return
