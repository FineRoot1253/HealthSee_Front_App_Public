import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:heathee/controller/exercise/review_page/list_scroll_controller.dart';
import 'package:heathee/controller/exercise/review_page/review_list_controller.dart';
import 'package:heathee/controller/exercise/review_page/review_list_page_controller.dart';
import 'package:heathee/screen/exercise/widget/comment.dart';

class ExerciseReviewReading extends StatefulWidget {
//  final GlobalKey<RefreshIndicatorState> _refreshIndicatorKey =
//      new GlobalKey<RefreshIndicatorState>();
  @override
  _ExerciseReviewReadingState createState() => _ExerciseReviewReadingState();
}

class _ExerciseReviewReadingState extends State<ExerciseReviewReading> {
  ReviewListPageController reviewListPageController =
      Get.put(ReviewListPageController());
  ReviewListController reviewListController = Get.put(ReviewListController());
  ReviewScrollController listScrollController =
      Get.put(ReviewScrollController());
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    reviewListPageController.init();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
        child: Scaffold(
            appBar: AppBar(
              title: Text("${reviewListPageController.ko_name}의 리뷰들"),
            ),
            body: FutureBuilder(
                future: reviewListPageController.initalizeControllerFuture,
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.done)
                    return GetX<ReviewListController>(
                      builder: (_) => (reviewListController.items.length == 0)
                          ? Center(
                              child: Text("리뷰가 없습니다."),
                            )
                          : ListView.builder(
                              controller: listScrollController.scrollController,
                              itemCount: reviewListController.items.length,
                              itemBuilder: (context, i) => Comment(
                                    review: reviewListController.items[i],
                                  )),
                    );
                  return Center(
                    child: CircularProgressIndicator(),
                  );
                })));
  }
}
