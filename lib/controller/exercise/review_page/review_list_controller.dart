import 'package:get/get.dart';
import 'package:heathee/model/exercise/review.dart';

class ReviewListController extends GetxController {
  RxList _items = List<Review>().obs;

  int offset = 0;
  int commentCount;
  int nowPage = 1;
  int lastPage;
  bool isEnd = false;

  List<Review> get items => _items.value;

  set items(responseData) {
    List<Review> reviewList = [];
    if (responseData != null) {
      for (var r in responseData['reviews']) {
        Review exerciseList = Review.fromJson(r);
        reviewList.add(exerciseList);
      }
      _items.addAll(reviewList);
    }

    lastPage = responseData['lastPage'];

    if (nowPage >= lastPage)
      isEnd = true;
    else
      isEnd = false;
  }
}
