import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:heathee/controller/exercise/exercise_page_controller.dart';

class ExerciseDescriptionPage extends StatelessWidget {
  ExercisePageController exercisePageController =
      Get.put(ExercisePageController());
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          title: Text("${exercisePageController.exercise.ko_name}의 자세한 설명"),
        ),
        body: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Text("${exercisePageController.exercise.detail}"),
        ),
      ),
    );
  }
}
