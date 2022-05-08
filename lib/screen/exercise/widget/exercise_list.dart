import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:heathee/model/exercise/exercise.dart';
import 'package:heathee/model/exercise/rating.dart';

class ExerciseListWidget extends StatelessWidget {
  final exerciseList;

  const ExerciseListWidget({this.exerciseList});

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          children: <Widget>[
            Row(
              children: <Widget>[
                Container(
                  width: 70,
                  height: 70,
                  child: ClipRRect(
                      borderRadius: BorderRadius.circular(8),
                      child: Image.asset(
                          "assets/exercise/${exerciseList.name}/${exerciseList.name}.jpg")),
                ),
                SizedBox(
                  width: 10,
                ),
                Expanded(
                  child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Text(
                          exerciseList.ko_name,
                          style: TextStyle(fontSize: 20),
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: <Widget>[
                            Text(
                              " ${(exerciseList.reviewAvg != null) ? exerciseList.reviewAvg.substring(0, exerciseList.reviewAvg.length - 3) : 0.00} ★ ",
                              style: TextStyle(fontSize: 16),
                            ),
                            Container(
                              width: 1,
                              height: 14,
                              color: Colors.black,
                            ),
                            Text(
                              "${exerciseList.reviewCount}개",
                              style: TextStyle(fontSize: 16),
                            ),
                          ],
                        ),
                      ]),
                ),
                FlatButton(
                  onPressed: () {
                    print(exerciseList.name);
                    Get.toNamed('/exercise', arguments: exerciseList.name);
                  },
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(8.0),
                    child: Container(
                      height: 30,
                      width: 30,
                      color: Colors.greenAccent,
                      child: Center(child: Text("보기")),
                    ),
                  ),
                ),
              ],
            ),
            SizedBox(
              height: 15,
            ),
            CarouselSlider(
              items: [
                Container(
                  width: Get.width,
                  margin: EdgeInsets.symmetric(horizontal: 5.0),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(8.0),
                    child: Image.asset(
                      "assets/exercise/${exerciseList.name}/${exerciseList.name}.jpg",
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
                Container(
                  width: Get.width,
                  margin: EdgeInsets.symmetric(horizontal: 5.0),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(8.0),
                    child: Image.asset(
                      "assets/exercise/${exerciseList.name}/${exerciseList.name}.jpg",
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
                Container(
                  width: Get.width,
                  margin: EdgeInsets.symmetric(horizontal: 5.0),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(8.0),
                    child: Image.asset(
                      "assets/exercise/${exerciseList.name}/${exerciseList.name}.jpg",
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
              ],
              options: CarouselOptions(
                autoPlay: false,
                height: 200,
                aspectRatio: 4 / 3,
              ),
            ),
            SizedBox(
              height: 10,
            ),
          ],
        ),
      ),
    );
  }
}
