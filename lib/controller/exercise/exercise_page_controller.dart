import 'package:chewie/chewie.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:heathee/controller/http_controller.dart';
import 'package:heathee/keyword/ip.dart';
import 'package:heathee/keyword/url.dart';
import 'package:heathee/model/exercise/exercise.dart';
import 'package:heathee/model/exercise/rating.dart';
import 'package:heathee/model/exercise/review.dart';
import 'package:video_player/video_player.dart';

class ExercisePageController extends GetxController {
  Future<void> initalizeControllerFuture;
  String EX_Name;
  VideoPlayerController videoPlayerController1;
  ChewieController chewieController;
  bool isFirst = true;

  Exercise _exercise;
  Exercise get exercise => _exercise;
  set exercise(responseData) => _exercise = Exercise.fromJson(responseData);

  Rating _rating;
  Rating get rating => _rating;
  set rating(responseData) {
    _rating = Rating.fromJson(responseData);
    if (_rating.reviewAvg == null) _rating.reviewAvg = "0.0";
  }

  // 리뷰작성할 때 사용하는 텍스트 컨트롤러
  TextEditingController _textEditingController = TextEditingController();
  TextEditingController get textEditingController => _textEditingController;

  // 미리보기로 보여주는 최대 개의 리뷰
  List<Review> _showReviews = [];
  List<Review> get showReviews => _showReviews;
  set showReviews(responseData) {
    print("asdsda");
    int i = 0;
    List<Review> reviews = [];
    if (responseData != null) {
      for (var r in responseData) {
        print(++i);
        Review review = Review.fromJson(r);
        reviews.add(review);
      }
      _showReviews.addAll(reviews);
    }
  }

  // 내가 작성한 리뷰
  Review _myReview;
  Review get myReview => _myReview;
  set myReview(responseData) {
    _myReview = Review.fromJson(responseData);

    _textEditingController.text = _myReview.content;
  }

  @override
  init(String name) {
    EX_Name = name;
    initalizeControllerFuture = getExercisePage();
  }

  settingPage(responseData) {
    this.exercise = responseData['exercise'];
    this.rating = responseData['exerciserate'];

    if (isFirst) {
      videoPlayerController1 = VideoPlayerController.asset(
          'assets/exercise/${this.exercise.name}/${this.exercise.name}.mp4');
      chewieController = ChewieController(
          videoPlayerController: videoPlayerController1,
          autoInitialize: true,
          autoPlay: false,
          looping: false,
          aspectRatio: 4 / 3);

      isFirst = false;
    }

    if (responseData['myComment'] != null)
      this.myReview = responseData['myComment'];
    if (responseData['comments'] != null)
      this.showReviews = responseData['comments'];

    update();
  }

  Future<void> getExercisePage() async {
    var url = "http://$IP$EXERCISEREAD$EX_Name";
    var responseData = await HttpController.to.httpManeger("GET", url);
    settingPage(responseData);
  }

  Future<void> createOrUpdateReview({double rank, String content}) async {
    var url = "http://$IP/$EXERCISEREVIEW";
    var body = {
      "rank": rank.toString(),
      "content": content,
      "name": this.exercise.name
    };
    var responseData = await HttpController.to.httpManeger("POST", url, body);
    settingPage(responseData);
    Get.back();
  }
}
