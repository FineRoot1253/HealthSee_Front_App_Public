import 'package:carousel_slider/carousel_slider.dart';
import 'package:chewie/chewie.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:heathee/controller/exercise/exercise_page_controller.dart';
import 'package:heathee/screen/exercise/widget/rating_chart.dart';
import 'package:heathee/screen/exercise/widget/review_comments.dart';
import 'package:heathee/screen/exercise/widget/review_writing.dart';

class ExerciseDetailPage extends StatelessWidget {
  final ExercisePageController exercisePageController =
      Get.put(ExercisePageController());
  String EX_Name = Get.arguments;

  @override
  Widget build(BuildContext context) {
    return GetBuilder<ExercisePageController>(
      init: exercisePageController.init(EX_Name),
      builder: (controller) => FutureBuilder(
          future: controller.initalizeControllerFuture,
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.done)
              return SafeArea(
                  child: Scaffold(
                appBar: AppBar(
                  title: Text(exercisePageController.exercise.ko_name),
                ),
                body: SingleChildScrollView(
                  child: Padding(
                      padding: EdgeInsets.all(8.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          SizedBox(
                            height: 10,
                          ),
                          _buildCarouselSlider(),
                          SizedBox(
                            height: 15,
                          ),
                          _buildTextButton(),
                          Padding(
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 12.0),
                              child: Text(
                                exercisePageController.exercise.detail,
                                overflow: TextOverflow.clip,
                                maxLines: 1,
                                softWrap: false,
                              )),
                          SizedBox(
                            height: 15,
                          ),
                          Padding(
                            padding:
                                const EdgeInsets.symmetric(horizontal: 12.0),
                            child: Text(
                                "운동 생성 날짜 : ${exercisePageController.exercise.creationDate}"),
                          ),
                          Padding(
                            padding:
                                const EdgeInsets.symmetric(horizontal: 12.0),
                            child: Text(
                                "운동 업데이트 날짜 : ${exercisePageController.exercise.updateDate}"),
                          ),
                          SizedBox(
                            height: 15,
                          ),
                          RatingChart(),
                          SizedBox(
                            height: 15,
                          ),
                          (exercisePageController.myReview == null)
                              ? ReviewWriting(
                                  exercise: EX_Name,
                                )
                              : ReviewWriting(
                                  exercise: EX_Name,
                                  rating:
                                      exercisePageController.myReview.rating,
                                  review:
                                      exercisePageController.myReview.content,
                                  creationDate: exercisePageController
                                      .myReview.creationDate,
                                ),
                          ReviewComments(),
                        ],
                      )),
                ),
              ));
            return Center(
              child: CircularProgressIndicator(),
            );
          }),
    );
  }

  Padding _buildTextButton() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 12.0),
      child: GestureDetector(
        onTap: () {
          Get.toNamed('/exerciseDescription',
              arguments: exercisePageController.exercise.detail);
        },
        child: Row(
          mainAxisSize: MainAxisSize.max,
          children: <Widget>[
            Expanded(
                child: Text(
              "운동 소개",
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            )),
            IconButton(
                iconSize: 15,
                icon: Icon(Icons.arrow_forward),
                onPressed: () {
                  Get.toNamed('/exerciseDescription',
                      arguments: exercisePageController.exercise.detail);
                })
          ],
        ),
      ),
    );
  }

  CarouselSlider _buildCarouselSlider() {
    return CarouselSlider(
      items: [
        ClipRRect(
          borderRadius: BorderRadius.circular(8),
          child: FittedBox(
            child: Chewie(
              controller: exercisePageController.chewieController,
            ),
          ),
        ),
        Container(
          margin: EdgeInsets.symmetric(horizontal: 5.0),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(8.0),
            child: Image.asset(
              "assets/exercise/${exercisePageController.exercise.name}/${exercisePageController.exercise.name}.jpg",
            ),
          ),
        ),
        Container(
          margin: EdgeInsets.symmetric(horizontal: 5.0),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(8.0),
            child: Image.asset(
              "assets/exercise/${exercisePageController.exercise.name}/${exercisePageController.exercise.name}.jpg",
            ),
          ),
        ),
        Container(
          margin: EdgeInsets.symmetric(horizontal: 5.0),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(8.0),
            child: Image.asset(
              "assets/exercise/${exercisePageController.exercise.name}/${exercisePageController.exercise.name}.jpg",
            ),
          ),
        ),
      ],
      options: CarouselOptions(
        onPageChanged: (index, reason) {
          exercisePageController.chewieController.pause();
        },
        autoPlay: false,
        height: 200,
        aspectRatio: 4 / 3,
      ),
    );
  }
}
