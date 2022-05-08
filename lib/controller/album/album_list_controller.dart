import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:heathee/api/timeset.dart';
import 'package:heathee/controller/account_controller.dart';
import 'package:heathee/controller/album/album_main_controller.dart';
import 'package:heathee/controller/http_controller.dart';
import 'package:heathee/keyword/ip.dart';
import 'package:heathee/keyword/url.dart';
import 'package:heathee/model/album/album_list.dart';
import 'package:heathee/model/util/error.dart';

class AlbumListController extends GetxController {
  int AL_Code;
  int month;
  Map<int,int> endAt = Map<int, int>();
  bool isNotExist = false;
  bool loading = false;
  String currentNickname;
  String AL_Creation_Date;
  Image AL_FirstPicture;
  String AL_Scope;
  String year;

  List<List<AlbumList>> myAlbumLists= [];
  List<List<AlbumList>> albumLists= [];
  List<AlbumList> myTempList = [];
  List<AlbumList> tempList = [];
  Future listResult;

//  init(String name) async {
//    print("앨범리스트 init");
//    this.currentNickname = name;
//    int count = 1;
//    this.month = count;
//    var result;
//    while(count<13){
//      print(count);
//      result = await loadAlbumList(false);
//      if(result == 'done') {
//        print("받아온 현재 원본 리스트 사이즈 : ${albumLists[count].length}");
//        scrollController[count] = ScrollController(keepScrollOffset: false);
//        scrollController[count].addListener(_scrollListener);
//      }
//      count++;
//      this.month = count;
//    }
//
//    print("받아온 원본 리스트 사이즈 : ${albumLists[count].length}");
//    print("받아온 내 리스트 사이즈 : ${myAlbumLists[count].length}");
//    return 'done';
//  }

  loadAlbumList(bool isNext) async {
//    this.albumLists = [];
//    List<AlbumList> mytempAlbumList = [];
    this.tempList = [];
    this.myTempList = [];
    String url;
    if (!isNext)
      url = 'http://$IP$ALBUMLIST/?name=$currentNickname&year=$year&month=$month';
    else
      url = 'http://$IP$ALBUMLIST/?name=$currentNickname&year=$year&month=$month&AL_Code=$endAt';

    var responseData = await HttpController.to.httpManeger("GET", url);

    if (responseData == 'Black') {
      print("넌 불락이야");
      throw InBlackListException();
    }

    List<dynamic> temp  = responseData["albumList"];
    if(temp.isEmpty) {
      print("없어");
      return 'null';
    }
    for (var AL in responseData["albumList"]) {
      try {
        AlbumList albumList = AlbumList(
            AL["AL_Code"],
            AL["AL_Creation_Date"],
            AL["AL_Scope"],
            AL["Account_AC_NickName"],
            Image.memory(
                Uint8List.fromList(AL["AL_Thumbnail"]["data"].cast<int>())));
        this.tempList.add(albumList);
      }catch(e){
        print("${e}");
      }

    }
    print("page state : [ $currentNickname, ${AccountController.to.nickname} ]");

    if (currentNickname == AccountController.to.nickname) {
      myTempList = List.from(this.tempList);
      this.myAlbumLists+=getSeparatedAlbumList();
    }else{
      this.albumLists+=getSeparatedAlbumList();
    }
    int counts = responseData["AlbumCount"];

    if (counts == null)
      AlbumMainController.to.isNotExist = true;
    else if (counts <= 10)
      AlbumMainController.to.isNotExist = true;
    else
      AlbumMainController.to.isNotExist = false;

    endAt = {this.month : this.tempList[this.tempList.length - 1].AL_Code};
    loading = false;
    update();
    AlbumMainController.to.update();
    print("리스트 로딩 끝 ${AlbumMainController.to.isNotExist}");
    return 'done';
  }

  Future<Null> refreshAlbumLists(String nickname) async {
    this.albumLists = [];
    this.loading = true;
    this.currentNickname = nickname;
  await AlbumMainController.to.init(this.currentNickname);
  }

  List<List<AlbumList>> getSeparatedAlbumList() {
    String month;
    List<AlbumList> tempList = [];
    List<AlbumList> tempAlbumList = [];
    List<List<AlbumList>> separatedAlbumList= [];
    if (currentNickname != AccountController.to.nickname) {
      tempAlbumList = this.tempList;
    } else {
      tempAlbumList = myTempList;
    }
    month = getDate(tempAlbumList[0].AL_Creation_Date,"MONTH");
    tempAlbumList.forEach((element) {
      if (month != getDate(element.AL_Creation_Date,"MONTH")) {
        month = getDate(element.AL_Creation_Date,"MONTH");
        separatedAlbumList.add(tempList);
        tempList=[];
      }
      tempList.add(element);
    });


    separatedAlbumList.add(tempList);
    return separatedAlbumList;
  }


}
