import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:heathee/controller/exercise/exercise_page_controller.dart';
import 'package:heathee/screen/exercise/widget/comment.dart';

class ReviewComments extends StatelessWidget {
  ExercisePageController exercisePageController =
      Get.put(ExercisePageController());
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.all(8),
      child: Column(
        children: (exercisePageController.showReviews.isNotEmpty)
            ? buildComments()
            : <Widget>[
                Center(
                  child: Container(
                    child: (exercisePageController.showReviews == null)
                        ? Text("첫 리뷰를 남겨보세요")
                        : Text("리뷰가 없습니다."),
                  ),
                )
              ],
      ),
    );
  }

  List<Widget> buildComments() {
    List<Widget> commentTiles = [];
    for (int i = 0; i < 3; i++) {
      commentTiles.add(Comment(
        review: exercisePageController.showReviews[i],
      ));
    }
    return commentTiles;
  }
}
