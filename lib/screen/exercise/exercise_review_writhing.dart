import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:get/get.dart';
import 'package:heathee/controller/exercise/exercise_page_controller.dart';

class ExerciseReviewWriting extends StatelessWidget {
  double nowRating = double.parse(Get.parameters['rating']);
  ExercisePageController exercisePageController =
      Get.put(ExercisePageController());

  @override
  Widget build(BuildContext context) {
    return SafeArea(
        child: Scaffold(
      appBar: AppBar(
        title: Text("${exercisePageController.exercise.ko_name} 평가 및 리뷰"),
        actions: <Widget>[
          FlatButton(
              onPressed: () async {
                await exercisePageController.createOrUpdateReview(
                    rank: nowRating,
                    content: exercisePageController.textEditingController.text);
              },
              child: Text("게시"))
        ],
      ),
      body: Padding(
        padding: EdgeInsets.all(8.0),
        child: Column(
          children: <Widget>[
            SizedBox(
              height: Get.height / 10,
            ),
            RatingBar(
              initialRating: nowRating,
              minRating: 1,
              direction: Axis.horizontal,
              allowHalfRating: false,
              itemCount: 5,
              itemPadding: EdgeInsets.symmetric(horizontal: 4.0),
              itemBuilder: (context, _) => Icon(
                Icons.star,
                color: Colors.yellow,
              ),
              onRatingUpdate: (rating) {
                nowRating = rating;
              },
            ),
            TextField(
              controller: exercisePageController.textEditingController,
              maxLength: 500,
              decoration: InputDecoration(
                  helperText: "운동경험에 대해 작성(선택사항)",
                  border: OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.black))),
            )
          ],
        ),
      ),
    ));
  }
}
