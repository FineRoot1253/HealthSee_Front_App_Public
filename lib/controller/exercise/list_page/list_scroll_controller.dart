import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:heathee/controller/exercise/list_page/exercise_list_controller.dart';
import 'package:heathee/controller/exercise/list_page/exercise_list_page_controller.dart';

class ListScrollController extends GetxController {
  var scrollController = ScrollController(keepScrollOffset: false);

  void onScroll() {
    if (Get.find<ExerciseListPageController>().isLoading) return;
    if (Get.find<ExerciseSearchedListController>().isEnd) return;

    if (scrollController.offset >
        scrollController.position.maxScrollExtent * 0.9) {
      print(scrollController.position.maxScrollExtent * 0.9);
      Get.find<ExerciseListPageController>().getExerciseList();
    }
  }

  @override
  void onInit() {
    // TODO: implement onInit
    super.onInit();
    scrollController.addListener(onScroll);
  }

  @override
  void onClose() {
    // TODO: implement onClose
    super.onClose();
    scrollController.removeListener(onScroll);
  }
}

class SearchedListScrollController extends GetxController {
  var scrollController = ScrollController(keepScrollOffset: false);
  bool isFirst = true;
  void onScroll() {
    if (Get.find<ExerciseListPageController>().isLoading) return;
    if (Get.find<ExerciseSearchedListController>().isEnd) return;
    if (scrollController.offset >
        scrollController.position.maxScrollExtent * 0.9) {
      print(scrollController.position.maxScrollExtent * 0.9);
      Get.find<ExerciseListPageController>().searchMoreExerciseList();
    }
  }

  Future<void> reset() async {
    print("여기서 문제입니다.");
    if (isFirst) return;
    print("여기서 문제입니다.");
    await scrollController.animateTo(0,
        duration: Duration(milliseconds: 500), curve: Curves.linear);
    scrollController.removeListener(onScroll);
    scrollController?.dispose();
    scrollController = ScrollController(keepScrollOffset: false);
    scrollController.addListener(onScroll);
  }

  @override
  void onInit() {
    // TODO: implement onInit
    super.onInit();
    scrollController.addListener(onScroll);
  }

  @override
  void onClose() {
    // TODO: implement onClose
    super.onClose();
    scrollController.removeListener(onScroll);
  }
}
