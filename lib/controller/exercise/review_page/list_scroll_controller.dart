import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:heathee/controller/exercise/review_page/review_list_controller.dart';
import 'package:heathee/controller/exercise/review_page/review_list_page_controller.dart';

class ReviewScrollController extends GetxController {
  var scrollController = ScrollController(keepScrollOffset: false);

  void onScroll() {
    if (Get.find<ReviewListPageController>().isLoading) return;
    if (Get.find<ReviewListController>().isEnd) return;

    if (scrollController.offset >
        scrollController.position.maxScrollExtent * 0.9) {
      print(scrollController.position.maxScrollExtent * 0.9);
      Get.find<ReviewListController>().nowPage++;
      Get.find<ReviewListPageController>().getReviewList();
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
