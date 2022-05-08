import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:get/get.dart';
import 'package:heathee/controller/exercise/exercise_page_controller.dart';

import 'package:kakao_flutter_sdk/local.dart';

class RatingChart extends StatelessWidget {
  ExercisePageController exercisePageController =
      Get.put(ExercisePageController());
  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 12.0),
          child: GestureDetector(
            onTap: () {
              Get.toNamed('/exerciseReviewReading');
            },
            child: Row(
              mainAxisSize: MainAxisSize.max,
              children: <Widget>[
                Expanded(
                    child: Text(
                  "평점 및 리뷰",
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                )),
                IconButton(
                    iconSize: 15,
                    icon: Icon(Icons.arrow_forward),
                    onPressed: () {
                      Get.toNamed('/exerciseReviewReading');
                    })
              ],
            ),
          ),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 8.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: <Widget>[
              Column(
                mainAxisAlignment: MainAxisAlignment.start,
                children: <Widget>[
                  Text(
                    exercisePageController.rating.reviewAvg.substring(
                        0,
                        exercisePageController.rating.reviewAvg.length -
                            3), // <- 평점 변수 넣을 곳
                    style: TextStyle(
                        fontSize: Get.width / 4,
                        color: Colors.green,
                        fontWeight: FontWeight.bold),
                  ),
                  RatingBarIndicator(
                    rating:
                        stringToDouble(exercisePageController.rating.reviewAvg),
                    itemBuilder: (context, index) => Icon(
                      Icons.star,
                      color: Colors.amber,
                    ),
                    itemCount: 5,
                    itemSize: 15.0,
                    direction: Axis.horizontal,
                  ),
                  Text(exercisePageController.rating.reviewCount.toString())
                ],
              ),
              Divider(
                height: 1,
                thickness: 1,
                color: Colors.black,
              ),
              SizedBox(
                  width: Get.width / 2.5,
                  height: Get.width / 4,
                  child: RotatedBox(
                      quarterTurns: 1, child: BarChart(randomData()))),
            ],
          ),
        ),
      ],
    );
  }

  BarChartGroupData makeGroupData(
    int x,
    double y, {
    bool isTouched = false,
    Color barColor = Colors.white,
    double width = 10,
    List<int> showTooltips = const [],
  }) {
    return BarChartGroupData(
      x: x,
      barRods: [
        BarChartRodData(
          y: isTouched ? y + 1 : y,
          color: isTouched ? Colors.yellow : barColor,
          width: width,
          backDrawRodData: BackgroundBarChartRodData(
            show: true,
            y: 100,
            color: Colors.grey,
          ),
        ),
      ],
      showingTooltipIndicators: showTooltips,
    );
  }

  BarChartData randomData() {
    return BarChartData(
      barTouchData: BarTouchData(
        enabled: false,
      ),
      titlesData: FlTitlesData(
        show: true,
        bottomTitles: SideTitles(
          rotateAngle: 270,
          showTitles: true,
          textStyle: TextStyle(
              color: Colors.black, fontWeight: FontWeight.bold, fontSize: 12),
          margin: 16,
          getTitles: (double value) {
            switch (value.toInt()) {
              case 0:
                return '1';
              case 1:
                return '2';
              case 2:
                return '3';
              case 3:
                return '4';
              case 4:
                return '5';
              default:
                return '';
            }
          },
        ),
        leftTitles: SideTitles(
          showTitles: false,
        ),
      ),
      borderData: FlBorderData(
        show: false,
      ),
      barGroups: List.generate(5, (i) {
        switch (i) {
          case 0:
            return makeGroupData(
                0,
                (exercisePageController.rating.reviewCount == 0)
                    ? 0
                    : (exercisePageController.rating.oneCount /
                            exercisePageController.rating.reviewCount) *
                        100,
                barColor: Colors.green);
          case 1:
            return makeGroupData(
                1,
                (exercisePageController.rating.reviewCount == 0)
                    ? 0
                    : (exercisePageController.rating.twoCount /
                            exercisePageController.rating.reviewCount) *
                        100,
                barColor: Colors.green);
          case 2:
            return makeGroupData(
                2,
                (exercisePageController.rating.reviewCount == 0)
                    ? 0
                    : (exercisePageController.rating.threeCount /
                            exercisePageController.rating.reviewCount) *
                        100,
                barColor: Colors.green);
          case 3:
            return makeGroupData(
                3,
                (exercisePageController.rating.reviewCount == 0)
                    ? 0
                    : (exercisePageController.rating.fourCount /
                            exercisePageController.rating.reviewCount) *
                        100,
                barColor: Colors.green);
          case 4:
            return makeGroupData(
                4,
                (exercisePageController.rating.reviewCount == 0)
                    ? 0
                    : (exercisePageController.rating.fiveCount /
                            exercisePageController.rating.reviewCount) *
                        100,
                barColor: Colors.green);
          default:
            return null;
        }
      }),
      minY: 0,
      maxY: 100,
    );
  }
}
