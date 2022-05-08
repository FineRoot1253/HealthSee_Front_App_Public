import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:heathee/controller/exercise/list_page/exercise_list_controller.dart';
import 'package:heathee/controller/exercise/list_page/list_scroll_controller.dart';
import 'package:heathee/controller/http_controller.dart';
import 'package:heathee/keyword/ip.dart';
import 'package:heathee/keyword/url.dart';

class ExerciseListPageController extends GetxController {
  // 그냥 운동 리스트 받아올 때
  Future<void> initalizeControllerFuture;
  // 검색한 운동 리스트 받아올 때
  Future<void> initalizeControllerFuture2;

  TextEditingController textEditingController = TextEditingController();
  bool isLoading = false;
  String keyword = "";
  Future<void> init() {
    initalizeControllerFuture = getExerciseList();
  }

  Future<void> search(String keyword) {
    this.keyword = keyword;
    initalizeControllerFuture2 = searchExerciseList();
  }

  // 기본적으로 운동을 받아올 때
  getExerciseList() async {
    if (isLoading) return;
    isLoading = true;
    if (Get.find<ExerciseListController>().isEnd) return;
    String url =
        'http://$IP$EXERCISELIST/?keyword=&offset=${Get.find<ExerciseListController>().offset}';
    var responseData = await HttpController.to.httpManeger('GET', url);
    print(responseData);
    Get.find<ExerciseListController>().items = responseData;
    isLoading = false;
  }

  // 검색으로 운동리스트를 받아올 때
  searchExerciseList() async {
    if (isLoading) return;
    isLoading = true;
    await Get.find<SearchedListScrollController>().reset();
    String url =
        'http://$IP$EXERCISELIST/?keyword=$keyword&offset=${Get.find<ExerciseSearchedListController>().searchedOffset}';
    var responseData = await HttpController.to.httpManeger('GET', url);
    print(responseData);
    Get.find<ExerciseSearchedListController>().init = responseData;
    isLoading = false;
  }

  searchMoreExerciseList() async {
    if (isLoading) return;
    isLoading = true;
    if (Get.find<ExerciseSearchedListController>().isEnd) return;
    String url =
        'http://$IP$EXERCISELIST/?keyword=$keyword&offset=${Get.find<ExerciseSearchedListController>().searchedOffset}';
    var responseData = await HttpController.to.httpManeger('GET', url);
    print(responseData);
    Get.find<ExerciseSearchedListController>().add = responseData;
    isLoading = false;
  }
}
