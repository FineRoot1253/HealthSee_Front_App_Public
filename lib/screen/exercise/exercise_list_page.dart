import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:heathee/controller/exercise/list_page/exercise_list_controller.dart';
import 'package:heathee/controller/exercise/list_page/exercise_list_page_controller.dart';
import 'package:heathee/controller/exercise/list_page/list_scroll_controller.dart';
import 'package:heathee/screen/exercise/widget/exercise_list.dart';

class ExerciseListPage extends StatefulWidget {
  @override
  _ExerciseListPageState createState() => _ExerciseListPageState();
}

class _ExerciseListPageState extends State<ExerciseListPage> {
  ExerciseListPageController exerciseListPageController =
      Get.put(ExerciseListPageController());
  ExerciseListController exerciseListController =
      Get.put(ExerciseListController());
  ListScrollController listScrollController = Get.put(ListScrollController());
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    exerciseListPageController.init();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
        child: FutureBuilder(
            future: exerciseListPageController.initalizeControllerFuture,
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.done)
                return Scaffold(
                  appBar: AppBar(
                    title: Row(
                      children: <Widget>[
                        Expanded(
                            child: TextField(
                          controller:
                              exerciseListPageController.textEditingController,
                        )),
                        IconButton(
                            icon: Icon(Icons.search),
                            onPressed: () {
                              Get.toNamed('/exerciseSearchList',
                                  arguments: exerciseListPageController
                                      .textEditingController.text);
                            })
                      ],
                    ),
                  ),
                  body: GetX<ExerciseListController>(
                      builder: (_) => ListView.builder(
                            controller: listScrollController.scrollController,
                            physics: AlwaysScrollableScrollPhysics(),
                            itemCount: _.items.length,
                            itemBuilder: (context, i) =>
                                GetX<ExerciseListController>(
                                    builder: (controller) => ExerciseListWidget(
                                          exerciseList: controller.items[i],
                                        )),
                          )),
                );
              return Center(
                child: CircularProgressIndicator(),
              );
            }));
  }
}
