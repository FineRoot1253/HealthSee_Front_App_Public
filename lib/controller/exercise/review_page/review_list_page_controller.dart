import 'package:get/get.dart';
import 'package:heathee/controller/exercise/exercise_page_controller.dart';
import 'package:heathee/controller/exercise/review_page/review_list_controller.dart';
import 'package:heathee/controller/http_controller.dart';
import 'package:heathee/keyword/ip.dart';
import 'package:heathee/keyword/url.dart';

class ReviewListPageController extends GetxController {
  Future<void> initalizeControllerFuture;
  bool isLoading = false;
  String name = Get.find<ExercisePageController>().exercise.name;
  String ko_name = Get.find<ExercisePageController>().exercise.ko_name;

  Future<void> init() {
    initalizeControllerFuture = getReviewList();
  }

  getReviewList() async {
    if (isLoading) return;
    isLoading = true;
    if (Get.find<ReviewListController>().isEnd) return;
    String url =
        'http://$IP/$EXERCISEREVIEW/$name&${Get.find<ReviewListController>().nowPage}';
    var responseData = await HttpController.to.httpManeger('GET', url);
    Get.find<ReviewListController>().items = responseData;
    isLoading = false;
  }
}
