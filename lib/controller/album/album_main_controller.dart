import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:heathee/controller/album/album_detail_controller.dart';
import 'package:heathee/controller/album/album_list_controller.dart';
import 'package:heathee/model/util/error.dart';

class AlbumMainController extends GetxController{
  bool isCancel = false;
  bool loading = false;
  bool isNotExist = false;
  String currentNickName;
  final mainScrollController = ScrollController(keepScrollOffset: true);
  AlbumListController albumListController = Get.put(AlbumListController());
  AlbumDetailController albumDetailController = Get.put(AlbumDetailController());
  static AlbumMainController get to => Get.find<AlbumMainController>();

  init(String name) async {
    print("앨범메인 init");
    this.loading = true;
    resetBeforeInit();
    try {
      await albumListController.loadAlbumList(false);
    }on InBlackListException{
      Get.back();
      Get.snackbar("경고", "넌 불낙이야");
    }
    print("리스트 초기화 완료");
    mainScrollController.addListener(_mainScrollController);
    currentNickName=name;
    this.loading = false;
    print("메인 초기화 완료");
    return "done";
  }

  resetBeforeInit(){
    albumListController.myTempList = [];
    albumListController.tempList = [];
    albumListController.albumLists = [];
    albumListController.myAlbumLists = [];
    albumListController.endAt = Map<int,int>();
    this.isCancel=false;
  }

  selectYear(context, nickname) async {
    showModalBottomSheet(
        isScrollControlled: true,
        context: context,
        builder: (context) => Container(
          width: Get.width,
          height: Get.height * 0.3,
          child: YearPicker(
            selectedDate: DateTime.now(),
            firstDate: DateTime(1960),
            lastDate: DateTime.now(),
            onChanged: (_) async {
              albumListController.year = _.year.toString();
              update();
              Get.back();
            },
          ),
        ));
  }

   _mainScrollController() {
    print("스크롤 감지");
    if (isNotExist) return;
    if (loading) {
      return;
    }
    double isEnd = (mainScrollController.position.maxScrollExtent * 0.95);
    if (mainScrollController.offset > isEnd) {
      this.loading = true;
      if (!isNotExist) {
        print('더있어요');
         albumListController.loadAlbumList(true);
      }
    }
  }
  setMode(isCancel){
    this.isCancel=isCancel;
    update();
  }
}
